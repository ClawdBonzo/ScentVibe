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
    @State private var showShareSheet = false
    @State private var shareImage: UIImage?
    @State private var showMoodPicker = false
    @State private var isSaved = false

    var onRegenerate: (() -> Void)?
    var onRegenerateWithMood: ((String) -> Void)?

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
                            .foregroundStyle(Color.smTextPrimary)
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

                        // MARK: - Action Buttons

                        actionButtons
                            .opacity(showCards ? 1 : 0)

                        Spacer(minLength: 32)
                    }
                }
            }
            .navigationTitle("Your Match")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.smTextSecondary)
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
            .sheet(isPresented: $showMoodPicker) {
                MoodPickerSheet { selectedMood in
                    showMoodPicker = false
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    EventLogger.shared.log(EventLogger.regenerateWithMood, metadata: [
                        "mood": selectedMood
                    ])
                    print("[Analytics] regenerate_with_mood: \(selectedMood)")
                    dismiss()
                    onRegenerateWithMood?(selectedMood)
                }
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let image = shareImage {
                ShareSheet(items: [image])
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            isSaved = matchResult.isFavorited
            triggerRevealSequence()
        }
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: 12) {
            // Save to Wardrobe
            Button(action: saveToWardrobe) {
                HStack(spacing: 8) {
                    Image(systemName: isSaved ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .semibold))
                    Text(isSaved ? "Saved to Wardrobe" : "Save to My Wardrobe")
                        .font(SMFont.headline(16))
                }
                .foregroundStyle(isSaved ? Color.smBackground : Color.smEmerald)
                .frame(maxWidth: .infinity)
                .frame(height: SMTheme.buttonHeight)
                .background(isSaved ? Color.smEmerald : Color.smEmerald.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: SMTheme.cornerRadius))
                .overlay(
                    isSaved ? nil :
                    RoundedRectangle(cornerRadius: SMTheme.cornerRadius)
                        .stroke(Color.smEmerald.opacity(0.3), lineWidth: 1)
                )
            }
            .padding(.horizontal)

            // Share to Stories
            Button(action: generateShareCard) {
                Label("Share to Stories", systemImage: "square.and.arrow.up")
                    .font(SMFont.headline(16))
                    .foregroundStyle(Color.smBackground)
                    .frame(maxWidth: .infinity)
                    .frame(height: SMTheme.buttonHeight)
                    .background(LinearGradient.smGoldGradient)
                    .clipShape(RoundedRectangle(cornerRadius: SMTheme.cornerRadius))
            }
            .padding(.horizontal)

            // Regenerate + Try Different Mood row
            HStack(spacing: 10) {
                // Regenerate Match
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    EventLogger.shared.log(EventLogger.regenerateMatch, metadata: [
                        "type": "same_photo"
                    ])
                    print("[Analytics] regenerate_match: same_photo")
                    dismiss()
                    onRegenerate?()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Regenerate")
                            .font(SMFont.headline(14))
                    }
                    .foregroundStyle(Color.smTextPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(Color.smSurfaceElevated)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.smTeal.opacity(0.2), lineWidth: 0.5)
                    )
                }

                // Try Different Mood
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    showMoodPicker = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "theatermasks")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Try Mood")
                            .font(SMFont.headline(14))
                    }
                    .foregroundStyle(Color.smGold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(Color.smGold.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.smGold.opacity(0.25), lineWidth: 0.5)
                    )
                }
            }
            .padding(.horizontal)

            // Done
            Button(action: { dismiss() }) {
                Text("Done")
                    .font(SMFont.headline(17))
                    .foregroundStyle(Color.smTextSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
            }
            .padding(.horizontal)
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
                        .foregroundStyle(Color.smTextPrimary)
                    Text("Vibe Score")
                        .font(SMFont.label())
                        .foregroundStyle(Color.smTextSecondary)
                }
            }

            Text(vibeDescription)
                .font(SMFont.body())
                .foregroundStyle(Color.smEmerald)
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
                        .foregroundStyle(Color.smTextPrimary)
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
                // Bottle + rank
                ZStack(alignment: .bottomTrailing) {
                    FragranceBottleView(fragrance: fragrance, size: 44)
                    // Rank badge
                    Text("\(index + 1)")
                        .font(SMFont.label(10))
                        .foregroundStyle(index == 0 ? Color.smBackground : Color.smTextPrimary)
                        .frame(width: 18, height: 18)
                        .background(index == 0 ? Color.smGold : Color.smTeal.opacity(0.5))
                        .clipShape(Circle())
                        .offset(x: 4, y: 4)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(fragrance.name)
                        .font(SMFont.headline(18))
                        .foregroundStyle(Color.smTextPrimary)
                    Text(fragrance.house)
                        .font(SMFont.caption())
                        .foregroundStyle(Color.smTextSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "%.0f%%", rec.score * 100))
                        .font(SMFont.mono(18))
                        .foregroundStyle(Color.smEmerald)
                    Text(fragrance.priceTier.priceRange)
                        .font(SMFont.label(10))
                        .foregroundStyle(Color.smTextTertiary)
                }
            }

            Text(rec.explanation)
                .font(SMFont.body(14))
                .foregroundStyle(Color.smTextSecondary)
                .lineLimit(2)

            HStack(spacing: 6) {
                ForEach(fragrance.accords.prefix(3), id: \.self) { accord in
                    Text(accord.rawValue)
                        .font(SMFont.label(10))
                        .foregroundStyle(Color.smTextPrimary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.smTeal.opacity(0.2))
                        .clipShape(Capsule())
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.smTextTertiary)
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

    // MARK: - Actions

    private func saveToWardrobe() {
        isSaved.toggle()
        matchResult.isFavorited = isSaved

        if isSaved {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            EventLogger.shared.log(EventLogger.savedToWardrobe, metadata: [
                "fragrance": matchResult.recommendations.first?.id ?? "unknown",
                "vibe_score": String(format: "%.0f", matchResult.vibeScore)
            ])
            WidgetDataBridge.shared.update(with: matchResult)
            print("[Analytics] save_to_wardrobe: \(matchResult.id)")
        } else {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            print("[Analytics] remove_from_wardrobe: \(matchResult.id)")
        }
    }

    private func generateShareCard() {
        let topFrag = recommendations.first?.fragrance()
        let topScore = recommendations.first?.score ?? 0
        if let image = ShareCardGenerator.render(matchResult: matchResult, topFragrance: topFrag, score: topScore) {
            shareImage = image
            showShareSheet = true
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            EventLogger.shared.log(EventLogger.shareStoryCard, metadata: [
                "fragrance": topFrag?.id ?? "unknown",
                "vibe_score": String(format: "%.0f", matchResult.vibeScore)
            ])
            print("[Analytics] share_story_card: \(matchResult.id)")
        }
    }

    // MARK: - Reveal Sequence

    private func triggerRevealSequence() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        withAnimation(.easeOut(duration: 0.6)) {
            showContent = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeOut(duration: 0.4)) {
                showCards = true
            }

            for i in 0..<min(5, recommendations.count) {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.15) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        revealedCards.insert(i)
                    }
                    let light = UIImpactFeedbackGenerator(style: .light)
                    light.impactOccurred()
                }
            }
        }
    }
}

// MARK: - Mood Picker Sheet

struct MoodPickerSheet: View {
    let onSelect: (String) -> Void

    private let moods: [(name: String, icon: String)] = [
        ("Bold & Confident", "flame.fill"),
        ("Elegant & Refined", "crown.fill"),
        ("Fresh & Energetic", "leaf.fill"),
        ("Romantic & Sensual", "heart.fill"),
        ("Mysterious & Dark", "moon.stars.fill"),
        ("Cozy & Warm", "cup.and.saucer.fill"),
        ("Minimal & Clean", "wind"),
        ("Adventurous", "mountain.2.fill"),
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.smBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 10) {
                        Text("What's your mood?")
                            .font(SMFont.display(24))
                            .foregroundStyle(Color.smTextPrimary)
                            .padding(.top, 8)

                        Text("We'll regenerate your match\nwith this vibe in mind")
                            .font(SMFont.body(14))
                            .foregroundStyle(Color.smTextSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 8)

                        ForEach(moods, id: \.name) { mood in
                            Button {
                                onSelect(mood.name)
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: mood.icon)
                                        .font(.system(size: 18))
                                        .foregroundStyle(Color.smEmerald)
                                        .frame(width: 32)

                                    Text(mood.name)
                                        .font(SMFont.headline(16))
                                        .foregroundStyle(Color.smTextPrimary)

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(Color.smTextTertiary)
                                }
                                .padding(14)
                                .background(Color.smSurfaceElevated)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
