import Foundation

// MARK: - Enums

enum FragranceRegion: String, Codable, CaseIterable, Identifiable {
    case western = "Western"
    case german = "German"
    case mexican = "Mexican"
    case brazilian = "Brazilian"
    case french = "French"

    var id: String { rawValue }

    var displayName: String { rawValue }

    var flag: String {
        switch self {
        case .western: return "🌍"
        case .german: return "🇩🇪"
        case .mexican: return "🇲🇽"
        case .brazilian: return "🇧🇷"
        case .french: return "🇫🇷"
        }
    }
}

enum PriceTier: String, Codable, CaseIterable, Identifiable {
    case budget = "Budget"
    case mid = "Mid-Range"
    case luxury = "Luxury"

    var id: String { rawValue }

    var priceRange: String {
        switch self {
        case .budget: return "Under $50"
        case .mid: return "$50–$150"
        case .luxury: return "$150+"
        }
    }

    var sortOrder: Int {
        switch self {
        case .budget: return 0
        case .mid: return 1
        case .luxury: return 2
        }
    }
}

enum AccordFamily: String, Codable, CaseIterable, Identifiable {
    case woody = "Woody"
    case fresh = "Fresh"
    case floral = "Floral"
    case oriental = "Oriental"
    case aromatic = "Aromatic"
    case gourmand = "Gourmand"
    case citrus = "Citrus"
    case aquatic = "Aquatic"
    case powdery = "Powdery"
    case leather = "Leather"
    case green = "Green"
    case fruity = "Fruity"
    case musky = "Musky"
    case spicy = "Spicy"

    var id: String { rawValue }
}

enum MoodTag: String, Codable, CaseIterable, Identifiable {
    case elegant = "Elegant"
    case bold = "Bold"
    case romantic = "Romantic"
    case fresh = "Fresh"
    case cozy = "Cozy"
    case mysterious = "Mysterious"
    case playful = "Playful"
    case sophisticated = "Sophisticated"
    case energetic = "Energetic"
    case serene = "Serene"
    case sensual = "Sensual"
    case confident = "Confident"
    case warm = "Warm"
    case cool = "Cool"
    case minimal = "Minimal"
    case opulent = "Opulent"
    case rebellious = "Rebellious"
    case natural = "Natural"
    case tropical = "Tropical"
    case vintage = "Vintage"

    var id: String { rawValue }
}

enum Season: String, Codable, CaseIterable, Identifiable {
    case spring = "Spring"
    case summer = "Summer"
    case fall = "Fall"
    case winter = "Winter"

    var id: String { rawValue }
}

enum Gender: String, Codable, CaseIterable {
    case masculine = "Masculine"
    case feminine = "Feminine"
    case unisex = "Unisex"
}

// MARK: - Color Association

struct ColorAssociation: Codable, Hashable {
    let hueRange: ClosedRange<Double>  // 0-360 hue
    let saturationRange: ClosedRange<Double>  // 0-1
    let brightnessRange: ClosedRange<Double>  // 0-1
    let weight: Double  // How strongly this color maps to the fragrance

    init(hueMin: Double, hueMax: Double, satMin: Double = 0.2, satMax: Double = 1.0, briMin: Double = 0.2, briMax: Double = 1.0, weight: Double = 1.0) {
        self.hueRange = hueMin...hueMax
        self.saturationRange = satMin...satMax
        self.brightnessRange = briMin...briMax
        self.weight = weight
    }
}

// MARK: - Fragrance

struct Fragrance: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let house: String
    let accords: [AccordFamily]
    let topNotes: [String]
    let heartNotes: [String]
    let baseNotes: [String]
    let moodTags: [MoodTag]
    let colorAssociations: [ColorAssociation]
    let seasonality: [Season]
    let region: FragranceRegion
    let priceTier: PriceTier
    let gender: Gender
    let amazonASIN: String?
    let iconName: String
    let shortDescription: String

    var allNotes: [String] {
        topNotes + heartNotes + baseNotes
    }

    var primaryAccord: AccordFamily {
        accords.first ?? .fresh
    }

    var affiliateURL: URL? {
        guard let asin = amazonASIN else { return nil }
        return URL(string: "https://www.amazon.com/dp/\(asin)?tag=scentmatch-20")
    }

    // Mood vector for matching (normalized 0-1 values for each mood dimension)
    var moodVector: [MoodTag: Double] {
        var vec = [MoodTag: Double]()
        for (index, tag) in moodTags.enumerated() {
            // Primary mood gets higher weight, secondary moods get decreasing weights
            let weight = 1.0 - (Double(index) * 0.15)
            vec[tag] = max(weight, 0.3)
        }
        return vec
    }
}
