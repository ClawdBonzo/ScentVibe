import SwiftUI

// MARK: - Level-Up Full-Screen Celebration
// Duolingo-style: burst of particles, new title reveal, dismiss tap.

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

    private let goldenGrad = LinearGradient(
        colors: [
            Color(red: 0.98, green: 0.82, blue: 0.38),
            Color(red: 0.85, green: 0.68, blue: 0.22),
        ],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )

    var body: some View {
        ZStack {
            // Dim overlay
            Color.black.opacity(bgOpacity * 0.88)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            VStack(spacing: 0) {
                Spacer()

                // ── Central burst circle ──
                ZStack {
                    // Glow rings
                    if !reduceMotion {
                        ForEach(0..<3, id: \.self) { i in
                            Circle()
                                .stroke(Color(red: 0.98, green: 0.78, blue: 0.28).opacity(0.12 - Double(i) * 0.03), lineWidth: 1)
                                .frame(width: CGFloat(160 + i * 36), height: CGFloat(160 + i * 36))
                                .scaleEffect(glowPulse ? 1.07 : 0.95)
                        }
                    }

                    // Main circle
                    Circle()
                        .fill(goldenGrad)
                        .frame(width: 150, height: 150)
                        .shadow(color: Color(red: 0.98, green: 0.80, blue: 0.28).opacity(0.55), radius: 30, x: 0, y: 0)
                        .scaleEffect(circleScale)

                    // "LEVEL UP" text inside circle
                    VStack(spacing: 4) {
                        Text("LEVEL")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color(red: 0.5, green: 0.35, blue: 0.05))
                            .kerning(2.5)

                        Text("\(newLevel)")
                            .font(.system(size: 58, weight: .black, design: .rounded))
                            .foregroundStyle(Color(red: 0.2, green: 0.12, blue: 0.0))

                        Text("REACHED")
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color(red: 0.5, green: 0.35, blue: 0.05))
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
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundStyle(Color(red: 0.97, green: 0.92, blue: 0.78))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .opacity(showTitle ? 1 : 0)
                .offset(y: showTitle ? 0 : 20)

                Spacer().frame(height: 48)

                // ── CTA button ──
                Button(action: dismiss) {
                    Text("Keep Going! 🚀")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color(red: 0.06, green: 0.06, blue: 0.06))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(goldenGrad)
                        .cornerRadius(14)
                        .padding(.horizontal, 32)
                }
                .opacity(showCTA ? 1 : 0)
                .offset(y: showCTA ? 0 : 16)

                Spacer()
            }

            // ── Particle burst ──
            if !reduceMotion {
                LevelUpParticles(active: particlesBurst)
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

        withAnimation(.interpolatingSpring(mass: 1, stiffness: 120, damping: 12).delay(0.1)) {
            circleScale = 1.0
            showCircle = true
        }

        withAnimation(.easeOut(duration: 0.4).delay(0.5)) {
            glowPulse = true
        }
        withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true).delay(0.5)) {
            glowPulse = true
        }

        withAnimation(.easeOut(duration: 0.4).delay(0.6)) {
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

// MARK: - Particle Burst

private struct LevelUpParticles: View {
    let active: Bool

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<40, id: \.self) { i in
                    Particle(index: i, active: active, canvasSize: geo.size)
                }
            }
        }
    }

    private struct Particle: View {
        let index: Int
        let active: Bool
        let canvasSize: CGSize

        @State private var offset: CGSize = .zero
        @State private var opacity: Double = 0
        @State private var scale: CGFloat = 0.2

        private let colors: [Color] = [
            Color(red: 0.98, green: 0.82, blue: 0.28),
            Color(red: 0.00, green: 0.85, blue: 0.62),
            Color(red: 1.00, green: 1.00, blue: 1.00),
            Color(red: 1.00, green: 0.55, blue: 0.15),
        ]

        private var randomAngle: Double { Double.random(in: 0...360) }
        private var randomDistance: CGFloat { CGFloat.random(in: 90...220) }
        private var randomColor: Color { colors.randomElement()! }
        private var randomSize: CGFloat { CGFloat.random(in: 5...14) }
        private var randomDelay: Double { Double(index) * 0.015 }

        var body: some View {
            Circle()
                .fill(randomColor)
                .frame(width: randomSize, height: randomSize)
                .scaleEffect(scale)
                .opacity(opacity)
                .offset(offset)
                .position(x: canvasSize.width / 2, y: canvasSize.height / 2)
                .onChange(of: active) { _, newVal in
                    guard newVal else { return }
                    let angle = randomAngle
                    let dist = randomDistance
                    let dx = CGFloat(cos(angle * .pi / 180)) * dist
                    let dy = CGFloat(sin(angle * .pi / 180)) * dist

                    withAnimation(.easeOut(duration: 0.7).delay(randomDelay)) {
                        offset = CGSize(width: dx, height: dy)
                        scale = 1.0
                        opacity = 0.9
                    }
                    withAnimation(.easeIn(duration: 0.5).delay(randomDelay + 0.5)) {
                        opacity = 0
                        scale = 0.5
                    }
                }
        }
    }
}

#Preview {
    LevelUpAnimationView(newLevel: 10, levelTitle: "Aroma Explorer") {}
}
