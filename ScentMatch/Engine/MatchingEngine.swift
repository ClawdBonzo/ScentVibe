import Foundation

// MARK: - Matching Engine

final class MatchingEngine {

    static let shared = MatchingEngine()

    private let database = FragranceDatabase.shared
    private let explanationGenerator = ExplanationGenerator.shared

    private init() {}

    // MARK: - Weights

    private struct Weights {
        static let moodSimilarity: Double = 0.40
        static let colorMatch: Double = 0.30
        static let seasonalBonus: Double = 0.10
        static let sceneContext: Double = 0.10
        static let brightnessHarmony: Double = 0.05
        static let warmthHarmony: Double = 0.05
    }

    // MARK: - Main Matching

    func findMatches(for analysis: ImageAnalysisResult, count: Int = 5, preferredRegion: FragranceRegion? = nil, preferredGender: Gender? = nil) -> [RecommendationEntry] {

        var scored = database.fragrances.map { fragrance -> (Fragrance, Double) in
            let score = computeScore(fragrance: fragrance, analysis: analysis)
            return (fragrance, score)
        }

        // Apply region preference boost (soft, not a filter)
        if let region = preferredRegion {
            scored = scored.map { (frag, score) in
                let boost = frag.region == region ? 0.08 : 0.0
                return (frag, score + boost)
            }
        }

        // Apply gender preference (soft filter - reduce non-matching scores)
        if let gender = preferredGender, gender != .unisex {
            scored = scored.map { (frag, score) in
                if frag.gender == gender || frag.gender == .unisex {
                    return (frag, score)
                }
                return (frag, score * 0.6)  // Reduce but don't eliminate
            }
        }

        // Sort by score descending
        scored.sort { $0.1 > $1.1 }

        // Apply diversity: ensure variety in results
        let diverse = applyDiversity(candidates: scored, targetCount: count)

        // Generate recommendations with explanations
        return diverse.map { (fragrance, score) in
            let matchedMoods = analysis.detectedMoods
                .sorted { $0.value > $1.value }
                .prefix(3)
                .filter { fragrance.moodTags.contains($0.key) }
                .map { $0.key.rawValue }

            let matchedColors = analysis.dominantColors.prefix(3).map { $0.hexString }

            let explanation = explanationGenerator.generate(
                fragrance: fragrance,
                analysis: analysis,
                matchedMoods: matchedMoods,
                score: score
            )

            return RecommendationEntry(
                id: fragrance.id,
                score: min(score, 1.0),
                explanation: explanation,
                matchedMoods: matchedMoods,
                matchedColors: matchedColors
            )
        }
    }

    // MARK: - Vibe Score

    func computeVibeScore(for analysis: ImageAnalysisResult, topScore: Double) -> Double {
        // Vibe score 0-100, based on how well the best match scores
        // Plus bonuses for strong mood signals and color harmony
        let baseScore = topScore * 70  // Max 70 from match quality

        // Mood clarity bonus (up to 15): stronger mood signals = higher vibe
        let topMoods = analysis.detectedMoods.values.sorted().suffix(3)
        let moodClarity = topMoods.reduce(0.0, +) / 3.0
        let moodBonus = moodClarity * 15

        // Color harmony bonus (up to 15): more saturated/distinctive colors = higher vibe
        let colorDistinctiveness = analysis.saturation * 0.5 + (analysis.dominantColors.count > 2 ? 0.5 : 0.3)
        let colorBonus = colorDistinctiveness * 15

        return min(100, max(20, baseScore + moodBonus + colorBonus))
    }

    // MARK: - Scoring Components

    private func computeScore(fragrance: Fragrance, analysis: ImageAnalysisResult) -> Double {
        var score = 0.0

        // 1. Mood similarity (40%)
        let moodScore = computeMoodSimilarity(
            imageMoods: analysis.detectedMoods,
            fragranceMoods: fragrance.moodVector
        )
        score += moodScore * Weights.moodSimilarity

        // 2. Color match (30%)
        let colorScore = computeColorMatch(
            imageColors: analysis.dominantColors,
            fragranceColors: fragrance.colorAssociations
        )
        score += colorScore * Weights.colorMatch

        // 3. Seasonal relevance (10%)
        let seasonScore = computeSeasonalScore(fragrance: fragrance)
        score += seasonScore * Weights.seasonalBonus

        // 4. Scene context (10%)
        let sceneScore = computeSceneScore(fragrance: fragrance, analysis: analysis)
        score += sceneScore * Weights.sceneContext

        // 5. Brightness harmony (5%)
        let brightnessScore = computeBrightnessHarmony(
            imageBrightness: analysis.brightness,
            fragrance: fragrance
        )
        score += brightnessScore * Weights.brightnessHarmony

        // 6. Warmth harmony (5%)
        let warmthScore = computeWarmthHarmony(
            imageWarmth: analysis.warmth,
            fragrance: fragrance
        )
        score += warmthScore * Weights.warmthHarmony

        return score
    }

    private func computeMoodSimilarity(imageMoods: [MoodTag: Double], fragranceMoods: [MoodTag: Double]) -> Double {
        guard !imageMoods.isEmpty && !fragranceMoods.isEmpty else { return 0.3 }

        var dotProduct = 0.0
        var imageNorm = 0.0
        var fragNorm = 0.0

        let allMoods = Set(imageMoods.keys).union(fragranceMoods.keys)
        for mood in allMoods {
            let iv = imageMoods[mood] ?? 0.0
            let fv = fragranceMoods[mood] ?? 0.0
            dotProduct += iv * fv
            imageNorm += iv * iv
            fragNorm += fv * fv
        }

        guard imageNorm > 0 && fragNorm > 0 else { return 0.3 }
        return dotProduct / (sqrt(imageNorm) * sqrt(fragNorm))
    }

    private func computeColorMatch(imageColors: [ColorInfo], fragranceColors: [ColorAssociation]) -> Double {
        guard !imageColors.isEmpty && !fragranceColors.isEmpty else { return 0.3 }

        var totalScore = 0.0
        var totalWeight = 0.0

        for color in imageColors {
            var bestMatch = 0.0
            for assoc in fragranceColors {
                let hueMatch = assoc.hueRange.contains(color.hue) ? 1.0 :
                    min(abs(color.hue - assoc.hueRange.lowerBound),
                        abs(color.hue - assoc.hueRange.upperBound),
                        abs(color.hue + 360 - assoc.hueRange.upperBound),
                        abs(color.hue - 360 - assoc.hueRange.lowerBound)) < 30 ? 0.5 : 0.0

                let satMatch = assoc.saturationRange.contains(color.saturation) ? 1.0 : 0.3
                let briMatch = assoc.brightnessRange.contains(color.brightness) ? 1.0 : 0.3

                let match = hueMatch * 0.6 + satMatch * 0.2 + briMatch * 0.2
                bestMatch = max(bestMatch, match * assoc.weight)
            }
            totalScore += bestMatch * color.weight
            totalWeight += color.weight
        }

        return totalWeight > 0 ? totalScore / totalWeight : 0.3
    }

    private func computeSeasonalScore(fragrance: Fragrance) -> Double {
        let month = Calendar.current.component(.month, from: Date())
        let currentSeason: Season
        switch month {
        case 3...5: currentSeason = .spring
        case 6...8: currentSeason = .summer
        case 9...11: currentSeason = .fall
        default: currentSeason = .winter
        }
        return fragrance.seasonality.contains(currentSeason) ? 1.0 : 0.4
    }

    private func computeSceneScore(fragrance: Fragrance, analysis: ImageAnalysisResult) -> Double {
        if analysis.isOutfit {
            // For outfits: prefer fragrances with good projection/wearability
            let outfitAccords: Set<AccordFamily> = [.fresh, .aromatic, .citrus, .floral, .woody]
            let matchCount = fragrance.accords.filter { outfitAccords.contains($0) }.count
            return Double(matchCount) / Double(max(1, fragrance.accords.count))
        } else if analysis.isRoom {
            // For rooms: prefer ambient, diffusive fragrances
            let roomAccords: Set<AccordFamily> = [.woody, .oriental, .gourmand, .floral, .aromatic]
            let matchCount = fragrance.accords.filter { roomAccords.contains($0) }.count
            return Double(matchCount) / Double(max(1, fragrance.accords.count))
        }
        return 0.5  // General scene, neutral score
    }

    private func computeBrightnessHarmony(imageBrightness: Double, fragrance: Fragrance) -> Double {
        // Bright images pair with fresh/light scents; dark images with deep/rich scents
        let lightAccords: Set<AccordFamily> = [.citrus, .fresh, .aquatic, .green]
        let darkAccords: Set<AccordFamily> = [.oriental, .leather, .gourmand, .woody]

        let isLight = fragrance.accords.contains { lightAccords.contains($0) }
        let isDark = fragrance.accords.contains { darkAccords.contains($0) }

        if imageBrightness > 0.6 && isLight { return 1.0 }
        if imageBrightness < 0.4 && isDark { return 1.0 }
        if imageBrightness > 0.6 && isDark { return 0.3 }
        if imageBrightness < 0.4 && isLight { return 0.3 }
        return 0.6
    }

    private func computeWarmthHarmony(imageWarmth: Double, fragrance: Fragrance) -> Double {
        let warmAccords: Set<AccordFamily> = [.oriental, .spicy, .woody, .gourmand, .leather]
        let coolAccords: Set<AccordFamily> = [.fresh, .aquatic, .citrus, .green]

        let isWarm = fragrance.accords.contains { warmAccords.contains($0) }
        let isCool = fragrance.accords.contains { coolAccords.contains($0) }

        if imageWarmth > 0.6 && isWarm { return 1.0 }
        if imageWarmth < 0.4 && isCool { return 1.0 }
        if imageWarmth > 0.6 && isCool { return 0.3 }
        if imageWarmth < 0.4 && isWarm { return 0.3 }
        return 0.6
    }

    // MARK: - Diversity

    private func applyDiversity(candidates: [(Fragrance, Double)], targetCount: Int) -> [(Fragrance, Double)] {
        guard candidates.count > targetCount else { return candidates }

        var result = [(Fragrance, Double)]()
        var usedAccords = Set<AccordFamily>()
        var usedTiers = Set<PriceTier>()
        var usedRegions = Set<FragranceRegion>()

        // Always include #1
        if let first = candidates.first {
            result.append(first)
            first.0.accords.forEach { usedAccords.insert($0) }
            usedTiers.insert(first.0.priceTier)
            usedRegions.insert(first.0.region)
        }

        // Fill remaining with diversity preference
        for candidate in candidates.dropFirst() where result.count < targetCount {
            let hasNewAccord = !candidate.0.accords.allSatisfy { usedAccords.contains($0) }
            let hasNewTier = !usedTiers.contains(candidate.0.priceTier)
            let hasNewRegion = !usedRegions.contains(candidate.0.region)

            let diversityBonus = (hasNewAccord ? 1 : 0) + (hasNewTier ? 1 : 0) + (hasNewRegion ? 1 : 0)

            // Accept if score is within 30% of top or adds diversity
            let scoreThreshold = (result.first?.1 ?? 0) * 0.7
            if candidate.1 >= scoreThreshold || diversityBonus >= 2 {
                result.append(candidate)
                candidate.0.accords.forEach { usedAccords.insert($0) }
                usedTiers.insert(candidate.0.priceTier)
                usedRegions.insert(candidate.0.region)
            }
        }

        // Fill any remaining slots from top candidates
        for candidate in candidates where result.count < targetCount {
            if !result.contains(where: { $0.0.id == candidate.0.id }) {
                result.append(candidate)
            }
        }

        return Array(result.prefix(targetCount))
    }
}
