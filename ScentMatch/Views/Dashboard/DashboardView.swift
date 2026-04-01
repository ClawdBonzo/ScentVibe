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
                    emptyState
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(matches) { match in
                                MatchCardView(match: match)
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

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.smEmerald.opacity(0.5))

            Text("No Matches Yet")
                .font(SMFont.headline(20))
                .foregroundStyle(.smTextPrimary)

            Text("Scan your first outfit or room\nto discover your scent match")
                .font(SMFont.body())
                .foregroundStyle(.smTextSecondary)
                .multilineTextAlignment(.center)
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
