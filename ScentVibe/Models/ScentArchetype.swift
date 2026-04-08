import SwiftUI

// MARK: - Scent Archetype

struct ScentArchetype {
    let id: String
    let title: String          // "The Timeless Romantic"
    let emoji: String
    let tagline: String        // "Warm, sensual, unforgettable"
    let accords: [String]      // ["Rose", "Vanilla", "Amber"]
    let accentColor: Color
    let badgeId: String        // First badge to unlock
}

// MARK: - Archetype Library

enum Archetypes {

    static let all: [ScentArchetype] = [
        ScentArchetype(
            id: "elegant",
            title: "The Refined One",
            emoji: "🕊️",
            tagline: "Sophisticated, polished, timeless",
            accords: ["Musks", "Woods", "White Florals"],
            accentColor: Color(red: 0.83, green: 0.69, blue: 0.47),   // gold
            badgeId: "collector_10"
        ),
        ScentArchetype(
            id: "bold",
            title: "The Statement Maker",
            emoji: "⚡️",
            tagline: "Unapologetic, magnetic, fierce",
            accords: ["Oud", "Leather", "Spices"],
            accentColor: Color(red: 0.90, green: 0.30, blue: 0.20),   // red-orange
            badgeId: "streak_3"
        ),
        ScentArchetype(
            id: "fresh",
            title: "The Energetic Soul",
            emoji: "🌿",
            tagline: "Vibrant, airy, alive",
            accords: ["Citrus", "Aquatic", "Greens"],
            accentColor: Color(red: 0.20, green: 0.75, blue: 0.45),   // emerald
            badgeId: "collector_10"
        ),
        ScentArchetype(
            id: "romantic",
            title: "The Timeless Romantic",
            emoji: "🌹",
            tagline: "Warm, sensual, unforgettable",
            accords: ["Rose", "Vanilla", "Amber"],
            accentColor: Color(red: 0.85, green: 0.35, blue: 0.55),   // rose
            badgeId: "streak_3"
        ),
        ScentArchetype(
            id: "mysterious",
            title: "The Midnight Wanderer",
            emoji: "🌑",
            tagline: "Dark, complex, intoxicating",
            accords: ["Incense", "Dark Woods", "Resins"],
            accentColor: Color(red: 0.45, green: 0.25, blue: 0.75),   // violet
            badgeId: "collector_10"
        ),
        ScentArchetype(
            id: "adventurous",
            title: "The Bold Explorer",
            emoji: "🌊",
            tagline: "Daring, exotic, free-spirited",
            accords: ["Spicy", "Tropical", "Exotic Woods"],
            accentColor: Color(red: 0.15, green: 0.55, blue: 0.90),   // ocean blue
            badgeId: "streak_3"
        ),
    ]

    static func forVibe(_ vibe: String) -> ScentArchetype {
        all.first { $0.id == vibe } ?? all[0]
    }
}
