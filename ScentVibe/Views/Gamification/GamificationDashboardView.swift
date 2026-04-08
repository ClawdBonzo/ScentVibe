import SwiftUI

struct GamificationDashboardView: View {
    @Bindable var gamification: GamificationProfile
    var onQuestComplete: (String) -> Void
    var onBadgeUnlock: ([String]) -> Void

    @State private var selectedTab: GamificationTab = .progress
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    enum GamificationTab {
        case progress, quests, badges
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.smBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Tab Selector
                    HStack(spacing: 0) {
                        ForEach([GamificationTab.progress, .quests, .badges], id: \.self) { tab in
                            Button(action: { selectedTab = tab }) {
                                VStack(spacing: 4) {
                                    tabIcon(for: tab)
                                        .font(.system(size: 16))

                                    Text(tabLabel(for: tab))
                                        .font(.system(size: 11, weight: .semibold))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .foregroundStyle(
                                    selectedTab == tab
                                        ? Color(red: 0.85, green: 0.72, blue: 0.27)
                                        : Color.smTextSecondary
                                )
                            }

                            if tab != GamificationTab.badges {
                                Divider()
                                    .frame(height: 20)
                            }
                        }
                    }
                    .frame(height: 60)
                    .background(Color(red: 0.08, green: 0.1, blue: 0.09))
                    .borderTop(Color.white.opacity(0.1), width: 1)

                    // Content
                    Group {
                        switch selectedTab {
                        case .progress:
                            GamificationProgressView(
                                gamification: gamification,
                                shouldAnimate: true
                            )
                            .padding(.vertical, 16)

                        case .quests:
                            QuestsView(gamification: gamification) { questId in
                                onQuestComplete(questId)
                            }

                        case .badges:
                            BadgesView(gamification: gamification)
                        }
                    }
                }
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func tabIcon(for tab: GamificationTab) -> Image {
        switch tab {
        case .progress: return Image(systemName: "chart.line.uptrend.xyaxis")
        case .quests: return Image(systemName: "checkmark.circle")
        case .badges: return Image(systemName: "star.circle")
        }
    }

    private func tabLabel(for tab: GamificationTab) -> String {
        switch tab {
        case .progress: return "Progress"
        case .quests: return "Quests"
        case .badges: return "Badges"
        }
    }
}

extension View {
    func borderTop(_ color: Color, width: CGFloat) -> some View {
        VStack(spacing: 0) {
            Divider()
                .frame(height: width)
                .overlay(color)

            self
        }
    }
}

#Preview {
    let profile = GamificationProfile()
    profile.totalXP = 2500
    profile.level = 12
    profile.currentLevelXP = 800
    profile.currentStreak = 8
    profile.bestStreak = 15
    profile.streakMultiplier = 1.8
    profile.generateDailyQuests()
    profile.generateWeeklyQuests()
    profile.unlockedBadgeIds = ["streak_3", "collector_10", "level_10", "matches_50"]

    return GamificationDashboardView(
        gamification: profile,
        onQuestComplete: { _ in },
        onBadgeUnlock: { _ in }
    )
}
