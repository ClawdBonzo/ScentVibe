import SwiftUI
import SwiftData

struct VibeWardrobeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<ScentMatchResult> { $0.isFavorited },
           sort: \ScentMatchResult.timestamp,
           order: .reverse)
    private var savedMatches: [ScentMatchResult]

    @Binding var selectedTab: Int
    @State private var selectedMatch: ScentMatchResult?
    @State private var matchToDelete: ScentMatchResult?
    @State private var showDeleteConfirmation = false
    @State private var showShareSheet = false
    @State private var shareImage: UIImage?

    // Undo toast state
    @State private var undoMatch: ScentMatchResult?
    @State private var undoFragranceName: String = ""
    @State private var showUndoToast = false
    @State private var undoWorkItem: DispatchWorkItem?
    @State private var pendingPermanentDelete = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.smBackground.ignoresSafeArea()

                if savedMatches.isEmpty && undoMatch == nil {
                    WardrobeEmptyState(selectedTab: $selectedTab)
                } else {
                    List {
                        ForEach(savedMatches) { match in
                            WardrobeCard(match: match)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                                .onTapGesture {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    selectedMatch = match
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        softDeleteMatch(match, permanent: true)
                                    } label: {
                                        Label("Delete", systemImage: "trash.fill")
                                    }
                                    .tint(Color.smError)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button {
                                        softDeleteMatch(match, permanent: false)
                                    } label: {
                                        Label("Remove", systemImage: "heart.slash.fill")
                                    }
                                    .tint(Color.smGold)
                                }
                                .contextMenu {
                                    Button {
                                        generateShareCard(for: match)
                                    } label: {
                                        Label("Share Story Card", systemImage: "square.and.arrow.up")
                                    }

                                    Divider()

                                    Button(role: .destructive) {
                                        softDeleteMatch(match, permanent: false)
                                    } label: {
                                        Label("Remove from Wardrobe", systemImage: "heart.slash")
                                    }

                                    Button(role: .destructive) {
                                        matchToDelete = match
                                        showDeleteConfirmation = true
                                    } label: {
                                        Label("Delete Permanently", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }

                // Undo toast overlay
                if showUndoToast {
                    VStack {
                        Spacer()
                        UndoToastView(
                            fragranceName: undoFragranceName,
                            isPermanent: pendingPermanentDelete,
                            onUndo: undoDelete
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 16)
                    }
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showUndoToast)
                    .zIndex(100)
                }
            }
            .navigationTitle("My Vibe Wardrobe")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedMatch) { match in
                WardrobeDetailSheet(match: match, onDelete: { deletedMatch in
                    selectedMatch = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        softDeleteMatch(deletedMatch, permanent: true)
                    }
                })
            }
            .sheet(isPresented: $showShareSheet) {
                if let image = shareImage {
                    ShareSheet(items: [image])
                }
            }
            .confirmationDialog(
                "Delete Permanently",
                isPresented: $showDeleteConfirmation,
                presenting: matchToDelete
            ) { match in
                Button("Delete Permanently", role: .destructive) {
                    hardDeleteMatch(match)
                }
                Button("Cancel", role: .cancel) {
                    matchToDelete = nil
                }
            } message: { match in
                let fragName = match.recommendations.first?.fragrance()?.name ?? "this match"
                Text("This will permanently delete your \(fragName) match. This cannot be undone.")
            }
        }
    }

    // MARK: - Soft Delete with Undo

    private func softDeleteMatch(_ match: ScentMatchResult, permanent: Bool) {
        // Cancel any previous undo timer
        undoWorkItem?.cancel()

        // Capture name before hiding
        undoFragranceName = match.recommendations.first?.fragrance()?.name ?? "Match"
        pendingPermanentDelete = permanent

        // Soft-delete: unfavorite (hides from wardrobe query)
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            match.isFavorited = false
            undoMatch = match
            showUndoToast = true
        }

        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        EventLogger.shared.log(EventLogger.matchDeleted, metadata: [
            "action": permanent ? "pending_delete" : "unfavorited",
            "match": match.id.uuidString
        ])

        #if DEBUG
        print("[Analytics] wardrobe_item_soft_deleted: \(match.id)")
        #endif

        // Schedule finalization after 4 seconds
        let workItem = DispatchWorkItem { [self] in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                showUndoToast = false
            }
            if permanent, let m = undoMatch {
                WidgetDataBridge.shared.clear()
                modelContext.delete(m)
                #if DEBUG
                print("[Analytics] match_deleted_permanently: \(m.id)")
                #endif
            }
            undoMatch = nil
        }
        undoWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: workItem)
    }

    private func undoDelete() {
        undoWorkItem?.cancel()
        UINotificationFeedbackGenerator().notificationOccurred(.success)

        if let match = undoMatch {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                match.isFavorited = true
                showUndoToast = false
            }
            #if DEBUG
            print("[Analytics] wardrobe_undo_delete: \(match.id)")
            #endif
        }
        undoMatch = nil
    }

    private func hardDeleteMatch(_ match: ScentMatchResult) {
        withAnimation(.easeInOut(duration: 0.3)) {
            EventLogger.shared.log(EventLogger.matchDeleted, metadata: [
                "fragrance": match.recommendations.first?.id ?? "unknown",
                "vibe_score": String(format: "%.0f", match.vibeScore)
            ])
            WidgetDataBridge.shared.clear()
            modelContext.delete(match)
        }
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
        matchToDelete = nil
    }

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

// MARK: - Undo Toast

private struct UndoToastView: View {
    let fragranceName: String
    let isPermanent: Bool
    let onUndo: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var progress: CGFloat = 1.0
    @State private var iconScale: CGFloat = 0.5
    @State private var toastOpacity: Double = 0

    private static let undoDuration: Double = 4.0

    var body: some View {
        HStack(spacing: 14) {
            // Progress ring with icon
            ZStack {
                Circle()
                    .stroke(Color.smGold.opacity(0.15), lineWidth: 2.5)
                    .frame(width: 34, height: 34)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.smGold, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                    .frame(width: 34, height: 34)
                    .rotationEffect(.degrees(-90))

                Image(systemName: isPermanent ? "trash" : "heart.slash")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.smGold)
                    .scaleEffect(iconScale)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(isPermanent ? "Match deleted" : "Removed from wardrobe")
                    .font(SMFont.headline(14))
                    .foregroundStyle(Color.smTextPrimary)
                Text(fragranceName)
                    .font(SMFont.caption(12))
                    .foregroundStyle(Color.smTextSecondary)
                    .lineLimit(1)
            }

            Spacer()

            Button {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                onUndo()
            } label: {
                Text("Undo")
                    .font(SMFont.headline(14))
                    .foregroundStyle(Color.smEmerald)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.smEmerald.opacity(0.12))
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .background(Color.smSurfaceElevated.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.3), radius: 16, y: 6)
        .padding(.horizontal, 20)
        .opacity(toastOpacity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(isPermanent ? "Match deleted" : "Removed from wardrobe"): \(fragranceName)")
        .accessibilityHint("Tap Undo to restore")
        .accessibilityAction(named: "Undo") { onUndo() }
        .onAppear {
            if reduceMotion {
                toastOpacity = 1
                iconScale = 1.0
                progress = 0
            } else {
                // Entrance: fade + icon spring
                withAnimation(.easeOut(duration: 0.25)) {
                    toastOpacity = 1
                }
                withAnimation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.1)) {
                    iconScale = 1.0
                }
                // Countdown ring
                withAnimation(.linear(duration: Self.undoDuration)) {
                    progress = 0
                }
            }
        }
    }
}

// MARK: - Premium Wardrobe Empty State

private struct WardrobeEmptyState: View {
    @Binding var selectedTab: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showContent = false
    @State private var pulseHanger = false
    @State private var glowIntensity: CGFloat = 0.08

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.smGold.opacity(glowIntensity),
                                Color.smGold.opacity(glowIntensity * 0.4),
                                .clear
                            ],
                            center: .center, startRadius: 20, endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)

                Circle()
                    .stroke(Color.smGold.opacity(0.08), lineWidth: 1)
                    .frame(width: 140, height: 140)
                    .scaleEffect(pulseHanger ? 1.08 : 0.95)

                Image(systemName: "hanger")
                    .font(.system(size: 56, weight: .thin))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.smGold.opacity(0.7), Color.smGold.opacity(0.4)],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .scaleEffect(pulseHanger ? 1.06 : 0.96)
                    .rotationEffect(.degrees(pulseHanger ? 2 : -2))

                Image(systemName: "sparkle")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(Color.smGold.opacity(pulseHanger ? 0.5 : 0.15))
                    .offset(x: 55, y: -40)
                    .scaleEffect(pulseHanger ? 1.2 : 0.6)

                Image(systemName: "sparkle")
                    .font(.system(size: 7, weight: .medium))
                    .foregroundStyle(Color.smEmerald.opacity(pulseHanger ? 0.4 : 0.1))
                    .offset(x: -50, y: -30)
                    .scaleEffect(pulseHanger ? 0.8 : 1.3)
            }
            .opacity(showContent ? 1 : 0)
            .scaleEffect(showContent ? 1 : 0.8)
            .accessibilityHidden(true)

            Spacer().frame(height: 28)

            Text("Your Wardrobe Awaits")
                .font(SMFont.headline(24))
                .foregroundStyle(Color.smTextPrimary)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 12)
                .accessibilityAddTraits(.isHeader)

            Spacer().frame(height: 12)

            Text("Save your favorite scent matches here.\nTap the heart on any result to start curating.")
                .font(SMFont.body(15))
                .foregroundStyle(Color.smTextSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 12)

            Spacer().frame(height: 36)

            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    selectedTab = 1
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 15, weight: .semibold))
                    Text("Scan Your First Look")
                        .font(SMFont.headline(16))
                }
                .foregroundStyle(Color.smBackground)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(LinearGradient.smPrimaryGradient)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: Color.smEmerald.opacity(0.2), radius: 12, y: 4)
            }
            .padding(.horizontal, 40)
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 16)
            .accessibilityLabel("Scan your first look")
            .accessibilityHint("Opens the camera scan tab to take a photo for scent matching")

            Spacer().frame(height: 14)

            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    selectedTab = 0
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "square.grid.2x2")
                        .font(.system(size: 12, weight: .medium))
                    Text("Browse Your Matches")
                        .font(SMFont.label(14))
                }
                .foregroundStyle(Color.smTextSecondary)
            }
            .opacity(showContent ? 1 : 0)
            .accessibilityLabel("Browse your matches")
            .accessibilityHint("Switches to the Matches tab to view past scent results")

            Spacer()

            HStack(spacing: 6) {
                Image(systemName: "heart")
                    .font(.system(size: 10))
                Text("Tip: Long-press any match to save it instantly")
                    .font(SMFont.label(11))
            }
            .foregroundStyle(Color.smTextTertiary.opacity(0.6))
            .opacity(showContent ? 1 : 0)
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 24)
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) {
                showContent = true
            }
            guard !reduceMotion else {
                pulseHanger = false
                glowIntensity = 0.08
                return
            }
            withAnimation(
                .easeInOut(duration: 2.8)
                .repeatForever(autoreverses: true)
            ) {
                pulseHanger = true
            }
            withAnimation(
                .easeInOut(duration: 3.2)
                .repeatForever(autoreverses: true)
            ) {
                glowIntensity = 0.18
            }
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel(cardAccessibilityLabel)
        .accessibilityHint("Tap to view details. Swipe left for delete options.")
    }

    private var cardAccessibilityLabel: String {
        let name = topFragrance?.name ?? "Unknown fragrance"
        let house = topFragrance?.house ?? ""
        let score = String(format: "%.0f", match.vibeScore)
        return "\(name) by \(house), vibe score \(score)"
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
    var onDelete: ((ScentMatchResult) -> Void)?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        if let firstRec = match.recommendations.first,
           let fragrance = firstRec.fragrance() {
            MatchDetailView(
                fragrance: fragrance,
                recommendation: firstRec,
                matchResult: match,
                onDelete: {
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        onDelete?(match)
                    }
                }
            )
        }
    }
}
