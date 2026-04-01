import SwiftUI

struct VibeScoreGauge: View {
    let score: Double  // 0-100
    var size: CGFloat = 80
    var lineWidth: CGFloat = 6

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.smTeal.opacity(0.2), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: score / 100.0)
                .stroke(
                    scoreGradient,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            Text(String(format: "%.0f", score))
                .font(SMFont.mono(size * 0.3))
                .foregroundStyle(scoreColor)
        }
        .frame(width: size, height: size)
    }

    private var scoreColor: Color {
        switch score {
        case 80...: return .smEmerald
        case 60..<80: return .smLightTeal
        case 40..<60: return .smGold
        default: return .smTextSecondary
        }
    }

    private var scoreGradient: LinearGradient {
        switch score {
        case 80...: return LinearGradient.smVibeGradient
        case 60..<80: return LinearGradient(colors: [.smTeal, .smLightTeal], startPoint: .leading, endPoint: .trailing)
        case 40..<60: return LinearGradient.smGoldGradient
        default: return LinearGradient(colors: [.smTextTertiary, .smTextSecondary], startPoint: .leading, endPoint: .trailing)
        }
    }
}
