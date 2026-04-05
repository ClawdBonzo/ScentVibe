import SwiftUI

// MARK: - Wardrobe Confetti Celebration
// Lightweight Canvas + TimelineView confetti burst for the first wardrobe save.
// Uses gold/emerald palette from the design system. Performance-aware:
// scales particle count via DevicePerformance, respects reduceMotion.

struct ConfettiView: View {
    @Binding var isActive: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var particles: [ConfettiParticle] = []
    @State private var startTime: Date = .now

    private let tier = DevicePerformance.current
    private static let duration: Double = 2.8

    var body: some View {
        if isActive && !reduceMotion && DevicePerformance.shouldRenderEffects {
            TimelineView(.animation(minimumInterval: tier.frameInterval)) { timeline in
                Canvas { ctx, size in
                    let elapsed = timeline.date.timeIntervalSince(startTime)
                    guard elapsed < Self.duration else { return }

                    let progress = elapsed / Self.duration
                    let gravity = 420.0 // pixels/s^2
                    let t = elapsed

                    for p in particles {
                        let x = size.width * p.startX + p.velocityX * t
                        let y = size.height * p.startY + p.velocityY * t + 0.5 * gravity * t * t
                        let rotation = p.spin * t
                        let fadeOut = max(0, 1 - pow(progress, 1.8))
                        let scale = p.size * (1 - progress * 0.3)

                        guard y < size.height + 50 else { continue }

                        ctx.opacity = fadeOut * p.opacity

                        // Draw as rotated rounded rect for confetti look
                        let w = scale
                        let h = scale * p.aspectRatio
                        let rect = CGRect(x: -w / 2, y: -h / 2, width: w, height: h)

                        var transform = CGAffineTransform.identity
                        transform = transform.translatedBy(x: x, y: y)
                        transform = transform.rotated(by: rotation)

                        let path = RoundedRectangle(cornerRadius: scale * 0.2)
                            .path(in: rect)
                            .applying(transform)

                        ctx.fill(path, with: .color(p.color))
                    }
                }
            }
            .drawingGroup()
            .allowsHitTesting(false)
            .accessibilityHidden(true)
            .ignoresSafeArea()
            .onAppear {
                startTime = .now
                particles = Self.generateParticles(count: DevicePerformance.scaledCount(55))
                scheduleCleanup()
            }
        }
    }

    // MARK: - Particle Generation

    private static let confettiColors: [Color] = [
        .smGold, .smLightGold,
        .smEmerald, .smLightEmerald,
        .smGold.opacity(0.8), .smEmerald.opacity(0.7),
        Color(red: 0.95, green: 0.85, blue: 0.50), // warm gold
        Color(red: 0.30, green: 0.90, blue: 0.55), // bright emerald
    ]

    private static func generateParticles(count: Int) -> [ConfettiParticle] {
        (0..<count).map { _ in
            ConfettiParticle(
                startX: CGFloat.random(in: 0.1...0.9),
                startY: CGFloat.random(in: -0.15...0.05),
                velocityX: CGFloat.random(in: -120...120),
                velocityY: CGFloat.random(in: -350 ... -100),
                size: CGFloat.random(in: 5...12),
                aspectRatio: CGFloat.random(in: 0.4...1.0),
                spin: Double.random(in: -12...12),
                opacity: Double.random(in: 0.7...1.0),
                color: confettiColors.randomElement()!
            )
        }
    }

    private func scheduleCleanup() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.duration + 0.2) {
            withAnimation(.easeOut(duration: 0.3)) {
                isActive = false
            }
        }
    }
}

// MARK: - Particle Data

private struct ConfettiParticle {
    let startX: CGFloat        // 0…1 normalized
    let startY: CGFloat        // 0…1 normalized (negative = above screen)
    let velocityX: CGFloat     // px/sec horizontal spread
    let velocityY: CGFloat     // px/sec initial upward velocity (negative = up)
    let size: CGFloat           // base size in points
    let aspectRatio: CGFloat   // width:height ratio for variety
    let spin: Double           // radians/sec rotation
    let opacity: Double
    let color: Color
}

// MARK: - First Save Tracker

enum FirstSaveTracker {
    @AppStorage("hasEverSavedToWardrobe") private static var hasSaved = false

    /// Returns `true` exactly once — on the very first wardrobe save.
    static func checkAndMarkFirstSave() -> Bool {
        guard !hasSaved else { return false }
        hasSaved = true
        return true
    }
}
