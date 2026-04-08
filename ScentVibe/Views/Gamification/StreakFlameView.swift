import SwiftUI

// MARK: - Animated Streak Flame
// Intensity scales with streak count: dim at 1, roaring at 30+

struct StreakFlameView: View {
    let streak: Int
    var size: CGFloat = 44

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var flicker = false
    @State private var sway = false

    private var intensity: Double {
        min(1.0, Double(streak) / 20.0)      // 0.05 at streak 1, 1.0 at streak 20+
    }

    private var flameColor: [Color] {
        if streak >= 30 {
            return [Color(red: 1, green: 0.85, blue: 0.0), Color(red: 1, green: 0.5, blue: 0.05), Color(red: 0.9, green: 0.2, blue: 0)]
        } else if streak >= 14 {
            return [Color(red: 1, green: 0.75, blue: 0.1), Color(red: 1, green: 0.45, blue: 0.05), Color(red: 0.85, green: 0.15, blue: 0)]
        } else if streak >= 7 {
            return [Color(red: 1, green: 0.7, blue: 0.15), Color(red: 1, green: 0.4, blue: 0.05), Color(red: 0.8, green: 0.1, blue: 0)]
        } else {
            return [Color(red: 1, green: 0.65, blue: 0.2), Color(red: 1, green: 0.38, blue: 0.05), Color(red: 0.75, green: 0.08, blue: 0)]
        }
    }

    var body: some View {
        ZStack {
            // Glow halo — scales with streak intensity
            if !reduceMotion && streak > 2 {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [flameColor[1].opacity(intensity * 0.4), .clear],
                            center: .center,
                            startRadius: 2,
                            endRadius: size * 0.8
                        )
                    )
                    .frame(width: size * 1.6, height: size * 1.6)
                    .scaleEffect(flicker ? 1.1 : 0.9)
                    .blur(radius: 4)
            }

            // Flame emoji or SF Symbol flame
            Text("🔥")
                .font(.system(size: size * 0.72))
                .scaleEffect(flicker ? 1.08 : 0.94)
                .rotationEffect(.degrees(sway ? 4 : -4))
                .shadow(color: flameColor[1].opacity(intensity * 0.8), radius: streak > 0 ? 8 : 0, x: 0, y: 2)
        }
        .onAppear {
            guard !reduceMotion && streak > 0 else { return }
            withAnimation(.easeInOut(duration: 0.55).repeatForever(autoreverses: true)) {
                flicker = true
            }
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                sway = true
            }
        }
        .accessibilityLabel("Streak: \(streak) day\(streak == 1 ? "" : "s")")
        .accessibilityHidden(false)
    }
}

// MARK: - Streak Badge Row (compact summary)

struct StreakBadgeRow: View {
    let currentStreak: Int
    let bestStreak: Int
    let multiplier: Double

    var body: some View {
        HStack(spacing: 16) {
            StreakFlameView(streak: currentStreak, size: 38)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text("\(currentStreak)")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 1, green: 0.6, blue: 0.1))

                    Text("day streak")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color.smTextPrimary)
                }

                HStack(spacing: 12) {
                    Label("Best: \(bestStreak)", systemImage: "trophy.fill")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.smTextSecondary)

                    if multiplier > 1.0 {
                        Label("×\(String(format: "%.1f", multiplier)) XP", systemImage: "bolt.fill")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color(red: 0, green: 0.85, blue: 0.62))
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.12, green: 0.10, blue: 0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color(red: 1, green: 0.5, blue: 0.1).opacity(0.25), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack(spacing: 24) {
            HStack(spacing: 20) {
                ForEach([1, 5, 14, 30], id: \.self) { s in
                    VStack {
                        StreakFlameView(streak: s, size: 44)
                        Text("\(s)d")
                            .font(.caption)
                            .foregroundStyle(.white)
                    }
                }
            }
            StreakBadgeRow(currentStreak: 12, bestStreak: 30, multiplier: 1.4)
                .padding()
        }
    }
}
