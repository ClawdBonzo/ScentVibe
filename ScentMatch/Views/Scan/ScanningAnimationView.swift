import SwiftUI

struct ScanningAnimationView: View {
    @State private var rotation: Double = 0
    @State private var pulse: Bool = false
    @State private var scanLine: CGFloat = 0
    @State private var particleOpacity: Double = 0

    var body: some View {
        ZStack {
            Color.smBackground.ignoresSafeArea()

            // Background particles
            ForEach(0..<20, id: \.self) { i in
                Circle()
                    .fill(Color.smEmerald.opacity(particleOpacity * Double.random(in: 0.2...0.6)))
                    .frame(width: CGFloat.random(in: 2...6))
                    .offset(
                        x: CGFloat.random(in: -150...150),
                        y: CGFloat.random(in: -300...300)
                    )
                    .animation(
                        .easeInOut(duration: Double.random(in: 1.5...3))
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.1),
                        value: particleOpacity
                    )
            }

            VStack(spacing: 32) {
                // Scanning ring
                ZStack {
                    // Outer ring
                    Circle()
                        .stroke(Color.smTeal.opacity(0.2), lineWidth: 2)
                        .frame(width: 160, height: 160)

                    // Scanning arc
                    Circle()
                        .trim(from: 0, to: 0.3)
                        .stroke(
                            LinearGradient.smPrimaryGradient,
                            style: StrokeStyle(lineWidth: 3, lineCap: .round)
                        )
                        .frame(width: 160, height: 160)
                        .rotationEffect(.degrees(rotation))

                    // Inner pulse
                    Circle()
                        .fill(Color.smEmerald.opacity(pulse ? 0.08 : 0.15))
                        .frame(width: pulse ? 130 : 110)

                    // Center icon
                    Image(systemName: "wand.and.stars")
                        .font(.system(size: 36, weight: .light))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.smEmerald, .smLightEmerald],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .scaleEffect(pulse ? 1.1 : 0.95)
                }

                VStack(spacing: 8) {
                    Text("Analyzing Your Vibe")
                        .font(SMFont.headline(20))
                        .foregroundStyle(Color.smTextPrimary)

                    Text("Detecting colors, mood & style...")
                        .font(SMFont.body(14))
                        .foregroundStyle(Color.smTextSecondary)
                }

                // Progress dots
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(Color.smEmerald)
                            .frame(width: 8, height: 8)
                            .opacity(scanLine > CGFloat(i) / 3.0 ? 1.0 : 0.3)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulse = true
            }
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                scanLine = 1.0
            }
            withAnimation(.easeIn(duration: 0.5)) {
                particleOpacity = 1.0
            }
        }
    }
}
