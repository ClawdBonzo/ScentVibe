import SwiftUI

struct GamificationDashboardView: View {
    @Bindable var gamification: GamificationProfile
    var onQuestComplete: (String, Int) -> Void    // id, xpEarned
    var onBadgeUnlock: ([String]) -> Void

    @State private var selectedTab: GTab = .progress
    @State private var tabAppeared = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    enum GTab: CaseIterable {
        case progress, quests, badges
        var label: String {
            switch self {
            case .progress: return "Progress"
            case .quests:   return "Quests"
            case .badges:   return "Badges"
            }
        }
        var icon: String {
            switch self {
            case .progress: return "chart.line.uptrend.xyaxis"
            case .quests:   return "list.bullet.circle.fill"
            case .badges:   return "star.circle.fill"
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.smBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // ── Duolingo-style pill tab bar ──
                    pillTabBar
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 12)

                    Divider().background(Color.white.opacity(0.06))

                    // ── Tab content ──
                    Group {
                        switch selectedTab {
                        case .progress:
                            GamificationProgressView(
                                gamification: gamification,
                                shouldAnimate: tabAppeared
                            )
                            .transition(.opacity.combined(with: .offset(y: 12)))

                        case .quests:
                            QuestsView(gamification: gamification) { questId, xp in
                                onQuestComplete(questId, xp)
                            }
                            .transition(.opacity.combined(with: .offset(y: 12)))

                        case .badges:
                            BadgesView(gamification: gamification)
                                .transition(.opacity.combined(with: .offset(y: 12)))
                        }
                    }
                    .animation(reduceMotion ? nil : .easeOut(duration: 0.28), value: selectedTab)
                }
            }
            .navigationTitle("My Progress")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                tabAppeared = true
            }
        }
    }

    // MARK: Pill Tab Bar

    private var pillTabBar: some View {
        HStack(spacing: 8) {
            ForEach(GTab.allCases, id: \.self) { tab in
                Button(action: {
                    guard selectedTab != tab else { return }
                    if !reduceMotion {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                    withAnimation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.75)) {
                        selectedTab = tab
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 13, weight: .semibold))

                        Text(tab.label)
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .padding(.vertical, 9)
                    .padding(.horizontal, 14)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(
                        selectedTab == tab
                            ? Color(red: 0.06, green: 0.06, blue: 0.06)
                            : Color.smTextSecondary
                    )
                    .background(
                        Group {
                            if selectedTab == tab {
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.98, green: 0.82, blue: 0.28),
                                                Color(red: 0.00, green: 0.85, blue: 0.62),
                                            ],
                                            startPoint: .leading, endPoint: .trailing
                                        )
                                    )
                                    .matchedGeometryEffect(id: "tab_pill", in: tabNS)
                            } else {
                                Capsule()
                                    .fill(Color.white.opacity(0.05))
                            }
                        }
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(tab.label)
                .accessibilityAddTraits(selectedTab == tab ? [.isSelected] : [])
            }
        }
        .animation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.75), value: selectedTab)
    }

    @Namespace private var tabNS
}

#Preview {
    let profile = GamificationProfile()
    profile.totalXP = 4800
    profile.level = 14
    profile.currentLevelXP = 700
    profile.currentStreak = 12
    profile.bestStreak = 30
    profile.streakMultiplier = 1.5
    profile.generateDailyQuests()
    profile.generateWeeklyQuests()
    profile.unlockedBadgeIds = ["streak_3", "collector_10", "level_10"]

    return GamificationDashboardView(
        gamification: profile,
        onQuestComplete: { _, _ in },
        onBadgeUnlock: { _ in }
    )
}
