import SwiftUI

struct BadgeUnlockPopupView: View {
    let badge: Badge
    @State private var isVisible = false
    @State private var scale: CGFloat = 0.3
    @State private var opacity: Double = 0
    @State private var particlesBursting = false
    @State private var glowPulse = false
    @State private var ringScale: [CGFloat] = [1.0, 1.0, 1.0]

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // Vibrant palette
    private let hotGold   = Color(red: 1.00, green: 0.843, blue: 0.00)
    private let emerald   = Color(red: 0.00, green: 0.831, blue: 0.667)
    private let elecTeal  = Color(red: 0.00, green: 0.941, blue: 1.00)

    var body: some View {
        ZStack {
            // Dim overlay
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .onTapGesture { dismissBadge() }

            // Molecular particles in background of celebration
            if !reduceMotion {
                MolecularParticleLayer(count: 16)
                    .ignoresSafeArea()
                    .opacity(opacity * 0.7)
            }

            // Radial ambient glow behind card
            if !reduceMotion {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [hotGold.opacity(glowPulse ? 0.18 : 0.06), .clear],
                            center: .center, startRadius: 0, endRadius: 240
                        )
                    )
                    .frame(width: 480, height: 480)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: glowPulse)
            }

            // Badge card
            VStack(spacing: 20) {

                // Header
                VStack(spacing: 6) {
                    Text("✨ Badge Unlocked!")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(hotGold)
                        .smNeonGlow(color: hotGold, radius: 8, intensity: 0.7)

                    Text(badge.category.rawValue.uppercased())
                        .font(.system(size: 11, weight: .bold))
                        .tracking(3)
                        .foregroundStyle(emerald)
                }

                // Badge orb with neon rings
                ZStack {
                    if !reduceMotion {
                        ForEach(0..<3, id: \.self) { i in
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            hotGold.opacity(0.35 - Double(i) * 0.10),
                                            emerald.opacity(0.25 - Double(i) * 0.07)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5 - CGFloat(i) * 0.3
                                )
                                .frame(width: CGFloat(128 + i * 28), height: CGFloat(128 + i * 28))
                                .scaleEffect(ringScale[i])
                        }
                    }

                    // Badge circle background
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    hotGold.opacity(0.18),
                                    emerald.opacity(0.10),
                                    elecTeal.opacity(0.06)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [hotGold, emerald, elecTeal],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .smNeonGlow(color: hotGold, radius: 18, intensity: glowPulse ? 0.9 : 0.5)

                    Text(badge.icon)
                        .font(.system(size: 56))
                        .scaleEffect(reduceMotion ? 1.0 : scale)
                }

                // Badge info
                VStack(spacing: 8) {
                    Text(badge.name)
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .foregroundStyle(Color.smTextPrimary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)

                    Text(badge.description)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.smTextSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                }

                // Dismiss button
                Button(action: dismissBadge) {
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 13, weight: .bold))
                        Text("Awesome!")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                        Image(systemName: "star.fill")
                            .font(.system(size: 13, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundStyle(Color.smBackground)
                    .background(
                        LinearGradient(
                            colors: [hotGold, emerald, elecTeal],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .smNeonGlow(color: hotGold, radius: 10, intensity: 0.6)
                }
            }
            .padding(28)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.10, green: 0.13, blue: 0.12),
                                Color(red: 0.06, green: 0.08, blue: 0.07),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(
                                LinearGradient(
                                    colors: [hotGold.opacity(0.4), emerald.opacity(0.2), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .padding(24)
            .scaleEffect(reduceMotion ? 1.0 : scale)
            .opacity(opacity)

            // Full-screen golden particle burst
            if !reduceMotion {
                GoldenParticleBurst(active: particlesBursting)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            showBadge()
            if !reduceMotion { GamificationHaptics.badgeUnlocked() }
        }
    }

    private func showBadge() {
        if reduceMotion {
            scale = 1.0; opacity = 1.0; return
        }

        withAnimation(.interpolatingSpring(mass: 0.8, stiffness: 80, damping: 9)) {
            scale = 1.0
            opacity = 1.0
        }

        // Neon ring pulse animation
        withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true).delay(0.3)) {
            glowPulse = true
        }

        // Concentric ring scale pulses (staggered)
        for i in 0..<3 {
            withAnimation(
                .easeInOut(duration: 1.6 + Double(i) * 0.3)
                .repeatForever(autoreverses: true)
                .delay(Double(i) * 0.25)
            ) {
                ringScale[i] = 1.08 + CGFloat(i) * 0.04
            }
        }

        // Fire particle burst
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            particlesBursting = true
        }
    }

    private func dismissBadge() {
        if !reduceMotion {
            withAnimation(.easeInOut(duration: 0.3)) {
                scale = 0.8; opacity = 0
            }
        } else {
            opacity = 0
        }
    }
}

#Preview {
    let badge = Badge(
        id: "test",
        name: "Perfect Match Streak",
        description: "Get 5 consecutive 90+ vibe score matches",
        icon: "🎯",
        category: .milestone,
        unlockCondition: "5 perfect matches in a row"
    )
    BadgeUnlockPopupView(badge: badge)
}
