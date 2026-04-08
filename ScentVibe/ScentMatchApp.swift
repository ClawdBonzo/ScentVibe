import SwiftUI
import SwiftData

@main
struct ScentMatchApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(
            for: [
                ScentMatchResult.self,
                UserProfile.self,
                AnalyticsEvent.self,
                GamificationProfile.self,   // Added — was missing from container
            ]
        )
    }
}
