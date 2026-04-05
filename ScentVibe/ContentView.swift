import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @State private var selectedTab = 0
    @State private var previousTab = 0
    @State private var showOnboarding = false
    @State private var showNotificationPrompt = false

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("hasAskedNotificationPermission") private var hasAskedNotificationPermission = false
    @AppStorage("dailyVibeEnabled") private var dailyVibeEnabled = false

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

                VibeWardrobeView(selectedTab: $selectedTab)
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
            .onChange(of: selectedTab) { oldValue, newValue in
                previousTab = oldValue
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
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

                // Show notification permission prompt after a brief delay
                if !hasAskedNotificationPermission {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        showNotificationPrompt = true
                    }
                }
            }
        }
        .sheet(isPresented: $showNotificationPrompt) {
            NotificationPermissionSheet(
                onAllow: {
                    hasAskedNotificationPermission = true
                    showNotificationPrompt = false
                    Task {
                        let granted = await DailyVibeNotificationManager.shared.requestPermission()
                        if granted {
                            dailyVibeEnabled = true
                            DailyVibeNotificationManager.shared.scheduleDailyNotification(modelContext: modelContext)
                        }
                    }
                },
                onSkip: {
                    hasAskedNotificationPermission = true
                    showNotificationPrompt = false
                }
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
            .presentationBackground(Color.smBackground)
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

// MARK: - Notification Permission Sheet

private struct NotificationPermissionSheet: View {
    let onAllow: () -> Void
    let onSkip: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var bellScale: CGFloat = 0.6
    @State private var bellOpacity: Double = 0

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            // Bell icon with entrance animation
            ZStack {
                Circle()
                    .fill(Color.smEmerald.opacity(0.1))
                    .frame(width: 100, height: 100)

                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 42, weight: .light))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.smEmerald, .smLightEmerald],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(bellScale)
                    .opacity(bellOpacity)
            }
            .accessibilityHidden(true)

            VStack(spacing: 10) {
                Text("Daily Vibe Check")
                    .font(SMFont.headline(22))
                    .foregroundStyle(Color.smTextPrimary)
                    .accessibilityAddTraits(.isHeader)

                Text("Get a personalized fragrance suggestion\nevery morning at 9 AM based on your\nsaved wardrobe matches.")
                    .font(SMFont.body(15))
                    .foregroundStyle(Color.smTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            VStack(spacing: 12) {
                Button(action: onAllow) {
                    Text("Enable Notifications")
                        .font(SMFont.label())
                        .foregroundStyle(Color.smBackground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(LinearGradient.smPrimaryGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .accessibilityLabel("Enable daily vibe notifications")
                .accessibilityHint("Allows ScentVibe to send you a daily fragrance suggestion at 9 AM")

                Button(action: onSkip) {
                    Text("Maybe Later")
                        .font(SMFont.body(15))
                        .foregroundStyle(Color.smTextTertiary)
                }
                .accessibilityLabel("Skip notifications for now")
            }
            .padding(.horizontal, 24)

            Spacer()
        }
        .padding()
        .onAppear {
            guard !reduceMotion else {
                bellScale = 1.0
                bellOpacity = 1.0
                return
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.15)) {
                bellScale = 1.0
            }
            withAnimation(.easeOut(duration: 0.3)) {
                bellOpacity = 1.0
            }
        }
    }
}
