import SwiftUI

struct FragranceCard: View {
    let fragrance: Fragrance
    let score: Double?
    var compact: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            // Bottle visualization
            FragranceBottleView(fragrance: fragrance, size: compact ? 36 : 44)

            VStack(alignment: .leading, spacing: 2) {
                Text(fragrance.name)
                    .font(SMFont.headline(compact ? 14 : 16))
                    .foregroundStyle(Color.smTextPrimary)
                    .lineLimit(1)
                Text(fragrance.house)
                    .font(SMFont.caption(compact ? 11 : 12))
                    .foregroundStyle(Color.smTextSecondary)
                    .lineLimit(1)
            }

            Spacer()

            if let score = score {
                Text(String(format: "%.0f%%", score * 100))
                    .font(SMFont.mono(compact ? 14 : 16))
                    .foregroundStyle(Color.smEmerald)
            }

            VStack(alignment: .trailing, spacing: 2) {
                Text(fragrance.priceTier.rawValue)
                    .font(SMFont.label(10))
                    .foregroundStyle(Color.smTextTertiary)
                Text(fragrance.region.flag)
                    .font(.system(size: compact ? 12 : 14))
            }
        }
        .padding(compact ? 10 : 14)
        .background(Color.smSurfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
