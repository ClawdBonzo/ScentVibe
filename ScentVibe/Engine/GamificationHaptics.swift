import UIKit

@MainActor
enum GamificationHaptics {
    // MARK: - Haptic Patterns

    static func questCompleted() {
        // Success + escalation: impact + notification
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)
        }
    }

    static func levelUp() {
        // Celebratory triple-tap pattern
        let pattern: [TimeInterval] = [0, 0.1, 0.15, 0.3]
        playHapticPattern(pattern, style: .heavy)
    }

    static func streakMilestone() {
        // Double pulse with escalation
        let pattern: [TimeInterval] = [0, 0.15, 0.35]
        playHapticPattern(pattern, style: .medium)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)
        }
    }

    static func badgeUnlocked() {
        // Ascending double-pulse: light -> heavy
        let impact1 = UIImpactFeedbackGenerator(style: .light)
        impact1.impactOccurred()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            let impact2 = UIImpactFeedbackGenerator(style: .medium)
            impact2.impactOccurred()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let impact3 = UIImpactFeedbackGenerator(style: .heavy)
            impact3.impactOccurred()
        }
    }

    static func successfulMatch() {
        // Gentle pulse for successful match
        let pattern: [TimeInterval] = [0, 0.2]
        playHapticPattern(pattern, style: .light)
    }

    static func perfectMatch() {
        // Triumphant pattern: escalating pulses
        let pattern: [TimeInterval] = [0, 0.1, 0.25, 0.35, 0.5]
        playHapticPattern(pattern, style: .heavy)
    }

    // MARK: - Private Helpers

    private static func playHapticPattern(_ pattern: [TimeInterval], style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()

        for (index, delay) in pattern.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if index == 0 {
                    generator.impactOccurred()
                } else {
                    let newGenerator = UIImpactFeedbackGenerator(style: style)
                    newGenerator.impactOccurred()
                }
            }
        }
    }
}
