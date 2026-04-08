import SwiftUI

struct GamificationProgressView: View {
    let gamification: GamificationProfile
    let shouldAnimate: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var xpBarWidth: CGFloat = 0
    @State private var orbPulse = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // ── XP Orb + Level card ──
                levelOrbCard

                // ── Streak ──
                if gamification.currentStreak > 0 {
                    StreakBadgeRow(
                        currentStreak: gamification.currentStreak,
                        bestStreak: gamification.bestStreak,
                        multiplier: gamification.streakMultiplier
                    )
                    .padding(.horizontal)
                }

                // ── XP Progress bar ──
                xpProgressSection

                // ── Quest snapshot ──
                questSnapshot

                Spacer(minLength: 32)
            }
            .padding(.vertical, 16)
        }
    }

    // MARK: Level Orb Card

    private var levelOrbCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.10, green: 0.14, blue: 0.14),
                            Color(red: 0.07, green: 0.09, blue: 0.09),
                        ],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.98, green: 0.82, blue: 0.28).opacity(0.4),
                                    Color(red: 0.00, green: 0.85, blue: 0.62).opacity(0.2),
                                ],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )

            HStack(spacing: 20) {
                // Glowing orb
                ZStack {
                    // Outer glow
                    if !reduceMotion {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color(red: 0.98, green: 0.82, blue: 0.28).opacity(orbPulse ? 0.3 : 0.15),
                                        .clear,
                                    ],
                                    center: .center, startRadius: 4, endRadius: 42
                                )
                            )
                            .frame(width: 84, height: 84)
                    }

                    // Orb
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.98, green: 0.84, blue: 0.38),
                                    Color(red: 0.82, green: 0.65, blue: 0.18),
                                ],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 64, height: 64)
                        .scaleEffect(orbPulse && !reduceMotion ? 1.06 : 1.0)
                        .shadow(color: Color(red: 0.98, green: 0.80, blue: 0.25).opacity(0.4), radius: 10)

                    // Level number
                    Text("\(gamification.level)")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(Color(red: 0.2, green: 0.12, blue: 0.0))
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(gamification.levelTitle)
                        .font(.system(size: 17, weight: .bold, design: .default))
                        .foregroundStyle(Color.smTextPrimary)

                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(Color(red: 0.98, green: 0.82, blue: 0.28))

                        Text("\(gamification.totalXP) total XP")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color.smTextSecondary)
                    }

                    Text("\(gamification.unlockedBadgeIds.count) badge\(gamification.unlockedBadgeIds.count == 1 ? "" : "s") earned")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.smTextSecondary)
                }

                Spacer()
            }
            .padding(16)
        }
        .frame(height: 110)
        .padding(.horizontal)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                orbPulse = true
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Level \(gamification.level), \(gamification.levelTitle), \(gamification.totalXP) total XP")
    }

    // MARK: XP Progress Bar

    private var xpProgressSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("Progress to Level \(gamification.level + 1)", systemImage: "arrow.up.circle")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.smTextSecondary)

                Spacer()

                Text("\(gamification.currentLevelXP) / \(gamification.xpForNextLevel) XP")
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundStyle(Color.smTextSecondary)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Track
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.07))

                    // Fill
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.98, green: 0.82, blue: 0.28),
                                    Color(red: 0.00, green: 0.85, blue: 0.62),
                                ],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .frame(
                            width: shouldAnimate
                                ? geo.size.width * gamification.xpProgressToNextLevel
                                : 0
                        )
                        .animation(.easeOut(duration: 1.1).delay(0.2), value: shouldAnimate)
                }
            }
            .frame(height: 9)

            Text("\(Int(gamification.xpProgressToNextLevel * 100))% complete")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Color.smTextSecondary)
        }
        .padding(.horizontal)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("XP Progress: \(Int(gamification.xpProgressToNextLevel * 100)) percent to level \(gamification.level + 1)")
    }

    // MARK: Quest Snapshot

    private var questSnapshot: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Today's Quests", systemImage: "list.bullet.circle.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.smTextPrimary)

                Spacer()

                let dailyCompleted = gamification.dailyQuests.filter { $0.isCompleted }.count
                Text("\(dailyCompleted)/\(gamification.dailyQuests.count) done")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(
                        dailyCompleted == gamification.dailyQuests.count
                            ? Color(red: 0.00, green: 0.85, blue: 0.62)
                            : Color(red: 0.98, green: 0.82, blue: 0.28)
                    )
            }

            VStack(spacing: 8) {
                ForEach(gamification.dailyQuests.prefix(3)) { quest in
                    MiniQuestRow(quest: quest)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(red: 0.09, green: 0.12, blue: 0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(Color.white.opacity(0.06), lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }
}

// MARK: - Mini Quest Row

private struct MiniQuestRow: View {
    let quest: QuestData

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Text(quest.icon)
                .font(.system(size: 18))

            // Title + bar
            VStack(alignment: .leading, spacing: 4) {
                Text(quest.title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(quest.isCompleted ? Color.smTextSecondary : Color.smTextPrimary)
                    .strikethrough(quest.isCompleted)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white.opacity(0.07))

                        RoundedRectangle(cornerRadius: 3)
                            .fill(
                                quest.isCompleted
                                    ? Color(red: 0.00, green: 0.85, blue: 0.62)
                                    : Color(red: 0.98, green: 0.82, blue: 0.28)
                            )
                            .frame(width: geo.size.width * quest.progressRatio)
                    }
                }
                .frame(height: 4)
            }

            Spacer()

            // XP badge
            Text("+\(quest.xpReward)")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(quest.isCompleted ? Color.smTextSecondary : Color(red: 0.98, green: 0.82, blue: 0.28))

            // Status check
            Image(systemName: quest.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 16))
                .foregroundStyle(
                    quest.isCompleted
                        ? Color(red: 0.00, green: 0.85, blue: 0.62)
                        : Color.smTextSecondary
                )
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(quest.title): \(quest.isCompleted ? "complete" : "\(quest.progress) of \(quest.target)"). +\(quest.xpReward) XP")
    }
}

#Preview {
    let profile = GamificationProfile()
    profile.totalXP = 3200
    profile.level = 11
    profile.currentLevelXP = 550
    profile.currentStreak = 8
    profile.bestStreak = 23
    profile.streakMultiplier = 1.3
    profile.generateDailyQuests()

    return ZStack {
        Color.smBackground.ignoresSafeArea()
        GamificationProgressView(gamification: profile, shouldAnimate: true)
    }
}
