import Foundation
import UserNotifications

/// Manages daily "Outfit of the Day" notifications that open the camera.
final class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                self.scheduleDailyNotification()
            }
        }
    }

    func scheduleDailyNotification() {
        let center = UNUserNotificationCenter.current()

        // Remove existing daily notifications
        center.removePendingNotificationRequests(withIdentifiers: ["daily_outfit_reminder"])

        let content = UNMutableNotificationContent()
        content.title = "What's Your Vibe Today?"
        content.body = "Snap your outfit and discover your perfect scent match for the day."
        content.sound = .default
        content.categoryIdentifier = "DAILY_SCAN"

        // Schedule for 8:30 AM daily
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 30

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_outfit_reminder", content: content, trigger: trigger)

        center.add(request)
    }

    func cancelDailyNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily_outfit_reminder"])
    }
}
