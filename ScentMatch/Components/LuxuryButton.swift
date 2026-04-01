import SwiftUI

struct LuxuryButton: View {
    let title: String
    var icon: String?
    var style: ButtonStyle = .primary
    let action: () -> Void

    enum ButtonStyle {
        case primary
        case secondary
        case gold
    }

    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        }) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(SMFont.headline(17))
            }
            .foregroundStyle(foregroundColor)
            .frame(maxWidth: .infinity)
            .frame(height: SMTheme.buttonHeight)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: SMTheme.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: SMTheme.cornerRadius)
                    .stroke(borderColor, lineWidth: style == .secondary ? 1.5 : 0)
            )
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary: return .smBackground
        case .secondary: return .smEmerald
        case .gold: return .smBackground
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary: LinearGradient.smPrimaryGradient
        case .secondary: Color.clear
        case .gold: LinearGradient.smGoldGradient
        }
    }

    private var borderColor: Color {
        switch style {
        case .secondary: return .smEmerald
        default: return .clear
        }
    }
}
