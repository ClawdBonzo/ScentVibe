import SwiftUI

struct MatchDetailView: View {
    let fragrance: Fragrance
    let recommendation: RecommendationEntry
    let matchResult: ScentMatchResult

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Hero
                    heroSection

                    // Match explanation
                    explanationSection

                    // Fragrance details
                    fragranceDetailsSection

                    // Notes pyramid
                    notesPyramid

                    // Affiliate CTA — all fragrances get links via search fallback
                    affiliateSection

                    // All recommendations
                    allRecommendationsSection
                }
                .padding(.bottom, 32)
            }
            .background(Color.smBackground)
            .navigationTitle(fragrance.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.smTextSecondary)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: toggleFavorite) {
                        Image(systemName: matchResult.isFavorited ? "heart.fill" : "heart")
                            .foregroundStyle(matchResult.isFavorited ? Color.smEmerald : Color.smTextSecondary)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Hero

    private var heroSection: some View {
        ZStack(alignment: .bottom) {
            if let image = matchResult.photoImage {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            colors: [.clear, .smBackground],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                    )
            }

            VStack(spacing: 8) {
                // Vibe score
                HStack(spacing: 8) {
                    VibeScoreGauge(score: matchResult.vibeScore, size: 56)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Vibe Score")
                            .font(SMFont.label())
                            .foregroundStyle(Color.smTextSecondary)
                        Text(String(format: "%.0f%% match", recommendation.score * 100))
                            .font(SMFont.headline(18))
                            .foregroundStyle(Color.smEmerald)
                    }
                    Spacer()
                    // Region flag
                    Text("\(fragrance.region.flag)")
                        .font(.title)
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Explanation

    private var explanationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "wand.and.stars")
                    .foregroundStyle(Color.smEmerald)
                Text("Why It Matches")
                    .font(SMFont.headline(18))
                    .foregroundStyle(Color.smTextPrimary)
            }

            Text(recommendation.explanation)
                .font(SMFont.body())
                .foregroundStyle(Color.smTextSecondary)
                .lineSpacing(4)

            // Matched moods
            if !recommendation.matchedMoods.isEmpty {
                HStack(spacing: 6) {
                    ForEach(recommendation.matchedMoods, id: \.self) { mood in
                        Text(mood)
                            .font(SMFont.label())
                            .foregroundStyle(Color.smTextPrimary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.smEmerald.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding()
        .background(Color.smSurfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    // MARK: - Fragrance Details

    private var fragranceDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(fragrance.name)
                        .font(SMFont.display(24))
                        .foregroundStyle(Color.smTextPrimary)
                    Text("by \(fragrance.house)")
                        .font(SMFont.body())
                        .foregroundStyle(Color.smTextSecondary)
                }
                Spacer()
                FragranceBottleView(fragrance: fragrance, size: 56)
            }

            Text(fragrance.shortDescription)
                .font(SMFont.body())
                .foregroundStyle(Color.smTextSecondary)
                .italic()

            // Accords
            HStack(spacing: 6) {
                ForEach(fragrance.accords, id: \.self) { accord in
                    Text(accord.rawValue)
                        .font(SMFont.label())
                        .foregroundStyle(Color.smTextPrimary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.smTeal.opacity(0.2))
                        .clipShape(Capsule())
                }
            }

            // Metadata row
            HStack(spacing: 16) {
                metadataItem(icon: "dollarsign.circle", text: fragrance.priceTier.priceRange)
                metadataItem(icon: "person.fill", text: fragrance.gender.rawValue)
                metadataItem(icon: "calendar", text: fragrance.seasonality.map(\.rawValue).joined(separator: ", "))
            }
        }
        .padding()
        .background(Color.smSurfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    // MARK: - Notes Pyramid

    private var notesPyramid: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 6) {
                Image(systemName: "triangle.fill")
                    .foregroundStyle(Color.smEmerald)
                    .font(.system(size: 14))
                Text("Fragrance Notes")
                    .font(SMFont.headline(18))
                    .foregroundStyle(Color.smTextPrimary)
            }

            notesRow("Top", notes: fragrance.topNotes, color: .smLightEmerald)
            notesRow("Heart", notes: fragrance.heartNotes, color: Color.smEmerald)
            notesRow("Base", notes: fragrance.baseNotes, color: .smTeal)
        }
        .padding()
        .background(Color.smSurfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private func notesRow(_ label: String, notes: [String], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label.uppercased())
                .font(SMFont.label(10))
                .foregroundStyle(color)
            FlowLayout(spacing: 6) {
                ForEach(notes, id: \.self) { note in
                    Text(note)
                        .font(SMFont.caption(12))
                        .foregroundStyle(Color.smTextPrimary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(color.opacity(0.12))
                        .clipShape(Capsule())
                }
            }
        }
    }

    // MARK: - Affiliate

    private var affiliateSection: some View {
        VStack(spacing: 12) {
            Button(action: openAffiliateLink) {
                HStack {
                    Image(systemName: "cart.fill")
                    Text("Shop on Amazon")
                        .font(SMFont.headline(16))
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 14))
                }
                .foregroundStyle(Color.smBackground)
                .padding()
                .background(LinearGradient.smGoldGradient)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            Text("As an Amazon Associate, we earn from qualifying purchases")
                .font(SMFont.label(9))
                .foregroundStyle(Color.smTextTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }

    // MARK: - All Recommendations

    private var allRecommendationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Other Matches")
                .font(SMFont.headline(18))
                .foregroundStyle(Color.smTextPrimary)
                .padding(.horizontal)

            ForEach(matchResult.recommendations.dropFirst(), id: \.id) { rec in
                if let frag = rec.fragrance() {
                    HStack(spacing: 12) {
                        FragranceBottleView(fragrance: frag, size: 36)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(frag.name)
                                .font(SMFont.headline(14))
                                .foregroundStyle(Color.smTextPrimary)
                            Text(frag.house)
                                .font(SMFont.label(11))
                                .foregroundStyle(Color.smTextSecondary)
                        }

                        Spacer()

                        Text(String(format: "%.0f%%", rec.score * 100))
                            .font(SMFont.mono(14))
                            .foregroundStyle(Color.smEmerald)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }

    // MARK: - Helpers

    private func metadataItem(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(Color.smEmerald)
            Text(text)
                .font(SMFont.label(11))
                .foregroundStyle(Color.smTextSecondary)
        }
    }

    private func toggleFavorite() {
        matchResult.isFavorited.toggle()
        if matchResult.isFavorited {
            EventLogger.shared.log(EventLogger.matchFavorited, metadata: [
                "fragrance": fragrance.id
            ])
        }
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }

    private func openAffiliateLink() {
        guard let url = fragrance.affiliateURL else { return }
        matchResult.affiliateLinksTapped += 1
        EventLogger.shared.log(EventLogger.affiliateLinkTapped, metadata: [
            "fragrance": fragrance.id,
            "asin": fragrance.amazonASIN ?? ""
        ])
        UIApplication.shared.open(url)
    }
}
