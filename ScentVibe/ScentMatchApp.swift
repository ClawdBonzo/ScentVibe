import SwiftUI
import SwiftData

@main
struct ScentMatchApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [ScentMatchResult.self, UserProfile.self, AnalyticsEvent.self])
    }
}
