import SwiftUI

// MARK: - Deterministic pseudo-random helper

/// fract(sin(x) * k) — returns value in [0, 1)
private func molFract(_ x: Double) -> CGFloat {
    let v = x - floor(x)
    return CGFloat(v < 0 ? v + 1 : v)
}

// MARK: - Floating Molecular Particle Background
// Canvas-based, device-performance aware. Uses sinusoidal motion so no
// state mutation occurs inside the TimelineView — pure, efficient rendering.

struct MolecularParticleLayer: View {

    // MARK: Internal particle descriptor (all values computed at init)
    private struct ParticleData {
        let baseX: CGFloat       // 0…1 normalised
        let baseY: CGFloat
        let ampX: CGFloat        // oscillation amplitude (normalised)
        let ampY: CGFloat
        let freqX: Double        // oscillation frequency (Hz)
        let freqY: Double
        let phaseX: Double       // phase offset (radians)
        let phaseY: Double
        let size: CGFloat        // core dot diameter (pts)
        let colorIndex: Int      // 0 = emerald, 1 = teal, 2 = gold
        let baseOpacity: CGFloat
    }

    private let particles: [ParticleData]
    private let bondDistNorm: CGFloat = 0.20   // max connection distance (normalised)
    private let interval: Double

    /// - Parameter count: Base particle count before device-performance scaling.
    ///   Pass 0 to auto-select a good default.
    init(count: Int = 0) {
        let base = count > 0 ? count : 20
        let scaled = DevicePerformance.scaledCount(base)
        self.interval = DevicePerformance.current.frameInterval

        var ps: [ParticleData] = []
        // Use a seeded sequence so the layout is stable across re-renders
        for i in 0..<scaled {
            let seed = Double(i)
            ps.append(ParticleData(
                baseX:       molFract(sin(seed * 127.1) * 43758.5),
                baseY:       molFract(sin(seed * 311.7) * 43758.5),
                ampX:        0.025 + molFract(sin(seed * 19.3) * 7919) * 0.050,
                ampY:        0.025 + molFract(sin(seed * 47.9) * 7919) * 0.050,
                freqX:       0.10 + Double(molFract(sin(seed * 83.1) * 7919)) * 0.20,
                freqY:       0.10 + Double(molFract(sin(seed * 61.3) * 7919)) * 0.20,
                phaseX:      Double(molFract(sin(seed * 239.5) * 7919)) * 2 * .pi,
                phaseY:      Double(molFract(sin(seed * 151.3) * 7919)) * 2 * .pi,
                size:        2.0 + molFract(sin(seed * 109.7) * 7919) * 3.5,
                colorIndex:  Int(molFract(sin(seed * 73.1) * 7919) * 3),
                baseOpacity: 0.08 + molFract(sin(seed * 53.9) * 7919) * 0.18
            ))
        }
        self.particles = ps
    }

    // MARK: - Palette (matches new vibrant theme)
    private let particleColors: [Color] = [
        Color(red: 0.00, green: 0.831, blue: 0.667),  // #00D4AA vibrant emerald
        Color(red: 0.00, green: 0.941, blue: 1.00),   // #00F0FF electric teal
        Color(red: 1.00, green: 0.843, blue: 0.00),   // #FFD700 hot gold
    ]

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        if !reduceMotion && DevicePerformance.shouldRenderEffects {
            TimelineView(.animation(minimumInterval: interval, paused: false)) { timeline in
                let t = timeline.date.timeIntervalSinceReferenceDate
                Canvas { context, size in
                    renderScene(context: context, size: size, time: t)
                }
            }
            .allowsHitTesting(false)
            .accessibilityHidden(true)
        }
    }

    // MARK: - Rendering

    private func renderScene(context: GraphicsContext, size: CGSize, time: Double) {
        // 1. Compute current world positions for all particles
        let positions = particles.map { p -> CGPoint in
            let x = (p.baseX + p.ampX * CGFloat(sin(2 * .pi * p.freqX * time + p.phaseX))) * size.width
            let y = (p.baseY + p.ampY * CGFloat(sin(2 * .pi * p.freqY * time + p.phaseY))) * size.height
            return CGPoint(x: x, y: y)
        }

        let maxDist = min(size.width, size.height) * bondDistNorm

        // 2. Draw molecular bonds (lines between nearby particles)
        for i in 0..<positions.count {
            for j in (i + 1)..<positions.count {
                let dx = positions[i].x - positions[j].x
                let dy = positions[i].y - positions[j].y
                let dist = sqrt(dx * dx + dy * dy)
                guard dist < maxDist else { continue }

                let alpha = Double((1 - dist / maxDist) * 0.18)
                var path = Path()
                path.move(to: positions[i])
                path.addLine(to: positions[j])
                context.stroke(
                    path,
                    with: .color(.white.opacity(alpha)),
                    style: StrokeStyle(lineWidth: 0.5)
                )
            }
        }

        // 3. Draw particles (glow halo + core dot)
        for (idx, pos) in positions.enumerated() {
            let p = particles[idx]
            let color = particleColors[min(p.colorIndex, particleColors.count - 1)]
            let op = Double(p.baseOpacity)

            // Outer glow halo
            let haloD = p.size * 4.5
            context.fill(
                Path(ellipseIn: CGRect(x: pos.x - haloD / 2, y: pos.y - haloD / 2,
                                       width: haloD, height: haloD)),
                with: .color(color.opacity(op * 0.20))
            )

            // Mid ring
            let midD = p.size * 2.5
            context.fill(
                Path(ellipseIn: CGRect(x: pos.x - midD / 2, y: pos.y - midD / 2,
                                       width: midD, height: midD)),
                with: .color(color.opacity(op * 0.35))
            )

            // Core bright dot
            context.fill(
                Path(ellipseIn: CGRect(x: pos.x - p.size / 2, y: pos.y - p.size / 2,
                                       width: p.size, height: p.size)),
                with: .color(color.opacity(op))
            )
        }
    }

}

// MARK: - Golden Particle Burst
// One-shot radial burst of golden/teal/emerald particles.
// Trigger by flipping `active` from false → true.

struct GoldenParticleBurst: View {
    let active: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        if !reduceMotion && DevicePerformance.shouldRenderEffects {
            GeometryReader { geo in
                ZStack {
                    ForEach(0..<BurstParticle.count, id: \.self) { i in
                        BurstParticle(index: i, active: active, canvasSize: geo.size)
                    }
                }
            }
            .allowsHitTesting(false)
            .accessibilityHidden(true)
        }
    }

    private struct BurstParticle: View {
        static let count = 55

        let index: Int
        let active: Bool
        let canvasSize: CGSize

        @State private var offset: CGSize = .zero
        @State private var opacity: Double = 0
        @State private var particleScale: CGFloat = 0.1

        private let colors: [Color] = [
            Color(red: 1.00, green: 0.843, blue: 0.00),   // hot gold
            Color(red: 1.00, green: 0.92, blue: 0.40),    // light gold
            Color(red: 0.00, green: 0.831, blue: 0.667),  // vibrant emerald
            Color(red: 0.00, green: 0.941, blue: 1.00),   // electric teal
            Color.white,
        ]

        // Deterministic per-index values so preview is stable
        private var angle: Double   { Double(index) / Double(BurstParticle.count) * 360 }
        private var distance: CGFloat {
            let base: CGFloat = 100
            let extra = CGFloat(index % 5) * 26
            return base + extra
        }
        private var color: Color    { colors[index % colors.count] }
        private var size: CGFloat   { 4 + CGFloat(index % 5) * 2.5 }
        private var delay: Double   { Double(index) * 0.012 }

        var body: some View {
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .scaleEffect(particleScale)
                .opacity(opacity)
                .offset(offset)
                .position(x: canvasSize.width / 2, y: canvasSize.height / 2)
                .onChange(of: active) { _, newVal in
                    guard newVal else { return }
                    let rad = angle * .pi / 180
                    let dx = CGFloat(cos(rad)) * distance
                    let dy = CGFloat(sin(rad)) * distance
                    withAnimation(.easeOut(duration: 0.75).delay(delay)) {
                        offset = CGSize(width: dx, height: dy)
                        particleScale = 1.0
                        opacity = 1.0
                    }
                    withAnimation(.easeIn(duration: 0.55).delay(delay + 0.6)) {
                        opacity = 0
                        particleScale = 0.3
                    }
                }
        }
    }
}
