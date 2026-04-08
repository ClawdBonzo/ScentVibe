import Foundation

enum GamificationEngine {
    // MARK: - XP Rewards

    static func xpForMatch(vibeScore: Double) -> Int {
        // Base XP: 25-100 based on vibe score
        let baseXP = Int(25 + (vibeScore / 100) * 75)
        return baseXP
    }

    static func xpForQuest(_ quest: QuestData) -> Int {
        return quest.xpReward
    }

    static func xpForBadge(_ badge: Badge) -> Int {
        switch badge.category {
        case .streak: return 50
        case .collection: return 75
        case .mastery: return 100
        case .social: return 60
        case .milestone: return 120
        }
    }

    // MARK: - Quest Progress Tracking

    static func updateQuestProgress(
        gamification: GamificationProfile,
        matchResult: ScentMatchResult,
        matchCount: Int
    ) {
        // Update quests based on match activity
        var allQuests = gamification.allQuests

        for (index, quest) in allQuests.enumerated() {
            if quest.isCompleted {
                continue
            }

            var updated = false

            switch quest.title {
            case "Scan 3 Outfits":
                allQuests[index].progress = min(allQuests[index].progress + 1, 3)
                updated = true

            case "Discover Accords":
                // Assumes at least 2 accords in recommendations
                let accords = matchResult.recommendations.flatMap { $0.matchedMoods }.count
                allQuests[index].progress = min(allQuests[index].progress + accords, 2)
                updated = true

            case "Perfect Match":
                if matchResult.vibeScore >= 90 {
                    allQuests[index].progress = min(allQuests[index].progress + 1, 1)
                    updated = true
                }

            case "Weekly Explorer":
                allQuests[index].progress = min(allQuests[index].progress + 1, 15)
                updated = true

            case "Collection Master":
                // Track unique fragrances discovered
                let uniqueCount = matchResult.recommendations.count
                allQuests[index].progress = min(allQuests[index].progress + uniqueCount, 10)
                updated = true

            case "Mood Maestro":
                let moodCount = matchResult.detectedMoodTags.count
                allQuests[index].progress = min(allQuests[index].progress + moodCount, 5)
                updated = true

            default:
                break
            }

            if updated && allQuests[index].progress >= allQuests[index].target {
                allQuests[index].isCompleted = true
            }
        }

        // Save back
        let daily = allQuests.filter { $0.questType == .daily }
        let weekly = allQuests.filter { $0.questType == .weekly }

        if let encoded = try? JSONEncoder().encode(daily),
           let jsonString = String(data: encoded, encoding: .utf8) {
            gamification.dailyQuestData = jsonString
        }
        if let encoded = try? JSONEncoder().encode(weekly),
           let jsonString = String(data: encoded, encoding: .utf8) {
            gamification.weeklyQuestData = jsonString
        }
    }

    // MARK: - Badge Unlock Detection

    static func checkForBadgeUnlocks(
        gamification: GamificationProfile,
        userProfile: UserProfile,
        matchCount: Int,
        uniqueFragrancesCount: Int,
        perfectMatchStreak: Int,
        shareCount: Int,
        savedFragranceCount: Int
    ) -> [String] {
        return BadgeManager.checkBadgeUnlocks(
            gamification: gamification,
            userProfile: userProfile,
            matchCount: matchCount,
            uniqueFragrancesCount: uniqueFragrancesCount,
            perfectMatchStreak: perfectMatchStreak,
            shareCount: shareCount,
            savedFragranceCount: savedFragranceCount
        )
    }

    // MARK: - Streak Management

    static func recordDailyActivity(gamification: GamificationProfile) {
        gamification.recordActivity()
    }

    // MARK: - Collection Tracking

    static func recordFragranceDiscovered(gamification: GamificationProfile) {
        gamification.uniqueFragrancesDiscovered += 1
    }

    static func resetPerfectMatchStreak(gamification: GamificationProfile) {
        gamification.matchesSinceLastPerfectMatch = 0
    }

    static func incrementPerfectMatchStreak(gamification: GamificationProfile) {
        gamification.matchesSinceLastPerfectMatch += 1
    }
}
