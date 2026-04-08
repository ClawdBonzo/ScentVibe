import SwiftUI

struct QuestsView: View {
    @Bindable var gamification: GamificationProfile
    var onQuestComplete: (String) -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        NavigationStack {
            ZStack {
                Color.smBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Daily Quests Section
                        if !gamification.dailyQuests.isEmpty {
                            questSection(
                                title: "Daily Quests",
                                subtitle: "Complete for bonus XP",
                                quests: gamification.dailyQuests,
                                icon: "☀️"
                            )
                        }

                        // Weekly Quests Section
                        if !gamification.weeklyQuests.isEmpty {
                            questSection(
                                title: "Weekly Quests",
                                subtitle: "Major rewards await",
                                quests: gamification.weeklyQuests,
                                icon: "📅"
                            )
                        }

                        Spacer(minLength: 32)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Quests")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func questSection(title: String, subtitle: String, quests: [QuestData], icon: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text(icon)
                    .font(.system(size: 20))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.smTextPrimary)

                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.smTextSecondary)
                }

                Spacer()

                let completed = quests.filter { $0.isCompleted }.count
                Text("\(completed)/\(quests.count)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(red: 0.85, green: 0.72, blue: 0.27))
            }
            .padding(.horizontal)

            VStack(spacing: 10) {
                ForEach(quests) { quest in
                    questCard(quest)
                }
            }
            .padding(.horizontal)
        }
    }

    private func questCard(_ quest: QuestData) -> some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    quest.isCompleted
                        ? LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.00, green: 0.85, blue: 0.62).opacity(0.15),
                                Color(red: 0.00, green: 0.85, blue: 0.62).opacity(0.08),
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

            if quest.isCompleted {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color(red: 0.00, green: 0.85, blue: 0.62), lineWidth: 1)
            }

            VStack(spacing: 10) {
                HStack(spacing: 12) {
                    Text(quest.icon)
                        .font(.system(size: 24))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(quest.title)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.smTextPrimary)
                            .lineLimit(1)

                        Text(quest.description)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color.smTextSecondary)
                            .lineLimit(2)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("+\(quest.xpReward)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(
                                quest.isCompleted
                                    ? Color(red: 0.00, green: 0.85, blue: 0.62)
                                    : Color(red: 0.85, green: 0.72, blue: 0.27)
                            )

                        Image(systemName: quest.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(
                                quest.isCompleted
                                    ? Color(red: 0.00, green: 0.85, blue: 0.62)
                                    : Color.smTextSecondary
                            )
                    }
                }

                // Progress bar
                if !quest.isCompleted && quest.target > 0 {
                    VStack(spacing: 6) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white.opacity(0.08))

                                RoundedRectangle(cornerRadius: 4)
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
                                    .frame(width: geo.size.width * quest.progressRatio)
                            }
                        }
                        .frame(height: 6)

                        HStack {
                            Text("\(quest.progress)/\(quest.target)")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(Color.smTextSecondary)

                            Spacer()

                            Text("\(Int(quest.progressRatio * 100))%")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(Color(red: 0.85, green: 0.72, blue: 0.27))
                        }
                    }
                }
            }
            .padding(12)
        }
        .onTapGesture {
            if !quest.isCompleted && quest.progress >= quest.target {
                completeQuest(quest)
            }
        }
    }

    private func completeQuest(_ quest: QuestData) {
        gamification.completeQuest(id: quest.id)
        onQuestComplete(quest.id)

        if !reduceMotion {
            GamificationHaptics.questCompleted()
        }
    }
}

#Preview {
    let profile = GamificationProfile()
    profile.generateDailyQuests()
    profile.generateWeeklyQuests()

    return QuestsView(gamification: profile) { _ in }
}
