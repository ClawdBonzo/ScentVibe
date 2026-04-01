import SwiftUI

struct FragranceCard: View {
    let fragrance: Fragrance
    let score: Double?
    var compact: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: fragrance.iconName)
                .font(.system(size: compact ? 18 : 22))
                .foregroundStyle(.smEmerald)
                .frame(width: compact ? 36 : 44, height: compact ? 36 : 44)
                .background(Color.smEmerald.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(fragrance.name)
                    .font(SMFont.headline(compact ? 14 : 16))
                    .foregroundStyle(.smTextPrimary)
                    .lineLimit(1)
                Text(fragrance.house)
                    .font(SMFont.caption(compact ? 11 : 12))
                    .foregroundStyle(.smTextSecondary)
                    .lineLimit(1)
            }

            Spacer()

            if let score = score {
                Text(String(format: "%.0f%%", score * 100))
                    .font(SMFont.mono(compact ? 14 : 16))
                    .foregroundStyle(.smEmerald)
            }

            VStack(alignment: .trailing, spacing: 2) {
                Text(fragrance.priceTier.rawValue)
                    .font(SMFont.label(10))
                    .foregroundStyle(.smTextTertiary)
                Text(fragrance.region.flag)
                    .font(.system(size: compact ? 12 : 14))
            }
        }
        .padding(compact ? 10 : 14)
        .background(Color.smSurfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
