import SwiftUI

struct BadgeUnlockPopupView: View {
    let badge: Badge
    @State private var isVisible = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            // Dim background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissBadge()
                }

            VStack(spacing: 20) {
                // Celebration Text
                VStack(spacing: 8) {
                    Text("🎉 Badge Unlocked!")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.smTextPrimary)

                    Text(badge.category.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.smTextSecondary)
                }

                // Badge Display
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.85, green: 0.72, blue: 0.27).opacity(0.2),
                                    Color(red: 0.00, green: 0.85, blue: 0.62).opacity(0.1),
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .strokeBorder(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.85, green: 0.72, blue: 0.27),
                                            Color(red: 0.00, green: 0.85, blue: 0.62),
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                                .frame(width: 120, height: 120)
                        )

                    Text(badge.icon)
                        .font(.system(size: 56))
                        .scaleEffect(reduceMotion ? 1.0 : scale)
                }

                // Badge Info
                VStack(spacing: 8) {
                    Text(badge.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.smTextPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)

                    Text(badge.description)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.smTextSecondary)
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                }

                // Dismiss Button
                Button(action: dismissBadge) {
                    Text("Awesome!")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.85, green: 0.72, blue: 0.27),
                                    Color(red: 0.00, green: 0.85, blue: 0.62),
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundStyle(Color.smBackground)
                        .cornerRadius(10)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.12, green: 0.15, blue: 0.14),
                                Color(red: 0.08, green: 0.1, blue: 0.09),
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .padding(20)
            .scaleEffect(reduceMotion ? 1.0 : scale)
            .opacity(opacity)
        }
        .onAppear {
            showBadge()

            if !reduceMotion {
                GamificationHaptics.badgeUnlocked()
            }
        }
    }

    private func showBadge() {
        if !reduceMotion {
            withAnimation(.interpolatingSpring(mass: 1, stiffness: 70, damping: 8)) {
                scale = 1.0
                opacity = 1.0
            }
        } else {
            scale = 1.0
            opacity = 1.0
        }
    }

    private func dismissBadge() {
        if !reduceMotion {
            withAnimation(.easeInOut(duration: 0.3)) {
                scale = 0.8
                opacity = 0
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

    return BadgeUnlockPopupView(badge: badge)
}
