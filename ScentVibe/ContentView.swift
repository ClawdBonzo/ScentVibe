import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @Query private var gamifications: [GamificationProfile]

    @State private var selectedTab = 0
    @State private var showOnboarding = false
    @State private var showNotificationPrompt = false

    // Gamification overlays
    @State private var showBadgePopup = false
    @State private var unlockedBadge: Badge?
    @State private var showLevelUp = false
    @State private var levelUpInfo: (level: Int, title: String) = (0, "")
    @State private var showQuestComplete = false
    @State private var questCompleteInfo: (title: String, xp: Int) = ("", 0)
    @State private var lastKnownLevel = 0

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("hasAskedNotificationPermission") private var hasAskedNotificationPermission = false
    @AppStorage("dailyVibeEnabled") private var dailyVibeEnabled = false

    // MARK: - Accessors

    private var profile: UserProfile {
        if let existing = profiles.first { return existing }
        let p = UserProfile()
        modelContext.insert(p)
        return p
    }

    private var gamification: GamificationProfile {
        if let existing = gamifications.first { return existing }
        let g = GamificationProfile()
        g.generateDailyQuests()
        g.generateWeeklyQuests()
        modelContext.insert(g)
        return g
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            // Deep layered background
            Color.smBackground.ignoresSafeArea()
            LinearGradient(
                colors: [
                    Color(red: 0.00, green: 0.08, blue: 0.10),
                    Color.smBackground,
                    Color(red: 0.04, green: 0.03, blue: 0.00)
                ],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            // Global floating molecular particle system (every screen)
            MolecularParticleLayer(count: 22)
                .ignoresSafeArea()
                .opacity(0.55)
                .allowsHitTesting(false)

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

                GamificationDashboardView(
                    gamification: gamification,
                    onQuestComplete: { questId, xp in
                        handleQuestComplete(id: questId, xp: xp)
                    },
                    onBadgeUnlock: { ids in
                        handleBadgeUnlock(ids: ids)
                    }
                )
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Progress")
                    }
                    .tag(3)

                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
                    .tag(4)
            }
            .tint(Color.smEmerald)
            .onChange(of: selectedTab) { _, _ in
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }

            // ── Level-up overlay ──
            if showLevelUp {
                LevelUpAnimationView(
                    newLevel: levelUpInfo.level,
                    levelTitle: levelUpInfo.title
                ) {
                    showLevelUp = false
                }
                .zIndex(200)
                .transition(.opacity)
            }

            // ── Quest completion toast ──
            if showQuestComplete {
                QuestCompletionView(
                    questTitle: questCompleteInfo.title,
                    xpEarned: questCompleteInfo.xp
                ) {
                    showQuestComplete = false
                }
                .zIndex(100)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            // ── Badge unlock popup ──
            if showBadgePopup, let badge = unlockedBadge {
                BadgeUnlockPopupView(badge: badge)
                    .zIndex(150)
                    .transition(.opacity)
                    .onTapGesture { showBadgePopup = false }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            setupTabBarAppearance()
            if !hasCompletedOnboarding {
                showOnboarding = true
            }
            if gamification.dailyQuests.isEmpty {
                gamification.generateDailyQuests()
            }
            lastKnownLevel = gamification.level
        }
        .onChange(of: gamification.level) { _, newLevel in
            guard newLevel > lastKnownLevel, lastKnownLevel > 0 else {
                lastKnownLevel = newLevel; return
            }
            lastKnownLevel = newLevel
            // Delay slightly so XP bar finishes animating first
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                levelUpInfo = (newLevel, gamification.levelTitle)
                withAnimation { showLevelUp = true }
            }
        }
        .fullScreenCover(isPresented: $showOnboarding, onDismiss: onOnboardingDismissed) {
            OnboardingView {
                hasCompletedOnboarding = true
                profile.hasCompletedOnboarding = true
                showOnboarding = false
            }
            .interactiveDismissDisabled()
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

    // MARK: - Event Handlers

    private func handleQuestComplete(id: String, xp: Int) {
        // Find the quest title for display
        let quest = gamification.allQuests.first { $0.id == id }
        questCompleteInfo = (quest?.title ?? "Quest", xp)

        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            showQuestComplete = true
        }
    }

    private func handleBadgeUnlock(ids: [String]) {
        guard let firstId = ids.first, let badge = BadgeManager.badge(forId: firstId) else { return }
        ids.forEach { gamification.unlockBadge($0) }
        unlockedBadge = badge
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation { showBadgePopup = true }
        }
    }

    private func onOnboardingDismissed() {
        selectedTab = 1
        if !hasAskedNotificationPermission {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                showNotificationPrompt = true
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

// MARK: - Notification Permission Sheet

private struct NotificationPermissionSheet: View {
    let onAllow: () -> Void
    let onSkip: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var bellScale: CGFloat = 0.6
    @State private var bellOpacity: Double = 0
    @State private var contentOpacity: Double = 0

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.smEmerald.opacity(0.1))
                    .frame(width: 100, height: 100)

                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 42, weight: .light))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.smEmerald, Color.smTeal],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
            }
            .scaleEffect(bellScale)
            .opacity(bellOpacity)
            .accessibilityHidden(true)

            VStack(spacing: 12) {
                Text("Daily Vibe Alerts")
                    .font(SMFont.headline(22))
                    .foregroundStyle(Color.smTextPrimary)

                Text("Get a daily scent inspiration at 9 AM —\ntailored to your fragrance wardrobe.")
                    .font(SMFont.body(15))
                    .foregroundStyle(Color.smTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .opacity(contentOpacity)
            .padding(.horizontal, 28)

            Spacer()

            VStack(spacing: 14) {
                Button(action: onAllow) {
                    HStack(spacing: 8) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 15, weight: .semibold))
                        Text("Allow Notifications")
                            .font(SMFont.headline(17))
                    }
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: SMTheme.buttonHeight)
                    .background(
                        LinearGradient(
                            colors: [Color.smEmerald, Color.smTeal],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .cornerRadius(SMTheme.cornerRadius)
                }
                .padding(.horizontal, 28)

                Button(action: onSkip) {
                    Text("Maybe Later")
                        .font(SMFont.body(15))
                        .foregroundStyle(Color.smTextSecondary)
                }
                .padding(.bottom, 8)
            }
            .opacity(contentOpacity)
        }
        .padding(.bottom, 16)
        .onAppear {
            withAnimation(reduceMotion ? .linear(duration: 0) : .interpolatingSpring(mass: 1, stiffness: 100, damping: 14).delay(0.15)) {
                bellScale = 1.0
                bellOpacity = 1.0
            }
            withAnimation(reduceMotion ? .linear(duration: 0) : .easeOut(duration: 0.45).delay(0.35)) {
                contentOpacity = 1.0
            }
        }
    }
}
