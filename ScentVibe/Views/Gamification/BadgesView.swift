import SwiftUI

struct BadgesView: View {
    let gamification: GamificationProfile

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        NavigationStack {
            ZStack {
                Color.smBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Unlocked Badges
                        if !gamification.unlockedBadgeIds.isEmpty {
                            badgeSection(
                                title: "🏆 Unlocked",
                                badges: gamification.unlockedBadgeIds.compactMap { BadgeManager.badge(forId: $0) },
                                locked: false
                            )
                        }

                        // Locked Badges
                        let lockedBadges = BadgeManager.allBadges.filter { !gamification.unlockedBadgeIds.contains($0.id) }
                        if !lockedBadges.isEmpty {
                            badgeSection(
                                title: "🔒 Locked",
                                badges: lockedBadges,
                                locked: true
                            )
                        }

                        Spacer(minLength: 32)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Badges")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func badgeSection(title: String, badges: [Badge], locked: Bool) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.smTextSecondary)
                .padding(.horizontal)

            let columns = [GridItem(.flexible()), GridItem(.flexible())]
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(badges) { badge in
                    badgeCard(badge, locked: locked)
                }
            }
            .padding(.horizontal)
        }
    }

    private func badgeCard(_ badge: Badge, locked: Bool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    locked
                        ? LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.4),
                                Color.black.opacity(0.2),
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        : LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.12, green: 0.15, blue: 0.14),
                                Color(red: 0.08, green: 0.1, blue: 0.09),
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                )

            if !locked {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.85, green: 0.72, blue: 0.27),
                                Color(red: 0.00, green: 0.85, blue: 0.62),
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }

            VStack(spacing: 12) {
                Text(badge.icon)
                    .font(.system(size: 36))
                    .opacity(locked ? 0.5 : 1.0)
                    .scaleEffect(!locked && !reduceMotion ? 1.05 : 1.0)

                VStack(spacing: 4) {
                    Text(badge.name)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.smTextPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)

                    Text(badge.unlockCondition)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Color.smTextSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }

                if locked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.smTextSecondary)
                }
            }
            .padding(12)
        }
    }
}

#Preview {
    let profile = GamificationProfile()
    profile.unlockedBadgeIds = ["streak_3", "collector_10", "level_10"]

    return BadgesView(gamification: profile)
}
