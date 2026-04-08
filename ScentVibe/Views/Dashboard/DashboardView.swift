import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \ScentMatchResult.timestamp, order: .reverse) private var matches: [ScentMatchResult]
    @Query private var gamifications: [GamificationProfile]

    @State private var selectedMatch: ScentMatchResult?

    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    private var gamification: GamificationProfile? { gamifications.first }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.smBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) {
                        // ── Gamification summary strip ──
                        if let g = gamification {
                            GamificationStripView(gamification: g)
                                .padding(.horizontal)
                                .padding(.top, 8)
                                .padding(.bottom, 16)
                        }

                        // ── Match grid or empty state ──
                        if matches.isEmpty {
                            DashboardEmptyState()
                                .frame(minHeight: 420)
                        } else {
                            // Section header
                            HStack {
                                Text("Recent Matches")
                                    .font(SMFont.headline(16))
                                    .foregroundStyle(Color.smTextSecondary)

                                Spacer()

                                Text("\(matches.count)")
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Color.smTextTertiary)
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)

                            LazyVGrid(columns: columns, spacing: 12) {
                                ForEach(matches) { match in
                                    MatchCardView(match: match)
                                        .accessibilityHint("Tap to view match details")
                                        .onTapGesture { selectedMatch = match }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 32)
                        }
                    }
                }
            }
            .navigationTitle("ScentVibe")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedMatch) { match in
                matchDetailSheet(for: match)
            }
        }
    }

    @ViewBuilder
    private func matchDetailSheet(for match: ScentMatchResult) -> some View {
        if let firstRec = match.recommendations.first,
           let fragrance = firstRec.fragrance() {
            MatchDetailView(
                fragrance: fragrance,
                recommendation: firstRec,
                matchResult: match
            )
        }
    }
}

// MARK: - Gamification Strip

private struct GamificationStripView: View {
    let gamification: GamificationProfile
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var dailyQuestsDone: Int {
        gamification.dailyQuests.filter { $0.isCompleted }.count
    }
    private var dailyQuestsTotal: Int { gamification.dailyQuests.count }
    private var questProgress: Double {
        dailyQuestsTotal == 0 ? 0 : Double(dailyQuestsDone) / Double(dailyQuestsTotal)
    }

    var body: some View {
        HStack(spacing: 0) {
            // Streak
            HStack(spacing: 8) {
                StreakFlameView(streak: gamification.currentStreak, size: 30)

                VStack(alignment: .leading, spacing: 1) {
                    Text("\(gamification.currentStreak)")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 1, green: 0.6, blue: 0.1))

                    Text("streak")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Color.smTextSecondary)
                }
            }
            .frame(maxWidth: .infinity)

            Divider()
                .frame(height: 32)
                .background(Color.white.opacity(0.1))

            // Level
            VStack(spacing: 2) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(Color(red: 0.98, green: 0.82, blue: 0.28))

                    Text("Lvl \(gamification.level)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.smTextPrimary)
                }

                Text(gamification.levelTitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Color.smTextSecondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)

            Divider()
                .frame(height: 32)
                .background(Color.white.opacity(0.1))

            // Daily quests
            VStack(spacing: 2) {
                HStack(spacing: 4) {
                    Image(systemName: dailyQuestsDone == dailyQuestsTotal && dailyQuestsTotal > 0 ? "checkmark.circle.fill" : "circle.dashed")
                        .font(.system(size: 11))
                        .foregroundStyle(
                            dailyQuestsDone == dailyQuestsTotal && dailyQuestsTotal > 0
                                ? Color(red: 0.00, green: 0.85, blue: 0.62)
                                : Color.smTextSecondary
                        )

                    Text("\(dailyQuestsDone)/\(dailyQuestsTotal)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.smTextPrimary)
                }

                Text("quests")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Color.smTextSecondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(red: 0.09, green: 0.12, blue: 0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.98, green: 0.82, blue: 0.28).opacity(0.25),
                                    Color(red: 0.00, green: 0.85, blue: 0.62).opacity(0.15),
                                ],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Gamification: \(gamification.currentStreak)-day streak, Level \(gamification.level), \(dailyQuestsDone) of \(dailyQuestsTotal) daily quests complete")
    }
}

// MARK: - Empty State

private struct DashboardEmptyState: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showContent = false
    @State private var orbPulse = false
    @State private var sparkleRotation: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.smEmerald.opacity(orbPulse ? 0.12 : 0.06),
                                Color.smTeal.opacity(0.04), .clear,
                            ],
                            center: .center, startRadius: 15, endRadius: 95
                        )
                    )
                    .frame(width: 190, height: 190)

                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(Color.smEmerald.opacity(0.3 - Double(i) * 0.08))
                        .frame(width: 5 - CGFloat(i), height: 5 - CGFloat(i))
                        .offset(x: CGFloat(50 + i * 12))
                        .rotationEffect(.degrees(sparkleRotation + Double(i) * 120))
                }

                Circle()
                    .stroke(Color.smEmerald.opacity(0.1), lineWidth: 1)
                    .frame(width: 120, height: 120)
                    .scaleEffect(orbPulse ? 1.06 : 0.96)

                Image(systemName: "sparkles")
                    .font(.system(size: 52, weight: .thin))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.smEmerald.opacity(0.7), Color.smTeal.opacity(0.5)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(orbPulse ? 1.05 : 0.97)
            }
            .opacity(showContent ? 1 : 0)
            .scaleEffect(showContent ? 1 : 0.8)
            .accessibilityHidden(true)

            Spacer().frame(height: 28)

            Text("Discover Your Scent")
                .font(SMFont.headline(24))
                .foregroundStyle(Color.smTextPrimary)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 12)
                .accessibilityAddTraits(.isHeader)

            Spacer().frame(height: 12)

            Text("Snap a photo of your outfit or room\nand our AI will match your perfect fragrance.")
                .font(SMFont.body(15))
                .foregroundStyle(Color.smTextSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 12)

            Spacer().frame(height: 32)

            VStack(spacing: 14) {
                featureRow(icon: "camera.fill",            text: "Scan any photo for a scent match")
                featureRow(icon: "brain.head.profile.fill", text: "AI analyzes colors, mood & texture")
                featureRow(icon: "heart.fill",             text: "Save favorites to your wardrobe")
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 16)

            Spacer()

            HStack(spacing: 6) {
                Image(systemName: "camera")
                    .font(.system(size: 10))
                Text("Head to the Scan tab to get started")
                    .font(SMFont.label(11))
            }
            .foregroundStyle(Color.smTextTertiary.opacity(0.6))
            .opacity(showContent ? 1 : 0)
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 32)
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) { showContent = true }
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) { orbPulse = true }
            withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) { sparkleRotation = 360 }
        }
    }

    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.smEmerald.opacity(0.7))
                .frame(width: 28)

            Text(text)
                .font(SMFont.body(14))
                .foregroundStyle(Color.smTextSecondary)

            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(text)
    }
}
