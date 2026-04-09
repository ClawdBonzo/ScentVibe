import SwiftUI

// MARK: - Level-Up Full-Screen Celebration
// Luxury perfume-house launch feel: molecular particles, neon orb, particle burst.

struct LevelUpAnimationView: View {
    let newLevel: Int
    let levelTitle: String
    var onDismiss: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var showCircle = false
    @State private var showLevel = false
    @State private var showTitle = false
    @State private var showCTA = false
    @State private var particlesBurst = false
    @State private var bgOpacity = 0.0
    @State private var circleScale: CGFloat = 0.3
    @State private var glowPulse = false
    @State private var orbRotation: Double = 0

    // Vibrant hot gold → electric teal gradient for the orb
    private let neonGrad = LinearGradient(
        colors: [
            Color(red: 1.00, green: 0.843, blue: 0.00),   // hot gold
            Color(red: 0.00, green: 0.831, blue: 0.667),  // vibrant emerald
            Color(red: 0.00, green: 0.941, blue: 1.00),   // electric teal
        ],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )

    private let hotGold  = Color(red: 1.00, green: 0.843, blue: 0.00)
    private let emerald  = Color(red: 0.00, green: 0.831, blue: 0.667)
    private let elecTeal = Color(red: 0.00, green: 0.941, blue: 1.00)

    var body: some View {
        ZStack {
            // Dark overlay
            Color.black.opacity(bgOpacity * 0.88)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            // Molecular particle layer — shows through the celebration
            if !reduceMotion {
                MolecularParticleLayer(count: 22)
                    .ignoresSafeArea()
                    .opacity(bgOpacity * 0.5)
            }

            // Ambient radial glow behind orb
            if !reduceMotion {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                hotGold.opacity(glowPulse ? 0.20 : 0.06),
                                emerald.opacity(glowPulse ? 0.12 : 0.03),
                                .clear
                            ],
                            center: .center, startRadius: 0, endRadius: 300
                        )
                    )
                    .frame(width: 600, height: 600)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: glowPulse)
            }

            VStack(spacing: 0) {
                Spacer()

                // ── Central neon orb ──
                ZStack {
                    // Outer rotating neon ring (electric teal)
                    if !reduceMotion {
                        Circle()
                            .trim(from: 0.0, to: 0.75)
                            .stroke(
                                LinearGradient(
                                    colors: [elecTeal.opacity(0.6), elecTeal.opacity(0.0)],
                                    startPoint: .leading, endPoint: .trailing
                                ),
                                style: StrokeStyle(lineWidth: 1.5, lineCap: .round)
                            )
                            .frame(width: 210, height: 210)
                            .rotationEffect(.degrees(orbRotation))

                        // Counter-rotating emerald ring
                        Circle()
                            .trim(from: 0.0, to: 0.5)
                            .stroke(
                                LinearGradient(
                                    colors: [emerald.opacity(0.5), emerald.opacity(0.0)],
                                    startPoint: .leading, endPoint: .trailing
                                ),
                                style: StrokeStyle(lineWidth: 1, lineCap: .round)
                            )
                            .frame(width: 185, height: 185)
                            .rotationEffect(.degrees(-orbRotation * 0.7))
                    }

                    // Pulsing glow rings
                    if !reduceMotion {
                        ForEach(0..<3, id: \.self) { i in
                            Circle()
                                .stroke(
                                    hotGold.opacity(0.18 - Double(i) * 0.05),
                                    lineWidth: 1.2 - CGFloat(i) * 0.3
                                )
                                .frame(width: CGFloat(162 + i * 32), height: CGFloat(162 + i * 32))
                                .scaleEffect(glowPulse ? 1.06 + CGFloat(i) * 0.03 : 0.96)
                        }
                    }

                    // Main orb body
                    Circle()
                        .fill(neonGrad)
                        .frame(width: 152, height: 152)
                        .shadow(color: hotGold.opacity(0.55), radius: 28, x: 0, y: 0)
                        .shadow(color: emerald.opacity(0.35), radius: 50, x: 0, y: 0)
                        .scaleEffect(circleScale)

                    // Inner orb content
                    VStack(spacing: 3) {
                        Text("LEVEL")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color(red: 0.10, green: 0.06, blue: 0.00))
                            .kerning(2.5)

                        Text("\(newLevel)")
                            .font(.system(size: 58, weight: .black, design: .rounded))
                            .foregroundStyle(Color(red: 0.06, green: 0.04, blue: 0.00))

                        Text("REACHED")
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color(red: 0.10, green: 0.06, blue: 0.00))
                            .kerning(2.0)
                    }
                    .scaleEffect(circleScale)
                }
                .opacity(showCircle ? 1 : 0)

                Spacer().frame(height: 32)

                // ── Level title ──
                VStack(spacing: 10) {
                    Text("You're now a")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(Color(red: 0.65, green: 0.65, blue: 0.60))

                    Text(levelTitle)
                        .font(.system(size: 30, weight: .bold, design: .serif))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [hotGold, .smLightGold],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .smNeonGlow(color: hotGold, radius: 8, intensity: 0.6)
                }
                .opacity(showTitle ? 1 : 0)
                .offset(y: showTitle ? 0 : 20)

                Spacer().frame(height: 48)

                // ── CTA button ──
                Button(action: dismiss) {
                    HStack(spacing: 10) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 15, weight: .bold))
                        Text("Keep Going!")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 13, weight: .bold))
                    }
                    .foregroundStyle(Color(red: 0.06, green: 0.06, blue: 0.06))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(neonGrad)
                    .cornerRadius(14)
                    .padding(.horizontal, 32)
                    .smNeonGlow(color: hotGold, radius: 12, intensity: 0.6)
                }
                .opacity(showCTA ? 1 : 0)
                .offset(y: showCTA ? 0 : 16)

                Spacer()
            }

            // ── Golden particle burst ──
            if !reduceMotion {
                GoldenParticleBurst(active: particlesBurst)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        }
        .onAppear { runEntrance() }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Level up! You're now a \(levelTitle). Double-tap to continue.")
        .accessibilityAction { dismiss() }
    }

    private func runEntrance() {
        if reduceMotion {
            bgOpacity = 1; showCircle = true; showTitle = true; showCTA = true
            return
        }

        GamificationHaptics.levelUp()

        withAnimation(.easeIn(duration: 0.3)) { bgOpacity = 1 }

        withAnimation(.interpolatingSpring(mass: 0.8, stiffness: 130, damping: 11).delay(0.1)) {
            circleScale = 1.0
            showCircle = true
        }

        // Glow pulse
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(0.4)) {
            glowPulse = true
        }

        // Continuous orb rotation
        withAnimation(.linear(duration: 12).repeatForever(autoreverses: false).delay(0.4)) {
            orbRotation = 360
        }

        // Particle burst
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            particlesBurst = true
        }

        withAnimation(.easeOut(duration: 0.5).delay(0.65)) {
            showTitle = true
        }

        withAnimation(.easeOut(duration: 0.4).delay(0.9)) {
            showCTA = true
        }
    }

    private func dismiss() {
        withAnimation(.easeIn(duration: 0.25)) { bgOpacity = 0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { onDismiss() }
    }
}

#Preview {
    LevelUpAnimationView(newLevel: 10, levelTitle: "Aroma Explorer") {}
}
