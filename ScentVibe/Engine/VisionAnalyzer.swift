import UIKit
import Vision
import CoreImage

// MARK: - Analysis Result

struct ImageAnalysisResult: Sendable {
    let dominantColors: [ColorInfo]  // Up to 5 dominant colors
    let sceneClassifications: [String]  // Scene labels from VNClassifyImageRequest
    let brightness: Double  // 0-1 average brightness
    let warmth: Double  // 0-1 (0=very cool, 0.5=neutral, 1=very warm)
    let saturation: Double  // 0-1 average saturation
    let isOutfit: Bool  // True if clothing/person detected
    let isRoom: Bool  // True if indoor scene detected
    let detectedMoods: [MoodTag: Double]  // Mood scores derived from visual analysis

    var scanType: String {
        if isOutfit { return "outfit" }
        if isRoom { return "room" }
        return "general"
    }
}

struct ColorInfo: Codable, Hashable, Sendable {
    let hue: Double       // 0-360
    let saturation: Double // 0-1
    let brightness: Double // 0-1
    let weight: Double    // 0-1 (proportion of image)

    var hexString: String {
        let color = UIColor(hue: hue / 360.0, saturation: saturation, brightness: brightness, alpha: 1.0)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: nil)
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }

    var colorName: String {
        if saturation < 0.1 {
            if brightness > 0.9 { return "White" }
            if brightness < 0.2 { return "Black" }
            return "Gray"
        }
        switch hue {
        case 0..<15, 345..<360: return "Red"
        case 15..<45: return "Orange"
        case 45..<75: return "Yellow"
        case 75..<150: return "Green"
        case 150..<195: return "Teal"
        case 195..<255: return "Blue"
        case 255..<285: return "Purple"
        case 285..<345: return "Pink"
        default: return "Neutral"
        }
    }

    var asArray: [Double] {
        [hue, saturation, brightness, weight]
    }
}

// MARK: - Vision Analyzer

final class VisionAnalyzer: @unchecked Sendable {

    static let shared = VisionAnalyzer()

    private init() {}

    func analyze(image: UIImage) async throws -> ImageAnalysisResult {
        guard let cgImage = image.cgImage else {
            throw AnalysisError.invalidImage
        }

        // Run analyses in parallel
        async let colors = extractDominantColors(from: cgImage)
        async let classifications = classifyScene(cgImage: cgImage)

        let dominantColors = try await colors
        let sceneLabels = try await classifications

        // Compute aggregate metrics
        let brightness = computeAverageBrightness(from: dominantColors)
        let warmth = computeWarmth(from: dominantColors)
        let saturation = computeAverageSaturation(from: dominantColors)

        // Determine scene type
        let isOutfit = detectOutfit(from: sceneLabels)
        let isRoom = detectRoom(from: sceneLabels)

        // Derive moods from visual properties
        let moods = deriveMoods(
            colors: dominantColors,
            brightness: brightness,
            warmth: warmth,
            saturation: saturation,
            sceneLabels: sceneLabels
        )

        return ImageAnalysisResult(
            dominantColors: dominantColors,
            sceneClassifications: sceneLabels,
            brightness: brightness,
            warmth: warmth,
            saturation: saturation,
            isOutfit: isOutfit,
            isRoom: isRoom,
            detectedMoods: moods
        )
    }

    // MARK: - Dominant Color Extraction

    private func extractDominantColors(from cgImage: CGImage) throws -> [ColorInfo] {
        let ciImage = CIImage(cgImage: cgImage)
        let context = CIContext()

        // Resize for performance
        let scale = min(200.0 / Double(cgImage.width), 200.0 / Double(cgImage.height))
        let resized = ciImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))

        guard let resizedCG = context.createCGImage(resized, from: resized.extent) else {
            throw AnalysisError.processingFailed
        }

        // Sample pixels
        let width = resizedCG.width
        let height = resizedCG.height
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)

        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
              let ctx = CGContext(
                data: &pixelData,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
              ) else {
            throw AnalysisError.processingFailed
        }

        ctx.draw(resizedCG, in: CGRect(x: 0, y: 0, width: width, height: height))

        // K-means style clustering via bucketing
        var colorBuckets = [String: (h: Double, s: Double, b: Double, count: Int)]()

        let step = max(1, (width * height) / 1000)  // Sample ~1000 pixels
        for i in stride(from: 0, to: width * height, by: step) {
            let offset = i * bytesPerPixel
            let r = Double(pixelData[offset]) / 255.0
            let g = Double(pixelData[offset + 1]) / 255.0
            let b = Double(pixelData[offset + 2]) / 255.0

            var h: CGFloat = 0, s: CGFloat = 0, br: CGFloat = 0
            UIColor(red: r, green: g, blue: b, alpha: 1.0).getHue(&h, saturation: &s, brightness: &br, alpha: nil)

            // Bucket by hue (30-degree buckets) and brightness (3 levels)
            let hueBucket = Int(h * 12) // 12 hue buckets
            let brightBucket = Int(br * 3)
            let satBucket = s < 0.15 ? 0 : 1  // neutral vs. chromatic
            let key = "\(hueBucket)-\(brightBucket)-\(satBucket)"

            if var existing = colorBuckets[key] {
                existing.h += Double(h) * 360
                existing.s += Double(s)
                existing.b += Double(br)
                existing.count += 1
                colorBuckets[key] = existing
            } else {
                colorBuckets[key] = (h: Double(h) * 360, s: Double(s), b: Double(br), count: 1)
            }
        }

        let totalPixels = colorBuckets.values.reduce(0) { $0 + $1.count }

        let sorted = colorBuckets.values
            .sorted { $0.count > $1.count }
            .prefix(5)
            .map { bucket in
                ColorInfo(
                    hue: bucket.h / Double(bucket.count),
                    saturation: bucket.s / Double(bucket.count),
                    brightness: bucket.b / Double(bucket.count),
                    weight: Double(bucket.count) / Double(max(1, totalPixels))
                )
            }

        return Array(sorted)
    }

    // MARK: - Scene Classification

    private func classifyScene(cgImage: CGImage) async throws -> [String] {
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNClassifyImageRequest()

        do {
            try handler.perform([request])
        } catch {
            // Vision classification failed — return empty labels rather than crashing
            return []
        }

        let observations = request.results as? [VNClassificationObservation] ?? []
        return observations
            .filter { $0.confidence > 0.3 }
            .prefix(10)
            .map { $0.identifier }
    }

    // MARK: - Aggregate Metrics

    private func computeAverageBrightness(from colors: [ColorInfo]) -> Double {
        guard !colors.isEmpty else { return 0.5 }
        let weightedSum = colors.reduce(0.0) { $0 + $1.brightness * $1.weight }
        let totalWeight = colors.reduce(0.0) { $0 + $1.weight }
        return totalWeight > 0 ? weightedSum / totalWeight : 0.5
    }

    private func computeWarmth(from colors: [ColorInfo]) -> Double {
        guard !colors.isEmpty else { return 0.5 }
        var warmScore = 0.0
        var totalWeight = 0.0

        for color in colors {
            let hue = color.hue
            var w: Double
            // Warm hues: red(0/360), orange(30), yellow(60)
            // Cool hues: cyan(180), blue(240), purple(270)
            if hue < 75 || hue > 330 {
                w = 0.8 + (color.saturation * 0.2)  // warm
            } else if hue > 150 && hue < 300 {
                w = 0.2 - (color.saturation * 0.1)  // cool
            } else {
                w = 0.5  // neutral (green, teal)
            }
            warmScore += w * color.weight
            totalWeight += color.weight
        }

        return totalWeight > 0 ? warmScore / totalWeight : 0.5
    }

    private func computeAverageSaturation(from colors: [ColorInfo]) -> Double {
        guard !colors.isEmpty else { return 0.5 }
        let weightedSum = colors.reduce(0.0) { $0 + $1.saturation * $1.weight }
        let totalWeight = colors.reduce(0.0) { $0 + $1.weight }
        return totalWeight > 0 ? weightedSum / totalWeight : 0.5
    }

    // MARK: - Scene Detection

    private func detectOutfit(from labels: [String]) -> Bool {
        let outfitKeywords = ["clothing", "dress", "shirt", "jacket", "person", "fashion",
                              "suit", "coat", "shoe", "textile", "fabric", "denim",
                              "leather", "silk", "cotton", "wool", "accessory"]
        return labels.contains { label in
            outfitKeywords.contains { label.lowercased().contains($0) }
        }
    }

    private func detectRoom(from labels: [String]) -> Bool {
        let roomKeywords = ["room", "interior", "furniture", "indoor", "home", "house",
                           "bedroom", "kitchen", "living", "bathroom", "office",
                           "decoration", "wall", "floor", "ceiling", "window"]
        return labels.contains { label in
            roomKeywords.contains { label.lowercased().contains($0) }
        }
    }

    // MARK: - Mood Derivation

    private func deriveMoods(colors: [ColorInfo], brightness: Double, warmth: Double,
                             saturation: Double, sceneLabels: [String]) -> [MoodTag: Double] {
        var moods = [MoodTag: Double]()

        // Brightness-based moods
        if brightness > 0.7 {
            moods[.fresh] = (moods[.fresh] ?? 0) + 0.5
            moods[.energetic] = (moods[.energetic] ?? 0) + 0.3
            moods[.playful] = (moods[.playful] ?? 0) + 0.3
        } else if brightness < 0.35 {
            moods[.mysterious] = (moods[.mysterious] ?? 0) + 0.6
            moods[.sensual] = (moods[.sensual] ?? 0) + 0.3
            moods[.bold] = (moods[.bold] ?? 0) + 0.3
        }

        // Warmth-based moods
        if warmth > 0.65 {
            moods[.warm] = (moods[.warm] ?? 0) + 0.6
            moods[.cozy] = (moods[.cozy] ?? 0) + 0.4
            moods[.romantic] = (moods[.romantic] ?? 0) + 0.3
        } else if warmth < 0.35 {
            moods[.cool] = (moods[.cool] ?? 0) + 0.6
            moods[.fresh] = (moods[.fresh] ?? 0) + 0.4
            moods[.serene] = (moods[.serene] ?? 0) + 0.3
        }

        // Saturation-based moods
        if saturation > 0.6 {
            moods[.bold] = (moods[.bold] ?? 0) + 0.5
            moods[.energetic] = (moods[.energetic] ?? 0) + 0.3
            moods[.confident] = (moods[.confident] ?? 0) + 0.3
        } else if saturation < 0.2 {
            moods[.minimal] = (moods[.minimal] ?? 0) + 0.6
            moods[.elegant] = (moods[.elegant] ?? 0) + 0.4
            moods[.sophisticated] = (moods[.sophisticated] ?? 0) + 0.3
        }

        // Color-specific mood boosts
        for color in colors {
            let influence = color.weight
            switch color.hue {
            case 0..<30, 345..<360: // Red/warm red
                moods[.bold] = (moods[.bold] ?? 0) + 0.4 * influence
                moods[.sensual] = (moods[.sensual] ?? 0) + 0.3 * influence
                moods[.confident] = (moods[.confident] ?? 0) + 0.3 * influence
            case 30..<60: // Orange/gold
                moods[.warm] = (moods[.warm] ?? 0) + 0.4 * influence
                moods[.energetic] = (moods[.energetic] ?? 0) + 0.3 * influence
                moods[.opulent] = (moods[.opulent] ?? 0) + 0.2 * influence
            case 60..<90: // Yellow
                moods[.playful] = (moods[.playful] ?? 0) + 0.4 * influence
                moods[.energetic] = (moods[.energetic] ?? 0) + 0.3 * influence
                moods[.fresh] = (moods[.fresh] ?? 0) + 0.2 * influence
            case 90..<170: // Green
                moods[.natural] = (moods[.natural] ?? 0) + 0.5 * influence
                moods[.serene] = (moods[.serene] ?? 0) + 0.3 * influence
                moods[.fresh] = (moods[.fresh] ?? 0) + 0.3 * influence
            case 170..<230: // Blue/Cyan
                moods[.serene] = (moods[.serene] ?? 0) + 0.4 * influence
                moods[.cool] = (moods[.cool] ?? 0) + 0.4 * influence
                moods[.fresh] = (moods[.fresh] ?? 0) + 0.2 * influence
            case 230..<290: // Purple
                moods[.mysterious] = (moods[.mysterious] ?? 0) + 0.4 * influence
                moods[.opulent] = (moods[.opulent] ?? 0) + 0.3 * influence
                moods[.romantic] = (moods[.romantic] ?? 0) + 0.2 * influence
            case 290..<345: // Pink/Magenta
                moods[.romantic] = (moods[.romantic] ?? 0) + 0.4 * influence
                moods[.playful] = (moods[.playful] ?? 0) + 0.3 * influence
                moods[.elegant] = (moods[.elegant] ?? 0) + 0.2 * influence
            default:
                break
            }

            // Neutral/achromatic colors
            if color.saturation < 0.1 {
                if color.brightness > 0.85 {
                    moods[.minimal] = (moods[.minimal] ?? 0) + 0.3 * influence
                    moods[.elegant] = (moods[.elegant] ?? 0) + 0.3 * influence
                } else if color.brightness < 0.2 {
                    moods[.mysterious] = (moods[.mysterious] ?? 0) + 0.4 * influence
                    moods[.bold] = (moods[.bold] ?? 0) + 0.3 * influence
                    moods[.sophisticated] = (moods[.sophisticated] ?? 0) + 0.2 * influence
                }
            }
        }

        // Scene-based mood hints
        let labelString = sceneLabels.joined(separator: " ").lowercased()
        if labelString.contains("outdoor") || labelString.contains("nature") || labelString.contains("garden") {
            moods[.natural] = (moods[.natural] ?? 0) + 0.4
            moods[.fresh] = (moods[.fresh] ?? 0) + 0.3
        }
        if labelString.contains("night") || labelString.contains("dark") || labelString.contains("evening") {
            moods[.mysterious] = (moods[.mysterious] ?? 0) + 0.4
            moods[.sensual] = (moods[.sensual] ?? 0) + 0.3
        }
        if labelString.contains("luxury") || labelString.contains("elegant") || labelString.contains("formal") {
            moods[.elegant] = (moods[.elegant] ?? 0) + 0.4
            moods[.sophisticated] = (moods[.sophisticated] ?? 0) + 0.3
        }
        if labelString.contains("sport") || labelString.contains("active") {
            moods[.energetic] = (moods[.energetic] ?? 0) + 0.5
            moods[.fresh] = (moods[.fresh] ?? 0) + 0.3
        }
        if labelString.contains("tropical") || labelString.contains("beach") || labelString.contains("palm") {
            moods[.tropical] = (moods[.tropical] ?? 0) + 0.5
            moods[.playful] = (moods[.playful] ?? 0) + 0.3
        }

        // Normalize to 0-1
        let maxVal = moods.values.max() ?? 1.0
        if maxVal > 0 {
            for (key, val) in moods {
                moods[key] = val / maxVal
            }
        }

        return moods
    }

    // MARK: - Errors

    enum AnalysisError: Error, LocalizedError {
        case invalidImage
        case processingFailed

        var errorDescription: String? {
            switch self {
            case .invalidImage: return "Could not process the image"
            case .processingFailed: return "Image analysis failed"
            }
        }
    }
}
