import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @State private var selectedTab = 0
    @State private var showOnboarding = false

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    private var profile: UserProfile {
        if let existing = profiles.first { return existing }
        let new = UserProfile()
        modelContext.insert(new)
        return new
    }

    var body: some View {
        ZStack {
            Color.smBackground.ignoresSafeArea()

            TabView(selection: $selectedTab) {
                DashboardView()
                    .tabItem {
                        Image(systemName: "square.grid.2x2.fill")
                        Text("Matches")
                    }
                    .tag(0)

                ScanView()
                    .tabItem {
                        Image(systemName: "camera.fill")
                        Text("Scan")
                    }
                    .tag(1)

                VibeWardrobeView()
                    .tabItem {
                        Image(systemName: "hanger")
                        Text("Wardrobe")
                    }
                    .tag(2)

                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
                    .tag(3)
            }
            .tint(Color.smEmerald)
        }
        .preferredColorScheme(.dark)
        .onAppear {
            setupTabBarAppearance()
            if !hasCompletedOnboarding {
                showOnboarding = true
            }
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView {
                hasCompletedOnboarding = true
                profile.hasCompletedOnboarding = true
                showOnboarding = false
                selectedTab = 1  // Go to scan after onboarding
            }
        }
    }

    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.smSurface)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
