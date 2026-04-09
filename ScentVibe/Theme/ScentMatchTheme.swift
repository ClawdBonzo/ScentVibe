import SwiftUI

// MARK: - Theme Colors

extension Color {
    // Primary palette — Vibrant emerald → electric teal → hot gold
    static let smDeepTeal = Color(red: 0.00, green: 0.20, blue: 0.24)   // deep anchor
    static let smTeal = Color(red: 0.00, green: 0.56, blue: 0.70)       // vibrant mid-teal
    static let smLightTeal = Color(red: 0.00, green: 0.75, blue: 0.90)  // bright teal highlight

    // Accent — Vibrant emerald (#00D4AA) → electric teal (#00F0FF)
    static let smEmerald = Color(red: 0.00, green: 0.831, blue: 0.667)  // #00D4AA vibrant emerald
    static let smLightEmerald = Color(red: 0.00, green: 0.941, blue: 1.00) // #00F0FF electric teal

    // Hot gold (#FFD700) — electric, premium
    static let smGold = Color(red: 1.00, green: 0.843, blue: 0.00)      // #FFD700 hot gold
    static let smLightGold = Color(red: 1.00, green: 0.92, blue: 0.40)  // warm gold highlight

    // Background — Deep dark luxury
    static let smBackground = Color(red: 0.03, green: 0.05, blue: 0.07)
    static let smSurface = Color(red: 0.06, green: 0.08, blue: 0.11)
    static let smSurfaceElevated = Color(red: 0.10, green: 0.12, blue: 0.16)

    // Text
    static let smTextPrimary = Color(red: 0.96, green: 0.96, blue: 0.94)
    static let smTextSecondary = Color(red: 0.62, green: 0.66, blue: 0.69)
    static let smTextTertiary = Color(red: 0.42, green: 0.46, blue: 0.49)

    // Status
    static let smSuccess = Color(red: 0.00, green: 0.831, blue: 0.667)
    static let smWarning = Color(red: 1.00, green: 0.843, blue: 0.00)
    static let smError = Color(red: 0.92, green: 0.28, blue: 0.28)

    // Vibe score gradient — vibrant emerald → electric teal
    static let smVibeGradientStart = Color(red: 0.00, green: 0.831, blue: 0.667)
    static let smVibeGradientEnd = Color(red: 0.00, green: 0.941, blue: 1.00)
}

// MARK: - Theme Gradients

extension LinearGradient {
    /// Hero 3-stop gradient: vibrant emerald → electric teal → hot gold
    static let smPrimaryGradient = LinearGradient(
        colors: [.smEmerald, .smLightEmerald, .smGold],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let smBackgroundGradient = LinearGradient(
        colors: [.smBackground, Color(red: 0.00, green: 0.10, blue: 0.14)],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Vibe score ring gradient — emerald → electric teal
    static let smVibeGradient = LinearGradient(
        colors: [.smVibeGradientStart, .smVibeGradientEnd],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Hot gold gradient for premium CTAs
    static let smGoldGradient = LinearGradient(
        colors: [.smGold, .smLightGold],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Neon gold → teal gradient for buttons and accents
    static let smNeonGradient = LinearGradient(
        colors: [.smGold, .smEmerald, .smLightEmerald],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let smCardGradient = LinearGradient(
        colors: [.smSurfaceElevated, .smSurface],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Theme Typography

struct SMFont {
    static func display(_ size: CGFloat = 34) -> Font {
        .system(size: size, weight: .bold, design: .serif)
    }
    static func headline(_ size: CGFloat = 22) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }
    static func body(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }
    static func caption(_ size: CGFloat = 13) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }
    static func label(_ size: CGFloat = 11) -> Font {
        .system(size: size, weight: .semibold, design: .default)
    }
    static func mono(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .bold, design: .monospaced)
    }
}

// MARK: - Premium Spring Animation

extension Animation {
    static let smSpring = Animation.spring(response: 0.45, dampingFraction: 0.72, blendDuration: 0.1)
    static let smBounce = Animation.spring(response: 0.35, dampingFraction: 0.6, blendDuration: 0)
    static let smSmooth = Animation.easeInOut(duration: 0.3)
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
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.smEmerald.opacity(0.25),
                                        Color.smLightEmerald.opacity(0.12),
                                        Color.smGold.opacity(0.06),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.8
                            )
                    )
            )
    }
}

struct SMGlassModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .background(Color.smSurface.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [Color.smEmerald.opacity(0.15), Color.smGold.opacity(0.08), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.8
                    )
            )
    }
}

/// Neon glow shadow modifier — adds a vibrant colored halo
struct SMNeonGlowModifier: ViewModifier {
    let color: Color
    let radius: CGFloat
    let intensity: Double

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(intensity * 0.7), radius: radius * 0.5, x: 0, y: 0)
            .shadow(color: color.opacity(intensity * 0.4), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(intensity * 0.2), radius: radius * 2, x: 0, y: 0)
    }
}

extension View {
    func smCard() -> some View {
        modifier(SMCardModifier())
    }

    func smGlass() -> some View {
        modifier(SMGlassModifier())
    }

    /// Neon glow halo effect — triple-layered shadow for premium electric look
    func smNeonGlow(color: Color = .smEmerald, radius: CGFloat = 12, intensity: Double = 1.0) -> some View {
        modifier(SMNeonGlowModifier(color: color, radius: radius, intensity: intensity))
    }

    /// Premium entrance animation
    func smEntrance(delay: Double = 0) -> some View {
        self.transition(.asymmetric(
            insertion: .opacity.combined(with: .offset(y: 12)).animation(.smSpring.delay(delay)),
            removal: .opacity
        ))
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
