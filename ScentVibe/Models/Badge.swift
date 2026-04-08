import Foundation

struct Badge: Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let category: BadgeCategory
    let unlockCondition: String

    enum BadgeCategory: String {
        case streak = "🔥 Streaks"
        case collection = "🧪 Collections"
        case mastery = "👑 Mastery"
        case social = "❤️ Social"
        case milestone = "🏆 Milestones"
    }
}

enum BadgeManager {
    // MARK: - Badge Definitions

    static let allBadges: [Badge] = [
        // Streak badges
        Badge(
            id: "streak_3",
            name: "On Fire 🔥",
            description: "Maintain a 3-day activity streak",
            icon: "🔥",
            category: .streak,
            unlockCondition: "3-day streak"
        ),
        Badge(
            id: "streak_7",
            name: "Week Warrior",
            description: "Maintain a 7-day activity streak",
            icon: "⚔️",
            category: .streak,
            unlockCondition: "7-day streak"
        ),
        Badge(
            id: "streak_30",
            name: "Monthly Master",
            description: "Maintain a 30-day activity streak",
            icon: "👑",
            category: .streak,
            unlockCondition: "30-day streak"
        ),

        // Collection badges
        Badge(
            id: "collector_10",
            name: "Scent Collector",
            description: "Discover 10 unique fragrances",
            icon: "🧪",
            category: .collection,
            unlockCondition: "10 fragrances discovered"
        ),
        Badge(
            id: "collector_25",
            name: "Fragrance Curator",
            description: "Discover 25 unique fragrances",
            icon: "🎨",
            category: .collection,
            unlockCondition: "25 fragrances discovered"
        ),
        Badge(
            id: "collector_50",
            name: "Legendary Collector",
            description: "Discover 50 unique fragrances",
            icon: "💎",
            category: .collection,
            unlockCondition: "50 fragrances discovered"
        ),

        // Mastery badges
        Badge(
            id: "level_10",
            name: "Novice Nose",
            description: "Reach Level 10",
            icon: "👃",
            category: .mastery,
            unlockCondition: "Level 10"
        ),
        Badge(
            id: "level_20",
            name: "Expert Nose",
            description: "Reach Level 20",
            icon: "🧬",
            category: .mastery,
            unlockCondition: "Level 20"
        ),
        Badge(
            id: "level_30",
            name: "Master Perfumer",
            description: "Reach Level 30",
            icon: "🏆",
            category: .mastery,
            unlockCondition: "Level 30"
        ),

        // Milestone badges
        Badge(
            id: "matches_50",
            name: "Fifty First",
            description: "Complete 50 scent matches",
            icon: "50️⃣",
            category: .milestone,
            unlockCondition: "50 matches"
        ),
        Badge(
            id: "matches_100",
            name: "Centennial Scentist",
            description: "Complete 100 scent matches",
            icon: "💯",
            category: .milestone,
            unlockCondition: "100 matches"
        ),
        Badge(
            id: "perfect_match",
            name: "Perfect Match Streak",
            description: "Get 5 consecutive 90+ vibe score matches",
            icon: "🎯",
            category: .milestone,
            unlockCondition: "5 perfect matches in a row"
        ),
        Badge(
            id: "rare_collector",
            name: "Rare Scent Collector",
            description: "Discover 5 niche/rare fragrances",
            icon: "🌟",
            category: .collection,
            unlockCondition: "5 rare fragrances"
        ),

        // Social badges
        Badge(
            id: "shares_5",
            name: "Fragrance Ambassador",
            description: "Share 5 fragrance recommendations",
            icon: "📢",
            category: .social,
            unlockCondition: "5 shares"
        ),
        Badge(
            id: "wardrobe_10",
            name: "Wardrobe Architect",
            description: "Save 10 fragrances to your wardrobe",
            icon: "👗",
            category: .social,
            unlockCondition: "10 saved fragrances"
        ),
    ]

    // MARK: - Badge Unlock Logic

    static func checkBadgeUnlocks(
        gamification: GamificationProfile,
        userProfile: UserProfile,
        matchCount: Int,
        uniqueFragrancesCount: Int,
        perfectMatchStreak: Int,
        shareCount: Int,
        savedFragranceCount: Int
    ) -> [String] {
        var newBadges: [String] = []

        // Streak badges
        if gamification.currentStreak >= 3 && !gamification.unlockedBadgeIds.contains("streak_3") {
            newBadges.append("streak_3")
        }
        if gamification.currentStreak >= 7 && !gamification.unlockedBadgeIds.contains("streak_7") {
            newBadges.append("streak_7")
        }
        if gamification.currentStreak >= 30 && !gamification.unlockedBadgeIds.contains("streak_30") {
            newBadges.append("streak_30")
        }

        // Level badges
        if gamification.level >= 10 && !gamification.unlockedBadgeIds.contains("level_10") {
            newBadges.append("level_10")
        }
        if gamification.level >= 20 && !gamification.unlockedBadgeIds.contains("level_20") {
            newBadges.append("level_20")
        }
        if gamification.level >= 30 && !gamification.unlockedBadgeIds.contains("level_30") {
            newBadges.append("level_30")
        }

        // Collection badges
        if uniqueFragrancesCount >= 10 && !gamification.unlockedBadgeIds.contains("collector_10") {
            newBadges.append("collector_10")
        }
        if uniqueFragrancesCount >= 25 && !gamification.unlockedBadgeIds.contains("collector_25") {
            newBadges.append("collector_25")
        }
        if uniqueFragrancesCount >= 50 && !gamification.unlockedBadgeIds.contains("collector_50") {
            newBadges.append("collector_50")
        }

        // Milestone badges
        if matchCount >= 50 && !gamification.unlockedBadgeIds.contains("matches_50") {
            newBadges.append("matches_50")
        }
        if matchCount >= 100 && !gamification.unlockedBadgeIds.contains("matches_100") {
            newBadges.append("matches_100")
        }

        // Perfect match badge
        if perfectMatchStreak >= 5 && !gamification.unlockedBadgeIds.contains("perfect_match") {
            newBadges.append("perfect_match")
        }

        // Rare collector
        let rareCount = gamification.uniqueFragrancesDiscovered  // Assuming rare are tracked separately
        if rareCount >= 5 && !gamification.unlockedBadgeIds.contains("rare_collector") {
            newBadges.append("rare_collector")
        }

        // Social badges
        if shareCount >= 5 && !gamification.unlockedBadgeIds.contains("shares_5") {
            newBadges.append("shares_5")
        }
        if savedFragranceCount >= 10 && !gamification.unlockedBadgeIds.contains("wardrobe_10") {
            newBadges.append("wardrobe_10")
        }

        return newBadges
    }

    static func badge(forId id: String) -> Badge? {
        allBadges.first { $0.id == id }
    }

    static func badgesByCategory(_ category: Badge.BadgeCategory) -> [Badge] {
        allBadges.filter { $0.category == category }
    }
}
