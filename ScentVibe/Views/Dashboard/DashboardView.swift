import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \ScentMatchResult.timestamp, order: .reverse) private var matches: [ScentMatchResult]
    @State private var selectedMatch: ScentMatchResult?

    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.smBackground.ignoresSafeArea()

                if matches.isEmpty {
                    DashboardEmptyState()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(matches) { match in
                                MatchCardView(match: match)
                                    .accessibilityHint("Tap to view match details")
                                    .onTapGesture {
                                        selectedMatch = match
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Your Matches")
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

// MARK: - Premium Dashboard Empty State

private struct DashboardEmptyState: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showContent = false
    @State private var orbPulse = false
    @State private var sparkleRotation: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Animated icon cluster
            ZStack {
                // Outer aura
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.smEmerald.opacity(orbPulse ? 0.12 : 0.06),
                                Color.smTeal.opacity(0.04),
                                .clear
                            ],
                            center: .center, startRadius: 15, endRadius: 95
                        )
                    )
                    .frame(width: 190, height: 190)

                // Orbiting dots
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(Color.smEmerald.opacity(0.3 - Double(i) * 0.08))
                        .frame(width: 5 - CGFloat(i), height: 5 - CGFloat(i))
                        .offset(x: CGFloat(50 + i * 12))
                        .rotationEffect(.degrees(sparkleRotation + Double(i) * 120))
                }

                // Inner ring
                Circle()
                    .stroke(Color.smEmerald.opacity(0.1), lineWidth: 1)
                    .frame(width: 120, height: 120)
                    .scaleEffect(orbPulse ? 1.06 : 0.96)

                // Main icon
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

            Text("Snap a photo of your outfit, room, or mood\nand our AI will match your perfect fragrance.")
                .font(SMFont.body(15))
                .foregroundStyle(Color.smTextSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 12)

            Spacer().frame(height: 32)

            // Feature highlights
            VStack(spacing: 14) {
                featureRow(icon: "camera.fill", text: "Scan any photo for a scent match")
                featureRow(icon: "brain.head.profile.fill", text: "AI analyzes colors, mood & texture")
                featureRow(icon: "heart.fill", text: "Save favorites to your wardrobe")
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 16)

            Spacer()

            // Hint
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
            withAnimation(.easeOut(duration: 0.7)) {
                showContent = true
            }
            guard !reduceMotion else { return }
            withAnimation(
                .easeInOut(duration: 2.8)
                .repeatForever(autoreverses: true)
            ) {
                orbPulse = true
            }
            withAnimation(
                .linear(duration: 12)
                .repeatForever(autoreverses: false)
            ) {
                sparkleRotation = 360
            }
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
