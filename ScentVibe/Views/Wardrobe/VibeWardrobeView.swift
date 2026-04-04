import SwiftUI
import SwiftData

struct VibeWardrobeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<ScentMatchResult> { $0.isFavorited },
           sort: \ScentMatchResult.timestamp,
           order: .reverse)
    private var savedMatches: [ScentMatchResult]

    @State private var selectedMatch: ScentMatchResult?
    @State private var showShareSheet = false
    @State private var shareImage: UIImage?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.smBackground.ignoresSafeArea()

                if savedMatches.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(savedMatches) { match in
                                WardrobeCard(match: match)
                                    .onTapGesture {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        selectedMatch = match
                                    }
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                match.isFavorited = false
                                            }
                                            #if DEBUG
                                            print("[Analytics] wardrobe_item_removed: \(match.id)")
                                            #endif
                                        } label: {
                                            Label("Remove from Wardrobe", systemImage: "heart.slash")
                                        }

                                        Button {
                                            generateShareCard(for: match)
                                        } label: {
                                            Label("Share Story Card", systemImage: "square.and.arrow.up")
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("My Vibe Wardrobe")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedMatch) { match in
                WardrobeDetailSheet(match: match)
            }
            .sheet(isPresented: $showShareSheet) {
                if let image = shareImage {
                    ShareSheet(items: [image])
                }
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.smGold.opacity(0.12), .clear],
                            center: .center, startRadius: 10, endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)

                Image(systemName: "hanger")
                    .font(.system(size: 52, weight: .thin))
                    .foregroundStyle(Color.smGold.opacity(0.6))
            }

            Text("Your Wardrobe is Empty")
                .font(SMFont.headline(22))
                .foregroundStyle(Color.smTextPrimary)

            Text("Tap the ♡ on any match result\nto save it to your scent wardrobe")
                .font(SMFont.body())
                .foregroundStyle(Color.smTextSecondary)
                .multilineTextAlignment(.center)

            HStack(spacing: 6) {
                Image(systemName: "arrow.right")
                    .font(.system(size: 12, weight: .semibold))
                Text("Go to Scan")
                    .font(SMFont.headline(15))
            }
            .foregroundStyle(Color.smEmerald)
            .padding(.top, 8)
        }
    }

    // MARK: - Share

    private func generateShareCard(for match: ScentMatchResult) {
        let topFrag = match.recommendations.first?.fragrance()
        let topScore = match.recommendations.first?.score ?? 0
        if let image = ShareCardGenerator.render(
            matchResult: match,
            topFragrance: topFrag,
            score: topScore
        ) {
            shareImage = image
            showShareSheet = true
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            #if DEBUG
            print("[Analytics] wardrobe_share_story: \(match.id)")
            #endif
        }
    }
}

// MARK: - Wardrobe Card

struct WardrobeCard: View {
    let match: ScentMatchResult

    private var topFragrance: Fragrance? {
        match.recommendations.first?.fragrance()
    }

    private var topScore: Double {
        match.recommendations.first?.score ?? 0
    }

    var body: some View {
        HStack(spacing: 14) {
            // Photo thumbnail
            Group {
                if let image = match.photoImage {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    Color.smSurface
                        .overlay {
                            Image(systemName: "photo")
                                .font(.system(size: 18))
                                .foregroundStyle(Color.smTextTertiary)
                        }
                }
            }
            .frame(width: 72, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Info
            VStack(alignment: .leading, spacing: 4) {
                if let frag = topFragrance {
                    Text(frag.name)
                        .font(SMFont.headline(16))
                        .foregroundStyle(Color.smTextPrimary)
                        .lineLimit(1)

                    Text(frag.house)
                        .font(SMFont.caption(12))
                        .foregroundStyle(Color.smTextSecondary)
                        .lineLimit(1)
                }

                HStack(spacing: 8) {
                    // Vibe score pill
                    HStack(spacing: 4) {
                        Circle()
                            .fill(vibeColor)
                            .frame(width: 6, height: 6)
                        Text(String(format: "%.0f", match.vibeScore))
                            .font(SMFont.mono(12))
                            .foregroundStyle(vibeColor)
                    }

                    Text("·")
                        .foregroundStyle(Color.smTextTertiary)

                    Text(match.timestamp, style: .date)
                        .font(SMFont.label(10))
                        .foregroundStyle(Color.smTextTertiary)
                }
            }

            Spacer()

            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.smTextTertiary)
        }
        .padding(12)
        .background(Color.smSurfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.smTeal.opacity(0.1), lineWidth: 0.5)
        )
    }

    private var vibeColor: Color {
        switch match.vibeScore {
        case 80...: return .smEmerald
        case 60..<80: return .smLightTeal
        case 40..<60: return .smGold
        default: return .smTextSecondary
        }
    }
}

// MARK: - Wardrobe Detail Sheet

struct WardrobeDetailSheet: View {
    let match: ScentMatchResult
    @Environment(\.dismiss) private var dismiss

    var body: some View {
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
