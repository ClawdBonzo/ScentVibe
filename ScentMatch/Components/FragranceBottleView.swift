import SwiftUI

/// Renders a stylized perfume bottle silhouette using the fragrance's color and shape.
/// Avoids any IP issues by using programmatic art rather than product photos.
struct FragranceBottleView: View {
    let fragrance: Fragrance
    var size: CGFloat = 44

    private var bottleColor: Color {
        Color(hex: fragrance.bottleColor) ?? .smEmerald
    }

    private var secondaryColor: Color {
        bottleColor.opacity(0.6)
    }

    var body: some View {
        ZStack {
            // Glow behind bottle
            Circle()
                .fill(
                    RadialGradient(
                        colors: [bottleColor.opacity(0.2), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.6
                    )
                )
                .frame(width: size * 1.2, height: size * 1.2)

            // Bottle shape
            bottleShape
                .frame(width: size, height: size)

            // House initial overlay
            Text(String(fragrance.house.prefix(1)))
                .font(.system(size: size * 0.28, weight: .bold, design: .serif))
                .foregroundStyle(.white.opacity(0.9))
                .shadow(color: .black.opacity(0.3), radius: 1, y: 1)
        }
        .frame(width: size * 1.2, height: size * 1.2)
    }

    @ViewBuilder
    private var bottleShape: some View {
        switch fragrance.bottleShape {
        case .tall:
            tallBottle
        case .round:
            roundBottle
        case .square:
            squareBottle
        case .flacon:
            flaconBottle
        case .modern:
            modernBottle
        }
    }

    // MARK: - Bottle Shapes

    private var tallBottle: some View {
        VStack(spacing: 0) {
            // Cap
            RoundedRectangle(cornerRadius: 2)
                .fill(bottleColor.opacity(0.8))
                .frame(width: size * 0.18, height: size * 0.12)
            // Neck
            Rectangle()
                .fill(bottleColor.opacity(0.6))
                .frame(width: size * 0.12, height: size * 0.1)
            // Body
            RoundedRectangle(cornerRadius: size * 0.08)
                .fill(
                    LinearGradient(
                        colors: [bottleColor, secondaryColor, bottleColor.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: size * 0.45, height: size * 0.65)
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.08)
                        .stroke(.white.opacity(0.15), lineWidth: 0.5)
                )
        }
    }

    private var roundBottle: some View {
        VStack(spacing: 0) {
            // Cap
            RoundedRectangle(cornerRadius: 2)
                .fill(bottleColor.opacity(0.8))
                .frame(width: size * 0.2, height: size * 0.1)
            // Body
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [bottleColor.opacity(0.9), secondaryColor, bottleColor],
                        center: .init(x: 0.35, y: 0.35),
                        startRadius: 0,
                        endRadius: size * 0.4
                    )
                )
                .frame(width: size * 0.65, height: size * 0.7)
                .overlay(
                    Ellipse()
                        .stroke(.white.opacity(0.12), lineWidth: 0.5)
                )
        }
    }

    private var squareBottle: some View {
        VStack(spacing: 0) {
            // Cap
            RoundedRectangle(cornerRadius: 2)
                .fill(bottleColor.opacity(0.9))
                .frame(width: size * 0.35, height: size * 0.1)
            // Neck
            Rectangle()
                .fill(bottleColor.opacity(0.5))
                .frame(width: size * 0.14, height: size * 0.06)
            // Body
            RoundedRectangle(cornerRadius: size * 0.04)
                .fill(
                    LinearGradient(
                        colors: [bottleColor, bottleColor.opacity(0.7), secondaryColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.58, height: size * 0.6)
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.04)
                        .stroke(.white.opacity(0.1), lineWidth: 0.5)
                )
        }
    }

    private var flaconBottle: some View {
        VStack(spacing: 0) {
            // Ornate cap
            Circle()
                .fill(bottleColor.opacity(0.8))
                .frame(width: size * 0.22, height: size * 0.22)
            // Neck
            Rectangle()
                .fill(bottleColor.opacity(0.5))
                .frame(width: size * 0.08, height: size * 0.08)
            // Body — wider bottom
            UnevenRoundedRectangle(topLeadingRadius: size * 0.06, bottomLeadingRadius: size * 0.14, bottomTrailingRadius: size * 0.14, topTrailingRadius: size * 0.06)
                .fill(
                    LinearGradient(
                        colors: [bottleColor, secondaryColor],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size * 0.55, height: size * 0.55)
                .overlay(
                    UnevenRoundedRectangle(topLeadingRadius: size * 0.06, bottomLeadingRadius: size * 0.14, bottomTrailingRadius: size * 0.14, topTrailingRadius: size * 0.06)
                        .stroke(.white.opacity(0.12), lineWidth: 0.5)
                )
        }
    }

    private var modernBottle: some View {
        VStack(spacing: 0) {
            // Angled cap
            RoundedRectangle(cornerRadius: 1)
                .fill(bottleColor.opacity(0.9))
                .frame(width: size * 0.22, height: size * 0.08)
                .rotationEffect(.degrees(-5))
            // Neck
            Rectangle()
                .fill(bottleColor.opacity(0.5))
                .frame(width: size * 0.1, height: size * 0.08)
            // Body — angular
            UnevenRoundedRectangle(topLeadingRadius: size * 0.02, bottomLeadingRadius: size * 0.1, bottomTrailingRadius: size * 0.1, topTrailingRadius: size * 0.02)
                .fill(
                    LinearGradient(
                        colors: [bottleColor, bottleColor.opacity(0.5), secondaryColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.5, height: size * 0.65)
                .overlay(
                    UnevenRoundedRectangle(topLeadingRadius: size * 0.02, bottomLeadingRadius: size * 0.1, bottomTrailingRadius: size * 0.1, topTrailingRadius: size * 0.02)
                        .stroke(.white.opacity(0.15), lineWidth: 0.5)
                )
        }
    }
}

// MARK: - Hex Color Extension

extension Color {
    init?(hex: String) {
        var cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleaned.hasPrefix("#") { cleaned.removeFirst() }
        guard cleaned.count == 6,
              let number = UInt64(cleaned, radix: 16) else { return nil }
        let r = Double((number >> 16) & 0xFF) / 255.0
        let g = Double((number >> 8) & 0xFF) / 255.0
        let b = Double(number & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
