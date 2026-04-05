import StoreKit
import SwiftUI

struct MatchDetailView: View {
    let fragrance: Fragrance
    let recommendation: RecommendationEntry
    let matchResult: ScentMatchResult
    var onDelete: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showContent = false
    @State private var showShareSheet = false
    @State private var shareImage: UIImage?
    @State private var showDeleteConfirmation = false
    @State private var heartScale: CGFloat = 1.0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Hero photo + score overlay
                    heroSection

                    VStack(spacing: 20) {
                        // Fragrance identity
                        fragranceHeader
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 16)

                        // Why it matches
                        explanationCard
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 16)

                        // Notes pyramid
                        notesPyramid
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 16)

                        // Details grid
                        detailsGrid
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 16)

                        // Affiliate links
                        affiliateSection
                            .opacity(showContent ? 1 : 0)

                        // Share + close
                        actionButtons
                            .opacity(showContent ? 1 : 0)

                        Spacer(minLength: 32)
                    }
                    .padding(.top, 20)
                }
            }
            .background(Color.smBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.smTextSecondary)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 12) {
                        Button(action: toggleFavorite) {
                            Image(systemName: matchResult.isFavorited ? "heart.fill" : "heart")
                                .foregroundStyle(matchResult.isFavorited ? Color.smEmerald : Color.smTextSecondary)
                                .scaleEffect(heartScale)
                                .symbolEffect(.bounce, value: matchResult.isFavorited)
                        }
                        .accessibilityLabel(matchResult.isFavorited ? "Remove from wardrobe" : "Save to wardrobe")
                        .accessibilityHint(matchResult.isFavorited ? "Removes this fragrance from your saved wardrobe" : "Saves this fragrance to your wardrobe")

                        if onDelete != nil {
                            Button {
                                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                                showDeleteConfirmation = true
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(Color.smError.opacity(0.8))
                            }
                            .accessibilityLabel("Delete match")
                            .accessibilityHint("Permanently deletes this fragrance match")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let image = shareImage {
                ShareSheet(items: [image])
            }
        }
        .confirmationDialog("Delete Match", isPresented: $showDeleteConfirmation) {
            Button("Delete Permanently", role: .destructive) {
                onDelete?()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete your \(fragrance.name) match. This cannot be undone.")
        }
        .preferredColorScheme(.dark)
        .onAppear {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            if reduceMotion {
                showContent = true
            } else {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                    showContent = true
                }
            }
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        ZStack(alignment: .bottom) {
            // Photo
            if let image = matchResult.photoImage {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 280)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: 0.3),
                                .init(color: Color.smBackground.opacity(0.6), location: 0.7),
                                .init(color: Color.smBackground, location: 1.0),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            } else {
                Rectangle()
                    .fill(Color.smSurface)
                    .frame(height: 280)
            }

            // Score + match info overlay
            HStack(spacing: 16) {
                VibeScoreGauge(score: matchResult.vibeScore, size: 64, lineWidth: 5)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Vibe Score")
                        .font(SMFont.label())
                        .foregroundStyle(Color.smTextSecondary)
                    Text(String(format: "%.0f%% match", recommendation.score * 100))
                        .font(SMFont.headline(20))
                        .foregroundStyle(Color.smEmerald)
                }

                Spacer()

                // Region flag
                Text(fragrance.region.flag)
                    .font(.system(size: 28))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Vibe score \(String(format: "%.0f", matchResult.vibeScore)), \(String(format: "%.0f", recommendation.score * 100)) percent match, from \(fragrance.region.displayName)")
        }
    }

    // MARK: - Fragrance Header

    private var fragranceHeader: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(fragrance.name)
                        .font(SMFont.display(26))
                        .foregroundStyle(Color.smTextPrimary)

                    Text("by \(fragrance.house)")
                        .font(SMFont.body(15))
                        .foregroundStyle(Color.smTextSecondary)
                }

                Spacer()

                FragranceBottleView(fragrance: fragrance, size: 56)
            }

            // Description
            Text(fragrance.shortDescription)
                .font(SMFont.body(14))
                .foregroundStyle(Color.smTextSecondary)
                .italic()
                .lineSpacing(3)

            // Accords
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(fragrance.accords, id: \.self) { accord in
                        Text(accord.rawValue)
                            .font(SMFont.label(11))
                            .foregroundStyle(Color.smTextPrimary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.smTeal.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(fragrance.name) by \(fragrance.house). \(fragrance.shortDescription). Accords: \(fragrance.accords.map(\.rawValue).joined(separator: ", "))")
    }

    // MARK: - Why It Matches

    private var explanationCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "wand.and.stars")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.smEmerald)
                Text("Why It Matches")
                    .font(SMFont.headline(18))
                    .foregroundStyle(Color.smTextPrimary)
            }

            Text(recommendation.explanation)
                .font(SMFont.body(15))
                .foregroundStyle(Color.smTextSecondary)
                .lineSpacing(4)

            // Matched moods
            if !recommendation.matchedMoods.isEmpty {
                HStack(spacing: 6) {
                    ForEach(recommendation.matchedMoods, id: \.self) { mood in
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.smEmerald)
                                .frame(width: 5, height: 5)
                            Text(mood)
                                .font(SMFont.label(11))
                                .foregroundStyle(Color.smTextPrimary)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.smEmerald.opacity(0.12))
                        .clipShape(Capsule())
                    }
                }
            }

            // Matched colors
            if !recommendation.matchedColors.isEmpty {
                HStack(spacing: 6) {
                    Text("Detected colors:")
                        .font(SMFont.label(10))
                        .foregroundStyle(Color.smTextTertiary)
                    ForEach(recommendation.matchedColors.prefix(5), id: \.self) { hex in
                        Circle()
                            .fill(Color(hex: hex) ?? Color.smTextTertiary)
                            .frame(width: 14, height: 14)
                            .overlay(
                                Circle().stroke(Color.smTextTertiary.opacity(0.3), lineWidth: 0.5)
                            )
                    }
                }
            }
        }
        .padding(16)
        .background(Color.smSurfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.smEmerald.opacity(0.1), lineWidth: 0.5)
        )
        .padding(.horizontal, 20)
        .accessibilityElement(children: .combine)
    }

    // MARK: - Notes Pyramid

    private var notesPyramid: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "triangle.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.smEmerald)
                Text("Fragrance Notes")
                    .font(SMFont.headline(18))
                    .foregroundStyle(Color.smTextPrimary)
            }

            // Visual pyramid layers
            VStack(spacing: 2) {
                pyramidLayer(
                    label: "TOP",
                    subtitle: "First impression · 15 min",
                    notes: fragrance.topNotes,
                    color: Color.smLightEmerald,
                    widthFraction: 0.6
                )
                pyramidLayer(
                    label: "HEART",
                    subtitle: "Core character · 2-4 hrs",
                    notes: fragrance.heartNotes,
                    color: Color.smEmerald,
                    widthFraction: 0.8
                )
                pyramidLayer(
                    label: "BASE",
                    subtitle: "Foundation · 4-8+ hrs",
                    notes: fragrance.baseNotes,
                    color: Color.smTeal,
                    widthFraction: 1.0
                )
            }
        }
        .padding(16)
        .background(Color.smSurfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.smTeal.opacity(0.1), lineWidth: 0.5)
        )
        .padding(.horizontal, 20)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Fragrance notes. Top notes: \(fragrance.topNotes.joined(separator: ", ")). Heart notes: \(fragrance.heartNotes.joined(separator: ", ")). Base notes: \(fragrance.baseNotes.joined(separator: ", "))")
    }

    private func pyramidLayer(label: String, subtitle: String, notes: [String], color: Color, widthFraction: CGFloat) -> some View {
        VStack(spacing: 6) {
            HStack(spacing: 6) {
                Text(label)
                    .font(SMFont.label(10))
                    .tracking(1.5)
                    .foregroundStyle(color)
                Text(subtitle)
                    .font(SMFont.label(9))
                    .foregroundStyle(Color.smTextTertiary)
                Spacer()
            }

            FlowLayout(spacing: 6) {
                ForEach(notes, id: \.self) { note in
                    Text(note)
                        .font(SMFont.caption(12))
                        .foregroundStyle(Color.smTextPrimary)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4)
                        .background(color.opacity(0.12))
                        .clipShape(Capsule())
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.04))
        )
    }

    // MARK: - Details Grid

    private var detailsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            detailCell(icon: "dollarsign.circle", label: "Price Range", value: fragrance.priceTier.priceRange)
            detailCell(icon: "person.fill", label: "Style", value: fragrance.gender.rawValue)
            detailCell(icon: "globe", label: "Region", value: "\(fragrance.region.flag) \(fragrance.region.displayName)")
            detailCell(icon: "calendar", label: "Season", value: fragrance.seasonality.map(\.rawValue).joined(separator: ", "))
        }
        .padding(.horizontal, 20)
    }

    private func detailCell(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(Color.smEmerald)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(SMFont.label(10))
                    .foregroundStyle(Color.smTextTertiary)
                Text(value)
                    .font(SMFont.caption(12))
                    .foregroundStyle(Color.smTextPrimary)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(12)
        .background(Color.smSurfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Affiliate

    private var affiliateSection: some View {
        VStack(spacing: 10) {
            let links = AffiliateManager.shared.allShoppingLinks(for: fragrance)
            ForEach(links) { link in
                Button(action: {
                    matchResult.affiliateLinksTapped += 1
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    EventLogger.shared.log(EventLogger.affiliateLinkTapped, metadata: [
                        "fragrance": fragrance.id,
                        "retailer": link.retailer
                    ])
                    UIApplication.shared.open(link.url)
                }) {
                    HStack {
                        Image(systemName: link.icon)
                        Text("Shop on \(link.retailer)")
                            .font(SMFont.headline(15))
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 12))
                    }
                    .foregroundStyle(link.retailer == "Amazon" ? Color.smBackground : Color.smTextPrimary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 13)
                    .background(
                        link.retailer == "Amazon"
                            ? AnyShapeStyle(LinearGradient.smGoldGradient)
                            : AnyShapeStyle(Color.smSurfaceElevated)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        link.retailer != "Amazon"
                            ? RoundedRectangle(cornerRadius: 14).stroke(Color.smTeal.opacity(0.15), lineWidth: 0.5)
                            : nil
                    )
                }
                .accessibilityLabel("Shop \(fragrance.name) on \(link.retailer)")
                .accessibilityHint("Opens \(link.retailer) in your browser")
            }

            Text("As an Amazon Associate, we earn from qualifying purchases")
                .font(SMFont.label(9))
                .foregroundStyle(Color.smTextTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: 10) {
            // Share story card
            Button(action: {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                shareStoryCard()
            }) {
                Label("Share Story Card", systemImage: "square.and.arrow.up")
                    .font(SMFont.headline(16))
                    .foregroundStyle(Color.smBackground)
                    .frame(maxWidth: .infinity)
                    .frame(height: SMTheme.buttonHeight)
                    .background(LinearGradient.smPrimaryGradient)
                    .clipShape(RoundedRectangle(cornerRadius: SMTheme.cornerRadius))
            }

            // Other matches from this scan
            allRecommendationsSection
        }
        .padding(.horizontal, 20)
    }

    // MARK: - All Recommendations

    private var allRecommendationsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            if matchResult.recommendations.count > 1 {
                Text("Other Matches")
                    .font(SMFont.headline(16))
                    .foregroundStyle(Color.smTextPrimary)
                    .padding(.top, 8)

                ForEach(matchResult.recommendations.filter { $0.id != recommendation.id }, id: \.id) { rec in
                    if let frag = rec.fragrance() {
                        HStack(spacing: 12) {
                            FragranceBottleView(fragrance: frag, size: 36)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(frag.name)
                                    .font(SMFont.headline(14))
                                    .foregroundStyle(Color.smTextPrimary)
                                    .lineLimit(1)
                                Text(frag.house)
                                    .font(SMFont.label(11))
                                    .foregroundStyle(Color.smTextSecondary)
                                    .lineLimit(1)
                            }

                            Spacer()

                            Text(String(format: "%.0f%%", rec.score * 100))
                                .font(SMFont.mono(14))
                                .foregroundStyle(Color.smEmerald)
                        }
                        .padding(10)
                        .background(Color.smSurfaceElevated)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
    }

    // MARK: - Actions

    private func toggleFavorite() {
        if !reduceMotion {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
                heartScale = 1.35
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    heartScale = 1.0
                }
            }
        }

        matchResult.isFavorited.toggle()
        if matchResult.isFavorited {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            EventLogger.shared.log(EventLogger.matchFavorited, metadata: [
                "fragrance": fragrance.id
            ])
            ReviewRequester.trackSaveAndRequestIfEligible()
            #if DEBUG
            print("[Analytics] match_favorited: \(fragrance.id)")
            #endif
        } else {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            #if DEBUG
            print("[Analytics] match_unfavorited: \(fragrance.id)")
            #endif
        }
    }

    private func shareStoryCard() {
        let topScore = recommendation.score
        if let image = ShareCardGenerator.render(
            matchResult: matchResult,
            topFragrance: fragrance,
            score: topScore
        ) {
            shareImage = image
            showShareSheet = true
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            EventLogger.shared.log(EventLogger.shareStoryCard, metadata: [
                "fragrance": fragrance.id,
                "vibe_score": String(format: "%.0f", matchResult.vibeScore)
            ])
            #if DEBUG
            print("[Analytics] share_story_card_detail: \(fragrance.id)")
            #endif
        }
    }
}

