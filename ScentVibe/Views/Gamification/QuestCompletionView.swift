import SwiftUI

// MARK: - Quest Completion Popup
// Duolingo-style XP burst: slides up from bottom, shows XP earned, auto-dismisses.

struct QuestCompletionView: View {
    let questTitle: String
    let xpEarned: Int
    var onDismiss: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var slideUp = false
    @State private var xpScale: CGFloat = 0.5
    @State private var xpOpacity: Double = 0

    var body: some View {
        VStack {
            Spacer()

            HStack(spacing: 16) {
                // XP burst circle
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.00, green: 0.85, blue: 0.62),
                                    Color(red: 0.00, green: 0.70, blue: 0.50),
                                ],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 54, height: 54)
                        .shadow(color: Color(red: 0, green: 0.85, blue: 0.62).opacity(0.45), radius: 12, x: 0, y: 0)

                    Image(systemName: "checkmark")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                }
                .scaleEffect(xpScale)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Quest Complete!")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.smTextPrimary)

                    Text(questTitle)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.smTextSecondary)
                        .lineLimit(1)
                }

                Spacer()

                // XP badge
                VStack(spacing: 2) {
                    Text("+\(xpEarned)")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundStyle(Color(red: 0.98, green: 0.82, blue: 0.28))

                    Text("XP")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.98, green: 0.82, blue: 0.28).opacity(0.7))
                }
                .opacity(xpOpacity)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.09, green: 0.12, blue: 0.12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.00, green: 0.85, blue: 0.62).opacity(0.5),
                                        Color(red: 0.85, green: 0.68, blue: 0.22).opacity(0.3),
                                    ],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            .offset(y: slideUp ? 0 : 120)
            .opacity(slideUp ? 1 : 0)
        }
        .onAppear { runEntrance() }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Quest complete: \(questTitle). +\(xpEarned) XP earned.")
        .allowsHitTesting(false)
    }

    private func runEntrance() {
        if !reduceMotion {
            GamificationHaptics.questCompleted()
        }

        withAnimation(.interpolatingSpring(mass: 1, stiffness: 220, damping: 20)) {
            slideUp = true
        }

        withAnimation(.interpolatingSpring(mass: 1, stiffness: 280, damping: 18).delay(0.18)) {
            xpScale = 1.0
        }

        withAnimation(.easeOut(duration: 0.3).delay(0.28)) {
            xpOpacity = 1
        }

        // Auto dismiss after 2.8 s
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            withAnimation(.easeIn(duration: 0.35)) {
                slideUp = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                onDismiss()
            }
        }
    }
}

#Preview {
    ZStack {
        Color.smBackground.ignoresSafeArea()
        QuestCompletionView(questTitle: "Scan 3 Outfits", xpEarned: 50) {}
    }
}
