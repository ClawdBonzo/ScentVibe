import SwiftUI

// MARK: - Theme Colors

extension Color {
    // Primary palette - Premium deep teal luxury
    static let smDeepTeal = Color(red: 0.04, green: 0.24, blue: 0.24)  // #0A3D3D
    static let smTeal = Color(red: 0.06, green: 0.32, blue: 0.32)
    static let smLightTeal = Color(red: 0.12, green: 0.50, blue: 0.50)

    // Accent - Vibrant emerald to neon green
    static let smEmerald = Color(red: 0.00, green: 0.78, blue: 0.33)   // #00C853
    static let smLightEmerald = Color(red: 0.22, green: 1.00, blue: 0.08)  // #39FF14 neon

    // Gold accent for premium
    static let smGold = Color(red: 0.88, green: 0.75, blue: 0.35)
    static let smLightGold = Color(red: 0.96, green: 0.87, blue: 0.50)

    // Background - Deep dark luxury
    static let smBackground = Color(red: 0.03, green: 0.05, blue: 0.07)
    static let smSurface = Color(red: 0.06, green: 0.08, blue: 0.11)
    static let smSurfaceElevated = Color(red: 0.10, green: 0.12, blue: 0.16)

    // Text
    static let smTextPrimary = Color(red: 0.96, green: 0.96, blue: 0.94)
    static let smTextSecondary = Color(red: 0.62, green: 0.66, blue: 0.69)
    static let smTextTertiary = Color(red: 0.42, green: 0.46, blue: 0.49)

    // Status
    static let smSuccess = Color(red: 0.00, green: 0.78, blue: 0.33)
    static let smWarning = Color(red: 0.96, green: 0.76, blue: 0.22)
    static let smError = Color(red: 0.92, green: 0.28, blue: 0.28)

    // Vibe score gradient (emerald → neon)
    static let smVibeGradientStart = Color(red: 0.00, green: 0.78, blue: 0.33)  // #00C853
    static let smVibeGradientEnd = Color(red: 0.06, green: 0.32, blue: 0.32)
}

// MARK: - Theme Gradients

extension LinearGradient {
    static let smPrimaryGradient = LinearGradient(
        colors: [.smEmerald, .smTeal],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let smBackgroundGradient = LinearGradient(
        colors: [.smBackground, .smDeepTeal.opacity(0.3)],
        startPoint: .top,
        endPoint: .bottom
    )

    static let smVibeGradient = LinearGradient(
        colors: [.smVibeGradientStart, .smVibeGradientEnd],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let smGoldGradient = LinearGradient(
        colors: [.smGold, .smLightGold],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let smCardGradient = LinearGradient(
        colors: [.smSurfaceElevated, .smSurface],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Theme Typography

struct SMFont {
    // Display
    static func display(_ size: CGFloat = 34) -> Font {
        .system(size: size, weight: .bold, design: .serif)
    }

    // Headlines
    static func headline(_ size: CGFloat = 22) -> Font {
        .system(size: size, weight: .semibold, design: .default)
    }

    // Body
    static func body(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }

    // Caption
    static func caption(_ size: CGFloat = 13) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }

    // Label
    static func label(_ size: CGFloat = 11) -> Font {
        .system(size: size, weight: .semibold, design: .default)
    }

    // Mono for scores
    static func mono(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .medium, design: .monospaced)
    }
}

// MARK: - View Modifiers

struct SMCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.smSurfaceElevated)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.smTeal.opacity(0.2), lineWidth: 0.5)
                    )
            )
    }
}

struct SMGlassModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .background(Color.smSurface.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

extension View {
    func smCard() -> some View {
        modifier(SMCardModifier())
    }

    func smGlass() -> some View {
        modifier(SMGlassModifier())
    }
}

// MARK: - Theme Constants

struct SMTheme {
    static let cornerRadius: CGFloat = 16
    static let smallCornerRadius: CGFloat = 10
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8
    static let cardSpacing: CGFloat = 12
    static let sectionSpacing: CGFloat = 24
    static let iconSize: CGFloat = 24
    static let buttonHeight: CGFloat = 52
    static let thumbnailSize: CGFloat = 64
}
