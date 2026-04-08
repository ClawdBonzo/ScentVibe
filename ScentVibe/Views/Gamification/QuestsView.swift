import SwiftUI

struct QuestsView: View {
    @Bindable var gamification: GamificationProfile
    var onQuestComplete: (String, Int) -> Void    // questId, xpEarned

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Daily
                if !gamification.dailyQuests.isEmpty {
                    questSection(
                        title: "Daily Quests",
                        subtitle: "Resets each day",
                        icon: "☀️",
                        quests: gamification.dailyQuests
                    )
                }

                // Weekly
                if !gamification.weeklyQuests.isEmpty {
                    questSection(
                        title: "Weekly Quests",
                        subtitle: "Big rewards await",
                        icon: "📅",
                        quests: gamification.weeklyQuests
                    )
                }

                Spacer(minLength: 32)
            }
            .padding(.vertical, 16)
        }
    }

    // MARK: Section

    private func questSection(title: String, subtitle: String, icon: String, quests: [QuestData]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 8) {
                Text(icon).font(.system(size: 18))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Color.smTextPrimary)
                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.smTextSecondary)
                }

                Spacer()

                let done = quests.filter { $0.isCompleted }.count
                Text("\(done)/\(quests.count)")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        done == quests.count
                            ? Color(red: 0.00, green: 0.85, blue: 0.62)
                            : Color(red: 0.98, green: 0.82, blue: 0.28)
                    )
            }
            .padding(.horizontal)

            // Cards
            VStack(spacing: 10) {
                ForEach(quests) { quest in
                    questCard(quest)
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: Quest Card

    private func questCard(_ quest: QuestData) -> some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    quest.isCompleted
                        ? Color(red: 0.00, green: 0.85, blue: 0.62).opacity(0.08)
                        : Color(red: 0.09, green: 0.12, blue: 0.12)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(
                            quest.isCompleted
                                ? Color(red: 0.00, green: 0.85, blue: 0.62).opacity(0.4)
                                : Color.white.opacity(0.06),
                            lineWidth: 1
                        )
                )

            VStack(spacing: 10) {
                HStack(spacing: 12) {
                    // Emoji icon
                    Text(quest.icon)
                        .font(.system(size: 26))

                    // Info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(quest.title)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(quest.isCompleted ? Color.smTextSecondary : Color.smTextPrimary)
                            .strikethrough(quest.isCompleted)

                        Text(quest.description)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color.smTextSecondary)
                            .lineLimit(2)
                    }

                    Spacer()

                    // XP + status
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("+\(quest.xpReward)")
                            .font(.system(size: 14, weight: .black, design: .rounded))
                            .foregroundStyle(
                                quest.isCompleted
                                    ? Color(red: 0.00, green: 0.85, blue: 0.62)
                                    : Color(red: 0.98, green: 0.82, blue: 0.28)
                            )

                        Image(systemName: quest.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(
                                quest.isCompleted
                                    ? Color(red: 0.00, green: 0.85, blue: 0.62)
                                    : Color.smTextSecondary
                            )
                    }
                }

                // Progress bar (only when in progress)
                if !quest.isCompleted && quest.target > 1 {
                    VStack(spacing: 5) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white.opacity(0.07))

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.98, green: 0.82, blue: 0.28),
                                                Color(red: 0.00, green: 0.85, blue: 0.62),
                                            ],
                                            startPoint: .leading, endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geo.size.width * quest.progressRatio)
                                    .animation(.easeOut(duration: 0.5), value: quest.progress)
                            }
                        }
                        .frame(height: 6)

                        HStack {
                            Text("\(quest.progress) / \(quest.target)")
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.smTextSecondary)

                            Spacer()

                            Text("\(Int(quest.progressRatio * 100))%")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(red: 0.98, green: 0.82, blue: 0.28))
                        }
                    }
                }
            }
            .padding(14)
        }
        .onTapGesture {
            // Only allow completion tap if fully done but not marked yet
            if !quest.isCompleted && quest.progress >= quest.target {
                handleQuestComplete(quest)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(quest.title): \(quest.isCompleted ? "complete" : "\(quest.progress) of \(quest.target)")")
        .accessibilityHint(quest.isCompleted ? "Complete" : "Tap when done to claim \(quest.xpReward) XP")
    }

    private func handleQuestComplete(_ quest: QuestData) {
        gamification.completeQuest(id: quest.id)
        onQuestComplete(quest.id, quest.xpReward)

        if !reduceMotion {
            GamificationHaptics.questCompleted()
        }
    }
}

#Preview {
    let profile = GamificationProfile()
    profile.generateDailyQuests()
    profile.generateWeeklyQuests()

    return ZStack {
        Color.smBackground.ignoresSafeArea()
        QuestsView(gamification: profile) { _, _ in }
    }
}
