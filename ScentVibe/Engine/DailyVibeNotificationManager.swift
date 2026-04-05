import Foundation
import UserNotifications
import SwiftData

// MARK: - Daily Vibe Notification Manager
// Schedules a single daily local notification at 9 AM with a random
// wardrobe match or motivational fallback. Fully opt-in, respects
// system permission, and stores preference in @AppStorage.

@MainActor
final class DailyVibeNotificationManager: ObservableObject {

    static let shared = DailyVibeNotificationManager()
    private init() {}

    private let center = UNUserNotificationCenter.current()
    private let notificationID = "com.scentvibe.dailyVibe"

    // MARK: - Permission Request

    /// Requests notification authorization. Returns `true` if granted.
    func requestPermission() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            return false
        }
    }

    /// Checks current authorization status without prompting.
    func checkPermission() async -> UNAuthorizationStatus {
        let settings = await center.notificationSettings()
        return settings.authorizationStatus
    }

    // MARK: - Scheduling

    /// Schedules (or reschedules) the daily 9 AM notification.
    /// Pass a `ModelContext` so we can pull a random wardrobe match.
    func scheduleDailyNotification(modelContext: ModelContext) {
        // Remove any existing notification first
        center.removePendingNotificationRequests(withIdentifiers: [notificationID])

        // Build content from wardrobe or fallback
        let content = buildContent(modelContext: modelContext)

        // 9:00 AM local time, repeating daily
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)

        center.add(request) { error in
            if let error {
                print("[DailyVibe] Scheduling error: \(error.localizedDescription)")
            }
        }
    }

    /// Cancels the daily notification.
    func cancelDailyNotification() {
        center.removePendingNotificationRequests(withIdentifiers: [notificationID])
    }

    // MARK: - Content Builder

    private func buildContent(modelContext: ModelContext) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.sound = .default

        // Try to fetch a random favorited wardrobe match
        let descriptor = FetchDescriptor<ScentMatchResult>(
            predicate: #Predicate { $0.isFavorited == true }
        )

        let favorites = (try? modelContext.fetch(descriptor)) ?? []

        if let random = favorites.randomElement(),
           let topRec = random.topRecommendation,
           let fragrance = topRec.fragrance() {
            // Personalized notification with a saved match
            let titles = [
                "Your Daily Vibe ✨",
                "Today's Scent Match 🌿",
                "Morning Vibe Check 💫",
                "Fragrance of the Day 🌸"
            ]
            content.title = titles.randomElement()!

            let bodies = [
                "How about \(fragrance.name) by \(fragrance.house) today? It matched your \(random.detectedMoodTags.first ?? "style") vibe.",
                "\(fragrance.name) scored \(Int(topRec.score * 100))% — perfect for today's mood.",
                "Revisit \(fragrance.name) from your wardrobe. Your \(random.detectedMoodTags.first ?? "signature") energy is calling.",
                "Start your day with \(fragrance.name). A \(Int(topRec.score * 100))% vibe match awaits."
            ]
            content.body = bodies.randomElement()!
        } else {
            // Fallback — no wardrobe matches yet
            let fallbacks: [(String, String)] = [
                ("Try a New Mood Today ✨", "Snap your outfit and discover your perfect scent match."),
                ("What's Your Vibe? 🌿", "Open ScentVibe and let AI find your fragrance of the day."),
                ("Scent Discovery Awaits 💫", "Your next signature scent is one scan away."),
                ("Morning Vibe Check 🌸", "Match your look to a fragrance — takes just seconds."),
                ("Find Your Scent 🔮", "Today's outfit deserves a perfect fragrance pairing.")
            ]
            let pick = fallbacks.randomElement()!
            content.title = pick.0
            content.body = pick.1
        }

        return content
    }
}
