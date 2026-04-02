import Foundation
import SwiftData
import SwiftUI

@Model
final class ScentMatchResult {
    var id: UUID
    var photoData: Data?
    var scanType: String  // "outfit" or "room"
    var timestamp: Date
    var vibeScore: Double  // 0-100

    // Vision analysis results (stored as JSON)
    var dominantColorsJSON: String  // [[h, s, b, weight], ...]
    var detectedMoodTagsJSON: String  // ["Elegant", "Bold", ...]
    var sceneClassification: String  // e.g., "indoor", "outdoor", "clothing"
    var brightnessLevel: Double  // 0-1
    var warmthLevel: Double  // 0-1 (0=cool, 1=warm)

    // Recommendations (stored as JSON)
    var recommendationsJSON: String  // [{fragranceId, score, explanation}, ...]

    // Engagement tracking
    var affiliateLinksTapped: Int
    var isFavorited: Bool

    init(
        photoData: Data? = nil,
        scanType: String = "outfit",
        vibeScore: Double = 0,
        dominantColors: [[Double]] = [],
        detectedMoodTags: [String] = [],
        sceneClassification: String = "",
        brightnessLevel: Double = 0.5,
        warmthLevel: Double = 0.5,
        recommendations: [RecommendationEntry] = []
    ) {
        self.id = UUID()
        self.photoData = photoData
        self.scanType = scanType
        self.timestamp = Date()
        self.vibeScore = vibeScore
        self.dominantColorsJSON = (try? JSONEncoder().encode(dominantColors)).flatMap { String(data: $0, encoding: .utf8) } ?? "[]"
        self.detectedMoodTagsJSON = (try? JSONEncoder().encode(detectedMoodTags)).flatMap { String(data: $0, encoding: .utf8) } ?? "[]"
        self.sceneClassification = sceneClassification
        self.brightnessLevel = brightnessLevel
        self.warmthLevel = warmthLevel
        self.recommendationsJSON = (try? JSONEncoder().encode(recommendations)).flatMap { String(data: $0, encoding: .utf8) } ?? "[]"
        self.affiliateLinksTapped = 0
        self.isFavorited = false
    }

    // MARK: - Computed Properties

    var dominantColors: [[Double]] {
        guard let data = dominantColorsJSON.data(using: .utf8),
              let colors = try? JSONDecoder().decode([[Double]].self, from: data) else { return [] }
        return colors
    }

    var detectedMoodTags: [String] {
        guard let data = detectedMoodTagsJSON.data(using: .utf8),
              let tags = try? JSONDecoder().decode([String].self, from: data) else { return [] }
        return tags
    }

    var recommendations: [RecommendationEntry] {
        guard let data = recommendationsJSON.data(using: .utf8),
              let recs = try? JSONDecoder().decode([RecommendationEntry].self, from: data) else { return [] }
        return recs
    }

    var topRecommendation: RecommendationEntry? {
        recommendations.first
    }

    var photoImage: Image? {
        guard let data = photoData,
              let uiImage = UIImage(data: data) else { return nil }
        return Image(uiImage: uiImage)
    }
}

// MARK: - Recommendation Entry

struct RecommendationEntry: Codable, Identifiable, Hashable {
    let id: String  // fragrance ID
    let score: Double  // 0-1 match score
    let explanation: String
    let matchedMoods: [String]
    let matchedColors: [String]  // hex strings

    var fragranceId: String { id }

    func fragrance() -> Fragrance? {
        FragranceDatabase.shared.fragrance(byId: id)
    }
}
