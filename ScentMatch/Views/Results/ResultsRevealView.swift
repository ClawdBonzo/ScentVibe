import SwiftUI

struct ResultsRevealView: View {
    let matchResult: ScentMatchResult
    let recommendations: [RecommendationEntry]
    let analysisResult: ImageAnalysisResult?

    @Environment(\.dismiss) private var dismiss
    @State private var showContent = false
    @State private var showCards = false
    @State private var revealedCards: Set<Int> = []
    @State private var selectedRecommendation: RecommendationEntry?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.smBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Hero section with vibe score
                        vibeScoreHero
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 30)

                        // Photo with detected colors overlay
                        photoSection
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)

                        // Mood tags
                        if !matchResult.detectedMoodTags.isEmpty {
                            moodSection
                                .opacity(showContent ? 1 : 0)
                        }

                        // Fragrance cards
                        Text("Your Scent Matches")
                            .font(SMFont.headline(20))
                            .foregroundStyle(.smTextPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .opacity(showCards ? 1 : 0)

                        ForEach(Array(recommendations.prefix(5).enumerated()), id: \.element.id) { idx, rec in
                            if let fragrance = rec.fragrance() {
                                recommendationCard(fragrance: fragrance, rec: rec, index: idx)
                                    .opacity(revealedCards.contains(idx) ? 1 : 0)
                                    .offset(y: revealedCards.contains(idx) ? 0 : 40)
                                    .onTapGesture {
                                        selectedRecommendation = rec
                                    }
                            }
                        }

                        // Close button
                        Button(action: { dismiss() }) {
                            Text("Done")
                                .font(SMFont.headline(18))
                                .foregroundStyle(.smEmerald)
                                .frame(maxWidth: .infinity)
                                .frame(height: SMTheme.buttonHeight)
                                .background(Color.smEmerald.opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: SMTheme.cornerRadius))
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 32)
                        .opacity(showCards ? 1 : 0)
                    }
                }
            }
            .navigationTitle("Your Match")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.smTextSecondary)
                    }
                }
            }
            .sheet(item: $selectedRecommendation) { rec in
                if let fragrance = rec.fragrance() {
                    MatchDetailView(
                        fragrance: fragrance,
                        recommendation: rec,
                        matchResult: matchResult
                    )
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            triggerRevealSequence()
        }
    }

    // MARK: - Vibe Score Hero

    private var vibeScoreHero: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(Color.smTeal.opacity(0.2), lineWidth: 8)
                    .frame(width: 140, height: 140)

                Circle()
                    .trim(from: 0, to: showContent ? matchResult.vibeScore / 100.0 : 0)
                    .stroke(
                        LinearGradient.smVibeGradient,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 1.5).delay(0.3), value: showContent)

                VStack(spacing: 2) {
                    Text(String(format: "%.0f", matchResult.vibeScore))
                        .font(SMFont.display(40))
                        .foregroundStyle(.smTextPrimary)
                    Text("Vibe Score")
                        .font(SMFont.label())
                        .foregroundStyle(.smTextSecondary)
                }
            }

            Text(vibeDescription)
                .font(SMFont.body())
                .foregroundStyle(.smEmerald)
        }
        .padding(.top, 20)
    }

    private var vibeDescription: String {
        switch matchResult.vibeScore {
        case 80...: return "Exceptional match!"
        case 60..<80: return "Strong match"
        case 40..<60: return "Good match"
        default: return "Interesting combo"
        }
    }

    // MARK: - Photo Section

    private var photoSection: some View {
        VStack(spacing: 12) {
            if let image = matchResult.photoImage {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.smTeal.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)
            }

            // Color palette
            HStack(spacing: 6) {
                ForEach(Array(matchResult.dominantColors.enumerated()), id: \.offset) { _, colorArr in
                    if colorArr.count >= 3 {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(hue: colorArr[0] / 360, saturation: colorArr[1], brightness: colorArr[2]))
                            .frame(height: 28)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Mood Section

    private var moodSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(matchResult.detectedMoodTags.prefix(6), id: \.self) { mood in
                    Text(mood)
                        .font(SMFont.label())
                        .foregroundStyle(.smTextPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.smTeal.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Recommendation Card

    private func recommendationCard(fragrance: Fragrance, rec: RecommendationEntry, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                // Rank badge
                ZStack {
                    Circle()
                        .fill(index == 0 ? Color.smGold : Color.smTeal.opacity(0.3))
                        .frame(width: 36, height: 36)
                    Text("\(index + 1)")
                        .font(SMFont.headline(16))
                        .foregroundStyle(index == 0 ? .smBackground : .smTextPrimary)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(fragrance.name)
                        .font(SMFont.headline(18))
                        .foregroundStyle(.smTextPrimary)
                    Text(fragrance.house)
                        .font(SMFont.caption())
                        .foregroundStyle(.smTextSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "%.0f%%", rec.score * 100))
                        .font(SMFont.mono(18))
                        .foregroundStyle(.smEmerald)
                    Text(fragrance.priceTier.priceRange)
                        .font(SMFont.label(10))
                        .foregroundStyle(.smTextTertiary)
                }
            }

            Text(rec.explanation)
                .font(SMFont.body(14))
                .foregroundStyle(.smTextSecondary)
                .lineLimit(2)

            HStack(spacing: 6) {
                ForEach(fragrance.accords.prefix(3), id: \.self) { accord in
                    Text(accord.rawValue)
                        .font(SMFont.label(10))
                        .foregroundStyle(.smTextPrimary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.smTeal.opacity(0.2))
                        .clipShape(Capsule())
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(.smTextTertiary)
            }
        }
        .padding(16)
        .background(Color.smSurfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(index == 0 ? Color.smGold.opacity(0.3) : Color.smTeal.opacity(0.1), lineWidth: index == 0 ? 1.5 : 0.5)
        )
        .padding(.horizontal)
    }

    // MARK: - Reveal Sequence

    private func triggerRevealSequence() {
        // Haptic for arrival
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        withAnimation(.easeOut(duration: 0.6)) {
            showContent = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeOut(duration: 0.4)) {
                showCards = true
            }

            // Stagger card reveals
            for i in 0..<min(5, recommendations.count) {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.15) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        revealedCards.insert(i)
                    }
                    // Haptic for each card
                    let light = UIImpactFeedbackGenerator(style: .light)
                    light.impactOccurred()
                }
            }
        }
    }
}
