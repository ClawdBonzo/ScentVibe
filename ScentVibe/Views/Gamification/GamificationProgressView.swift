import SwiftUI

struct GamificationProgressView: View {
    let gamification: GamificationProfile
    let shouldAnimate: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 16) {
            // Level Card
            levelCard

            // XP Progress Bar
            xpProgressBar

            // Streak Flame Display
            if gamification.currentStreak > 0 {
                streakDisplay
            }

            // Quest Summary
            questSummary
        }
        .padding(.horizontal)
    }

    private var levelCard: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.12, green: 0.15, blue: 0.14),
                    Color(red: 0.08, green: 0.1, blue: 0.09),
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(12)

            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    // Level number in circle
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.85, green: 0.72, blue: 0.27),
                                        Color(red: 0.98, green: 0.83, blue: 0.39),
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                            .scaleEffect(shouldAnimate && !reduceMotion ? 1.05 : 1.0)
                            .animation(.easeInOut(duration: 0.6), value: shouldAnimate)

                        Text("\(gamification.level)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.smBackground)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(gamification.levelTitle)
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .foregroundStyle(Color.smTextPrimary)

                        HStack(spacing: 8) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(Color(red: 0.85, green: 0.72, blue: 0.27))

                            Text("\(gamification.totalXP) XP")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(Color.smTextSecondary)
                        }
                    }

                    Spacer()
                }

                Divider()
                    .background(Color.white.opacity(0.1))

                // Next Level Info
                HStack {
                    Text("Next: \(gamification.xpForNextLevel) XP")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.smTextSecondary)

                    Spacer()

                    Text("\(Int(gamification.xpProgressToNextLevel * 100))%")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color(red: 0.85, green: 0.72, blue: 0.27))
                }
            }
            .padding(12)
        }
        .frame(height: 120)
    }

    private var xpProgressBar: some View {
        VStack(spacing: 8) {
            HStack {
                Label("Progress to Level \(gamification.level + 1)", systemImage: "gauge.badge.plus")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.smTextSecondary)

                Spacer()

                Text("\(gamification.currentLevelXP)/\(gamification.xpForNextLevel)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.smTextSecondary)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.08))

                    // Progress
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.85, green: 0.72, blue: 0.27),
                                    Color(red: 0.00, green: 0.85, blue: 0.62),
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * gamification.xpProgressToNextLevel)
                        .animation(.easeInOut(duration: 0.5), value: gamification.currentLevelXP)
                }
            }
            .frame(height: 8)
        }
    }

    private var streakDisplay: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(red: 1.0, green: 0.5, blue: 0.2).opacity(0.2))
                    .frame(width: 50, height: 50)

                HStack(spacing: 2) {
                    Text("🔥")
                        .font(.system(size: 20))
                        .scaleEffect(shouldAnimate && !reduceMotion ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: shouldAnimate)

                    Text("\(gamification.currentStreak)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color(red: 1.0, green: 0.5, blue: 0.2))
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Current Streak")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.smTextPrimary)

                HStack(spacing: 8) {
                    Text("Best: \(gamification.bestStreak)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.smTextSecondary)

                    Text("×\(String(format: "%.1f", gamification.streakMultiplier)) XP")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color(red: 0.00, green: 0.85, blue: 0.62))
                }
            }

            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(Color(red: 0.12, green: 0.15, blue: 0.14))
        .cornerRadius(10)
    }

    private var questSummary: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Daily Quests")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.smTextPrimary)

                let dailyCompleted = gamification.dailyQuests.filter { $0.isCompleted }.count
                Text("\(dailyCompleted)/\(gamification.dailyQuests.count) completed")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.smTextSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("Weekly Quests")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.smTextPrimary)

                let weeklyCompleted = gamification.weeklyQuests.filter { $0.isCompleted }.count
                Text("\(weeklyCompleted)/\(gamification.weeklyQuests.count) completed")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.smTextSecondary)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(Color(red: 0.12, green: 0.15, blue: 0.14))
        .cornerRadius(10)
    }
}

#Preview {
    let profile = GamificationProfile()
    profile.totalXP = 1250
    profile.level = 8
    profile.currentLevelXP = 450
    profile.currentStreak = 5
    profile.bestStreak = 12
    profile.streakMultiplier = 1.5

    return ZStack {
        Color.smBackground.ignoresSafeArea()

        ScrollView {
            VStack(spacing: 20) {
                GamificationProgressView(gamification: profile, shouldAnimate: true)

                Spacer()
            }
            .padding(.vertical)
        }
    }
}
