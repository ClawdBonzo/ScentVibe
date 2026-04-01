import SwiftUI

// MARK: - Theme Colors

extension Color {
    // Primary palette - Deep teal luxury
    static let smDeepTeal = Color(red: 0.05, green: 0.22, blue: 0.25)
    static let smTeal = Color(red: 0.08, green: 0.35, blue: 0.38)
    static let smLightTeal = Color(red: 0.15, green: 0.55, blue: 0.55)

    // Accent - Emerald
    static let smEmerald = Color(red: 0.20, green: 0.65, blue: 0.45)
    static let smLightEmerald = Color(red: 0.30, green: 0.80, blue: 0.55)

    // Gold accent for premium
    static let smGold = Color(red: 0.85, green: 0.72, blue: 0.40)
    static let smLightGold = Color(red: 0.95, green: 0.85, blue: 0.55)

    // Background
    static let smBackground = Color(red: 0.04, green: 0.06, blue: 0.08)
    static let smSurface = Color(red: 0.08, green: 0.10, blue: 0.13)
    static let smSurfaceElevated = Color(red: 0.12, green: 0.14, blue: 0.18)

    // Text
    static let smTextPrimary = Color(red: 0.95, green: 0.95, blue: 0.93)
    static let smTextSecondary = Color(red: 0.65, green: 0.68, blue: 0.70)
    static let smTextTertiary = Color(red: 0.45, green: 0.48, blue: 0.50)

    // Status
    static let smSuccess = Color(red: 0.20, green: 0.75, blue: 0.50)
    static let smWarning = Color(red: 0.95, green: 0.75, blue: 0.25)
    static let smError = Color(red: 0.90, green: 0.30, blue: 0.30)

    // Vibe score gradient
    static let smVibeGradientStart = Color(red: 0.20, green: 0.65, blue: 0.45)
    static let smVibeGradientEnd = Color(red: 0.08, green: 0.35, blue: 0.38)
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
