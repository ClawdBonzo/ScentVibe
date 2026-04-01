import SwiftUI

struct MatchCardView: View {
    let match: ScentMatchResult

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Photo thumbnail
            ZStack(alignment: .topTrailing) {
                if let image = match.photoImage {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.smSurface)
                        .frame(height: 120)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.system(size: 24))
                                .foregroundStyle(Color.smTextTertiary)
                        }
                }

                // Vibe score badge
                Text(String(format: "%.0f", match.vibeScore))
                    .font(SMFont.mono(14))
                    .foregroundStyle(Color.smBackground)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(vibeColor)
                    .clipShape(Capsule())
                    .padding(8)
            }

            // Top recommendation
            if let topRec = match.topRecommendation,
               let fragrance = topRec.fragrance() {
                VStack(alignment: .leading, spacing: 2) {
                    Text(fragrance.name)
                        .font(SMFont.headline(14))
                        .foregroundStyle(Color.smTextPrimary)
                        .lineLimit(1)
                    Text(fragrance.house)
                        .font(SMFont.label(11))
                        .foregroundStyle(Color.smTextSecondary)
                        .lineLimit(1)
                }
            }

            // Color bar + date
            HStack(spacing: 0) {
                ForEach(Array(match.dominantColors.prefix(4).enumerated()), id: \.offset) { _, colorArr in
                    if colorArr.count >= 3 {
                        Rectangle()
                            .fill(Color(hue: colorArr[0] / 360, saturation: colorArr[1], brightness: colorArr[2]))
                            .frame(height: 4)
                    }
                }
            }
            .clipShape(Capsule())

            Text(match.timestamp, style: .relative)
                .font(SMFont.label(10))
                .foregroundStyle(Color.smTextTertiary)
        }
        .padding(10)
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
        case 60..<80: return .smTeal
        case 40..<60: return .smGold
        default: return .smTextTertiary
        }
    }
}
