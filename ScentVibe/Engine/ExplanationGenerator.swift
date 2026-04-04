import Foundation

final class ExplanationGenerator {

    static let shared = ExplanationGenerator()

    private init() {}

    func generate(fragrance: Fragrance, analysis: ImageAnalysisResult, matchedMoods: [String], score: Double) -> String {
        let scanType = analysis.isOutfit ? "outfit" : (analysis.isRoom ? "space" : "look")
        let topColors = analysis.dominantColors.prefix(2).map { $0.colorName.lowercased() }
        let colorPhrase = formatColorPhrase(topColors)
        let keyNotes = fragrance.heartNotes.prefix(2).joined(separator: " and ")
        let topMood = matchedMoods.first ?? analysis.detectedMoods.max(by: { $0.value < $1.value })?.key.rawValue ?? "stylish"

        // Select template based on primary match factors
        let template = selectTemplate(
            fragrance: fragrance,
            scanType: scanType,
            warmth: analysis.warmth,
            brightness: analysis.brightness,
            score: score
        )

        return template
            .replacingOccurrences(of: "{scanType}", with: scanType)
            .replacingOccurrences(of: "{colors}", with: colorPhrase)
            .replacingOccurrences(of: "{fragrance}", with: fragrance.name)
            .replacingOccurrences(of: "{house}", with: fragrance.house)
            .replacingOccurrences(of: "{notes}", with: keyNotes)
            .replacingOccurrences(of: "{mood}", with: topMood.lowercased())
            .replacingOccurrences(of: "{accord}", with: fragrance.primaryAccord.rawValue.lowercased())
            .replacingOccurrences(of: "{tier}", with: fragrance.priceTier.rawValue.lowercased())
            .replacingOccurrences(of: "{region}", with: fragrance.region.displayName)
    }

    // MARK: - Template Selection

    private func selectTemplate(fragrance: Fragrance, scanType: String, warmth: Double, brightness: Double, score: Double) -> String {

        // High confidence match (score > 0.7)
        if score > 0.7, let t = highConfidenceTemplates.randomElement() {
            return t
        }

        // Warm palette matches
        if warmth > 0.6 && fragrance.moodTags.contains(where: { [.warm, .cozy, .sensual, .bold].contains($0) }),
           let t = warmTemplates.randomElement() {
            return t
        }

        // Cool palette matches
        if warmth < 0.4 && fragrance.moodTags.contains(where: { [.fresh, .cool, .serene, .minimal].contains($0) }),
           let t = coolTemplates.randomElement() {
            return t
        }

        // Dark/moody matches
        if brightness < 0.35, let t = darkTemplates.randomElement() {
            return t
        }

        // Bright/energetic matches
        if brightness > 0.65, let t = brightTemplates.randomElement() {
            return t
        }

        // Default templates
        return defaultTemplates.randomElement() ?? "Your {scanType} pairs beautifully with {fragrance}'s {notes}."
    }

    // MARK: - Template Collections

    private let highConfidenceTemplates = [
        "The {mood} energy of your {scanType} creates a perfect harmony with {fragrance}'s {notes}, amplifying the {accord} character beautifully.",
        "Your {colors} palette is a natural match for {fragrance} by {house} — the {notes} echo the {mood} vibe with remarkable precision.",
        "This is a standout pairing: the {mood} tones in your {scanType} align perfectly with {fragrance}'s {notes}, creating an unforgettable signature.",
        "{fragrance} was made for this {mood} moment — its {notes} complement your {colors} {scanType} with effortless sophistication.",
        "A striking match: {fragrance}'s {accord} profile mirrors the {mood} energy radiating from your {scanType}."
    ]

    private let warmTemplates = [
        "The warm {colors} tones in your {scanType} call for something rich — {fragrance}'s {notes} deliver that {mood} depth perfectly.",
        "Your {scanType}'s inviting warmth pairs beautifully with {fragrance}'s {notes}, creating a {mood} atmosphere that feels like a warm embrace.",
        "The golden undertones in your {scanType} find their olfactory match in {fragrance} — {notes} that wrap you in {mood} comfort.",
        "{fragrance}'s {notes} complement the cozy warmth of your {colors} {scanType}, adding a layer of {mood} richness."
    ]

    private let coolTemplates = [
        "The crisp {colors} palette of your {scanType} mirrors the {accord} freshness of {fragrance}, with {notes} adding a {mood} edge.",
        "Your {scanType}'s cool elegance calls for {fragrance}'s clean {notes} — a {mood} pairing that feels effortlessly refined.",
        "{fragrance} brings a breath of {accord} air to your {colors} {scanType}, its {notes} creating a {mood} counterpoint.",
        "The sleek {colors} tones of your {scanType} harmonize with {fragrance}'s {notes}, capturing that {mood} cool confidence."
    ]

    private let darkTemplates = [
        "The dramatic depth of your {scanType} demands something bold — {fragrance}'s {notes} rise to the occasion with {mood} intensity.",
        "Shadows and sophistication: your dark {scanType} pairs with {fragrance}'s deep {notes}, creating an alluring {mood} atmosphere.",
        "{fragrance}'s {accord} complexity matches the mysterious depth of your {scanType} — {notes} that echo the darkness beautifully.",
        "Your noir {scanType} finds its scent twin in {fragrance} — rich {notes} that amplify the {mood} drama."
    ]

    private let brightTemplates = [
        "The luminous energy of your {scanType} shines alongside {fragrance}'s {notes}, creating an uplifting {mood} synergy.",
        "Your bright {colors} {scanType} deserves a fragrance that sparkles — {fragrance}'s {notes} deliver that {mood} radiance.",
        "{fragrance} captures the light, airy spirit of your {scanType} — {notes} that feel as {mood} as your {colors} palette.",
        "Sun-kissed vibes: your bright {scanType} pairs with {fragrance}'s {notes} for a {mood} burst of joy."
    ]

    private let defaultTemplates = [
        "Your {colors} {scanType} has a {mood} quality that pairs well with {fragrance}'s {notes} — a {accord} blend that feels intentional.",
        "{fragrance} brings out the {mood} essence of your {scanType}, with {notes} adding depth to your {colors} palette.",
        "The {mood} character of your {scanType} finds a natural companion in {fragrance}'s {notes} — a thoughtful {accord} pairing.",
        "Your {scanType}'s {colors} tones suggest {fragrance} — its {notes} create a {mood} harmony that feels just right.",
        "{fragrance} by {house} complements your {scanType}'s {mood} energy — the {accord} notes of {notes} tie everything together."
    ]

    // MARK: - Helpers

    private func formatColorPhrase(_ colors: [String]) -> String {
        switch colors.count {
        case 0: return "neutral"
        case 1: return colors[0]
        case 2: return "\(colors[0]) and \(colors[1])"
        default: return colors.dropLast().joined(separator: ", ") + ", and " + (colors.last ?? "")
        }
    }
}
