import SwiftUI

/// Generates a beautiful shareable story card from match results.
/// Photo + vibe score badge + top fragrance + watermark.
struct ShareCardView: View {
    let matchResult: ScentMatchResult
    let topFragrance: Fragrance?
    let score: Double

    var body: some View {
        ZStack {
            // Background
            Color.smBackground

            VStack(spacing: 0) {
                // Photo section (top 60%)
                ZStack(alignment: .bottomLeading) {
                    if let image = matchResult.photoImage {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 520)
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    colors: [.clear, .clear, Color.smBackground.opacity(0.8), Color.smBackground],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    } else {
                        Color.smSurface
                            .frame(height: 520)
                    }

                    // Vibe score badge (bottom-left of photo)
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .stroke(Color.smEmerald.opacity(0.3), lineWidth: 3)
                                .frame(width: 56, height: 56)
                            Circle()
                                .trim(from: 0, to: matchResult.vibeScore / 100.0)
                                .stroke(Color.smEmerald, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                .frame(width: 56, height: 56)
                                .rotationEffect(.degrees(-90))
                            Text(String(format: "%.0f", matchResult.vibeScore))
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundStyle(Color.smTextPrimary)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("VIBE SCORE")
                                .font(.system(size: 9, weight: .bold, design: .default))
                                .foregroundStyle(Color.smEmerald)
                                .tracking(1.5)
                            Text(vibeLabel)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.smTextPrimary)
                        }
                    }
                    .padding(16)
                }
                .frame(height: 520)

                // Fragrance recommendation
                VStack(spacing: 12) {
                    if let frag = topFragrance {
                        Text("Your Scent Match")
                            .font(.system(size: 11, weight: .semibold, design: .default))
                            .foregroundStyle(Color.smEmerald)
                            .tracking(1.2)
                            .textCase(.uppercase)

                        Text(frag.name)
                            .font(.system(size: 26, weight: .bold, design: .serif))
                            .foregroundStyle(Color.smTextPrimary)

                        Text("by \(frag.house)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.smTextSecondary)

                        Text(String(format: "%.0f%% match", score * 100))
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundStyle(Color.smEmerald)

                        // Mood tags
                        HStack(spacing: 6) {
                            ForEach(matchResult.detectedMoodTags.prefix(3), id: \.self) { mood in
                                Text(mood)
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundStyle(Color.smTextPrimary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Color.smEmerald.opacity(0.15))
                                    .clipShape(Capsule())
                            }
                        }
                    }

                    Spacer()

                    // Watermark
                    HStack(spacing: 4) {
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 10))
                        Text("ScentVibe AI")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundStyle(Color.smTextTertiary)
                    .padding(.bottom, 16)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .frame(width: 390, height: 844)  // iPhone story aspect ratio
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var vibeLabel: String {
        switch matchResult.vibeScore {
        case 80...: return "Exceptional"
        case 60..<80: return "Strong Match"
        case 40..<60: return "Good Match"
        default: return "Interesting"
        }
    }
}

// MARK: - Share Card Generator

struct ShareCardGenerator {
    @MainActor
    static func render(matchResult: ScentMatchResult, topFragrance: Fragrance?, score: Double) -> UIImage? {
        let view = ShareCardView(matchResult: matchResult, topFragrance: topFragrance, score: score)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 2.0  // Retina
        return renderer.uiImage
    }
}
