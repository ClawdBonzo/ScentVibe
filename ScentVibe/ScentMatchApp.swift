import SwiftUI
import SwiftData

@main
struct ScentMatchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Request notification permission on first launch
                    NotificationManager.shared.requestPermission()
                }
        }
        .modelContainer(for: [ScentMatchResult.self, UserProfile.self, AnalyticsEvent.self])
    }
}
