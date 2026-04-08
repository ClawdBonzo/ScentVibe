import Foundation
import SwiftData

@Model
final class GamificationProfile {
    // XP & Levels
    var totalXP: Int
    var level: Int
    var currentLevelXP: Int  // XP towards current level

    // Streaks
    var currentStreak: Int  // Consecutive days
    var bestStreak: Int
    var lastActivityDate: Date?
    var streakMultiplier: Double  // 1.0 + (0.1 * streakLevel)

    // Quests
    var dailyQuestData: String  // JSON: [QuestData]
    var weeklyQuestData: String  // JSON: [QuestData]

    // Badges
    var unlockedBadgeIds: [String]

    // Scent Collection Progress
    var uniqueFragrancesDiscovered: Int
    var matchesSinceLastPerfectMatch: Int

    // Timestamps
    var createdAt: Date
    var lastQuestResetDate: Date?

    init() {
        self.totalXP = 0
        self.level = 1
        self.currentLevelXP = 0
        self.currentStreak = 0
        self.bestStreak = 0
        self.lastActivityDate = nil
        self.streakMultiplier = 1.0
        self.dailyQuestData = "[]"
        self.weeklyQuestData = "[]"
        self.unlockedBadgeIds = []
        self.uniqueFragrancesDiscovered = 0
        self.matchesSinceLastPerfectMatch = 0
        self.createdAt = Date()
        self.lastQuestResetDate = nil
    }

    // MARK: - Computed Properties

    var xpForNextLevel: Int {
        baseXPForLevel(level + 1)
    }

    var xpProgressToNextLevel: Double {
        let totalXpNeeded = xpForNextLevel
        guard totalXpNeeded > 0 else { return 0 }
        return Double(currentLevelXP) / Double(totalXpNeeded)
    }

    var levelTitle: String {
        switch level {
        case 1...3: return "Scent Novice"
        case 4...7: return "Fragrance Enthusiast"
        case 8...12: return "Aroma Explorer"
        case 13...18: return "Scent Curator"
        case 19...24: return "Fragrance Connoisseur"
        case 25...29: return "Master Perfumer"
        default: return "Legendary Nose"
        }
    }

    var dailyQuests: [QuestData] {
        guard let data = dailyQuestData.data(using: .utf8),
              let quests = try? JSONDecoder().decode([QuestData].self, from: data) else { return [] }
        return quests
    }

    var weeklyQuests: [QuestData] {
        guard let data = weeklyQuestData.data(using: .utf8),
              let quests = try? JSONDecoder().decode([QuestData].self, from: data) else { return [] }
        return quests
    }

    var allQuests: [QuestData] {
        dailyQuests + weeklyQuests
    }

    var completedQuestCount: Int {
        allQuests.filter { $0.isCompleted }.count
    }

    var totalQuestRewards: Int {
        allQuests.filter { $0.isCompleted }.reduce(0) { $0 + $1.xpReward }
    }

    // MARK: - XP & Leveling

    private func baseXPForLevel(_ level: Int) -> Int {
        // Exponential growth: ~300 * 1.15^(level-1)
        let base = 300
        let growth = 1.15
        return Int(Double(base) * pow(growth, Double(level - 2)))
    }

    func addXP(_ amount: Int, reason: String = "") {
        let adjustedAmount = Int(Double(amount) * streakMultiplier)
        totalXP += adjustedAmount
        currentLevelXP += adjustedAmount

        // Check level up
        while currentLevelXP >= xpForNextLevel {
            levelUp()
        }
    }

    private func levelUp() {
        level += 1
        currentLevelXP -= xpForNextLevel
        // Level up haptics handled in view
    }

    // MARK: - Streak Management

    func recordActivity() {
        let now = Date()
        let calendar = Calendar.current

        if let lastDate = lastActivityDate {
            let daysBetween = calendar.dateComponents([.day], from: calendar.startOfDay(for: lastDate), to: calendar.startOfDay(for: now)).day ?? 0

            if daysBetween == 1 {
                // Consecutive day
                currentStreak += 1
                bestStreak = max(bestStreak, currentStreak)
                streakMultiplier = 1.0 + (0.1 * Double(currentStreak / 3))
            } else if daysBetween > 1 {
                // Streak broken
                currentStreak = 1
                streakMultiplier = 1.0
            }
            // else: daysBetween == 0 (same day, don't increment)
        } else {
            // First activity
            currentStreak = 1
            streakMultiplier = 1.0
        }

        lastActivityDate = now
    }

    // MARK: - Quest Management

    func generateDailyQuests() {
        let quests = QuestGenerator.generateDailyQuests()
        if let encoded = try? JSONEncoder().encode(quests),
           let jsonString = String(data: encoded, encoding: .utf8) {
            dailyQuestData = jsonString
        }
        lastQuestResetDate = Date()
    }

    func generateWeeklyQuests() {
        let quests = QuestGenerator.generateWeeklyQuests()
        if let encoded = try? JSONEncoder().encode(quests),
           let jsonString = String(data: encoded, encoding: .utf8) {
            weeklyQuestData = jsonString
        }
    }

    func completeQuest(id: String) {
        var quests = allQuests
        if let index = quests.firstIndex(where: { $0.id == id }) {
            quests[index].isCompleted = true
            quests[index].completedDate = Date()

            // Update XP
            let xpReward = quests[index].xpReward
            addXP(xpReward, reason: "quest_completion")

            // Save back
            let daily = quests.filter { $0.questType == .daily }
            let weekly = quests.filter { $0.questType == .weekly }

            if let encoded = try? JSONEncoder().encode(daily),
               let jsonString = String(data: encoded, encoding: .utf8) {
                dailyQuestData = jsonString
            }
            if let encoded = try? JSONEncoder().encode(weekly),
               let jsonString = String(data: encoded, encoding: .utf8) {
                weeklyQuestData = jsonString
            }
        }
    }

    // MARK: - Badge Management

    func unlockBadge(_ badgeId: String) {
        if !unlockedBadgeIds.contains(badgeId) {
            unlockedBadgeIds.append(badgeId)
            // Badge unlock haptics handled in view
        }
    }
}

// MARK: - Quest Data

struct QuestData: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let questType: QuestType
    var progress: Int
    let target: Int
    let xpReward: Int
    let icon: String
    var isCompleted: Bool
    var completedDate: Date?

    enum QuestType: String, Codable {
        case daily, weekly
    }

    var progressRatio: Double {
        guard target > 0 else { return 0 }
        return Double(min(progress, target)) / Double(target)
    }
}

// MARK: - Quest Generator

enum QuestGenerator {
    static let dailyQuestPool = [
        ("Scan 3 Outfits", "Complete 3 scent matches", "📸", 3, 50),
        ("Discover Accords", "Find 2 new fragrance accords", "✨", 2, 40),
        ("Wardrobe Builder", "Save 2 fragrances to your wardrobe", "👜", 2, 45),
        ("Morning Ritual", "Start a morning match", "☀️", 1, 30),
        ("Evening Vibes", "Complete an evening match", "🌙", 1, 30),
        ("Diversity Quest", "Match different room types", "🏠", 3, 50),
        ("Share the Love", "Share a fragrance recommendation", "❤️", 1, 35),
        ("Perfect Match", "Achieve a 90+ vibe score", "💎", 1, 60),
    ]

    static let weeklyQuestPool = [
        ("Weekly Explorer", "Complete 15 scent matches", "🗺️", 15, 200),
        ("Collection Master", "Discover 10 unique fragrances", "🧪", 10, 180),
        ("Streak Champion", "Maintain a 5-day activity streak", "🔥", 5, 250),
        ("Mood Maestro", "Match 5 different mood categories", "🎭", 5, 150),
        ("Rare Collector", "Find 3 rare/niche fragrances", "💰", 3, 220),
        ("Social Butterfly", "Share 3 recommendations", "🦋", 3, 140),
    ]

    static func generateDailyQuests() -> [QuestData] {
        dailyQuestPool.shuffled().prefix(3).map { title, desc, icon, target, xp in
            QuestData(
                id: UUID().uuidString,
                title: title,
                description: desc,
                questType: .daily,
                progress: 0,
                target: target,
                xpReward: xp,
                icon: icon,
                isCompleted: false,
                completedDate: nil
            )
        }.sorted { $0.title < $1.title }
    }

    static func generateWeeklyQuests() -> [QuestData] {
        weeklyQuestPool.shuffled().prefix(2).map { title, desc, icon, target, xp in
            QuestData(
                id: UUID().uuidString,
                title: title,
                description: desc,
                questType: .weekly,
                progress: 0,
                target: target,
                xpReward: xp,
                icon: icon,
                isCompleted: false,
                completedDate: nil
            )
        }.sorted { $0.title < $1.title }
    }
}
