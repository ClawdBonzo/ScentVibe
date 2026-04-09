import SwiftUI

// MARK: - Premium Viral Share Card (1080×1920 @2x)
// Instagram / TikTok story template: molecular art, neon frame, hot-gold gradient.
// Renders to a static UIImage via ImageRenderer — all "animations" are fixed poses.

struct PremiumShareCardView: View {
    let matchResult: ScentMatchResult
    let topFragrance: Fragrance?
    let score: Double

    // True 9:16 story ratio — output at 1080×1920 @2x
    private let w: CGFloat = 540
    private let h: CGFloat = 960

    // ── New vibrant palette ──
    private let hotGold   = Color(red: 1.00, green: 0.843, blue: 0.00)  // #FFD700
    private let lightGold = Color(red: 1.00, green: 0.92,  blue: 0.40)
    private let emerald   = Color(red: 0.00, green: 0.831, blue: 0.667) // #00D4AA
    private let elecTeal  = Color(red: 0.00, green: 0.941, blue: 1.00)  // #00F0FF
    private let bgDark    = Color(red: 0.03, green: 0.05, blue: 0.07)
    private let surface   = Color(red: 0.06, green: 0.08, blue: 0.11)

    var body: some View {
        ZStack {
            photoBackground
            richGradientOverlay
            molecularArtLayer
            neonFrameAccents
            content
        }
        .frame(width: w, height: h)
        .clipped()
    }

    // MARK: - 1 · Blurred Photo Background

    private var photoBackground: some View {
        Group {
            if let data = matchResult.photoData, let ui = UIImage(data: data) {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
                    .frame(width: w, height: h)
                    .blur(radius: 48)
                    .scaleEffect(1.25)
                    .clipped()
                    .saturation(1.3)
                    .contrast(0.85)
            } else {
                bgDark
            }
        }
        .frame(width: w, height: h)
    }

    // MARK: - 2 · Multi-layer Gradient Overlay

    private var richGradientOverlay: some View {
        ZStack {
            // Primary dark overlay
            LinearGradient(
                stops: [
                    .init(color: Color(red: 0.00, green: 0.08, blue: 0.10).opacity(0.82), location: 0),
                    .init(color: bgDark.opacity(0.78), location: 0.40),
                    .init(color: bgDark.opacity(0.96), location: 1.0),
                ],
                startPoint: .top, endPoint: .bottom
            )

            // Emerald radial glow — upper zone
            RadialGradient(
                colors: [emerald.opacity(0.14), elecTeal.opacity(0.06), .clear],
                center: .init(x: 0.5, y: 0.18),
                startRadius: 0, endRadius: 260
            )

            // Hot gold radial glow — lower zone
            RadialGradient(
                colors: [hotGold.opacity(0.10), .clear],
                center: .init(x: 0.5, y: 0.82),
                startRadius: 0, endRadius: 220
            )
        }
    }

    // MARK: - 3 · Static Molecular Art Decoration

    private var molecularArtLayer: some View {
        ZStack {
            // Top-left molecular cluster
            molecularCluster(
                nodes: [
                    (x: 38, y: 82, size: 5, colorIdx: 0),
                    (x: 72, y: 55, size: 3.5, colorIdx: 1),
                    (x: 105, y: 90, size: 4, colorIdx: 2),
                    (x: 58, y: 118, size: 3, colorIdx: 0),
                    (x: 90, y: 130, size: 5, colorIdx: 1),
                ],
                bonds: [(0,1),(1,2),(0,3),(3,4),(2,4)],
                opacity: 0.55
            )

            // Bottom-right molecular cluster
            molecularCluster(
                nodes: [
                    (x: w - 45, y: h - 100, size: 5.5, colorIdx: 2),
                    (x: w - 80, y: h - 72,  size: 3.5, colorIdx: 0),
                    (x: w - 110, y: h - 105, size: 4.5, colorIdx: 1),
                    (x: w - 60, y: h - 140, size: 3,   colorIdx: 2),
                    (x: w - 95, y: h - 158, size: 4,   colorIdx: 0),
                ],
                bonds: [(0,1),(1,2),(0,3),(2,3),(3,4)],
                opacity: 0.50
            )

            // Top-right corner accent
            molecularCluster(
                nodes: [
                    (x: w - 35, y: 68,  size: 4,   colorIdx: 1),
                    (x: w - 65, y: 44,  size: 3,   colorIdx: 0),
                    (x: w - 55, y: 95,  size: 4.5, colorIdx: 2),
                ],
                bonds: [(0,1),(0,2)],
                opacity: 0.40
            )

            // Scattered accent dots — hot gold
            ForEach([
                (55.0, 420.0, 2.5),
                (w - 48.0, 380.0, 2.0),
                (w - 30.0, 520.0, 3.0),
                (32.0, 580.0, 2.0),
                (w / 2 + 150, h * 0.55, 2.5),
                (w / 2 - 170, h * 0.62, 2.0),
            ], id: \.0) { dot in
                Circle()
                    .fill(hotGold.opacity(0.45))
                    .frame(width: dot.2, height: dot.2)
                    .shadow(color: hotGold.opacity(0.7), radius: 5)
                    .position(x: dot.0, y: dot.1)
            }
        }
        .frame(width: w, height: h)
    }

    /// Renders a cluster of glowing nodes with connecting bond lines
    private func molecularCluster(
        nodes: [(x: CGFloat, y: CGFloat, size: CGFloat, colorIdx: Int)],
        bonds: [(Int, Int)],
        opacity: Double
    ) -> some View {
        let nodeColors: [Color] = [emerald, elecTeal, hotGold]

        return ZStack {
            // Bond lines
            ForEach(bonds.indices, id: \.self) { bi in
                let b = bonds[bi]
                let a = nodes[b.0]
                let bNode = nodes[b.1]
                Path { path in
                    path.move(to: CGPoint(x: a.x, y: a.y))
                    path.addLine(to: CGPoint(x: bNode.x, y: bNode.y))
                }
                .stroke(.white.opacity(opacity * 0.30), lineWidth: 0.6)
            }
            // Node glows
            ForEach(nodes.indices, id: \.self) { ni in
                let node = nodes[ni]
                let color = nodeColors[min(node.colorIdx, nodeColors.count - 1)]
                ZStack {
                    // Outer halo
                    Circle()
                        .fill(color.opacity(opacity * 0.25))
                        .frame(width: node.size * 4, height: node.size * 4)
                    // Core
                    Circle()
                        .fill(color.opacity(opacity))
                        .frame(width: node.size, height: node.size)
                }
                .shadow(color: color.opacity(opacity * 0.8), radius: 6)
                .position(x: node.x, y: node.y)
            }
        }
        .frame(width: w, height: h)
    }

    // MARK: - 4 · Neon Frame Accents

    private var neonFrameAccents: some View {
        ZStack {
            // Top neon line — emerald → teal
            LinearGradient(
                colors: [.clear, emerald.opacity(0.7), elecTeal.opacity(0.5), .clear],
                startPoint: .leading, endPoint: .trailing
            )
            .frame(width: w, height: 1.5)
            .position(x: w / 2, y: 1)
            .shadow(color: emerald.opacity(0.9), radius: 6)

            // Bottom neon line — gold
            LinearGradient(
                colors: [.clear, hotGold.opacity(0.8), lightGold.opacity(0.5), .clear],
                startPoint: .leading, endPoint: .trailing
            )
            .frame(width: w, height: 1.5)
            .position(x: w / 2, y: h - 1)
            .shadow(color: hotGold.opacity(0.9), radius: 6)

            // Left vertical accent
            LinearGradient(
                colors: [.clear, emerald.opacity(0.4), hotGold.opacity(0.25), .clear],
                startPoint: .top, endPoint: .bottom
            )
            .frame(width: 1, height: h)
            .position(x: 0, y: h / 2)

            // Right vertical accent
            LinearGradient(
                colors: [.clear, hotGold.opacity(0.4), emerald.opacity(0.25), .clear],
                startPoint: .top, endPoint: .bottom
            )
            .frame(width: 1, height: h)
            .position(x: w, y: h / 2)

            // Top-left corner bracket
            cornerBracket(flip: false)
                .position(x: 18, y: 18)

            // Top-right corner bracket
            cornerBracket(flip: true)
                .position(x: w - 18, y: 18)
        }
        .frame(width: w, height: h)
    }

    private func cornerBracket(flip: Bool) -> some View {
        ZStack {
            // Horizontal arm
            RoundedRectangle(cornerRadius: 1)
                .fill(LinearGradient(
                    colors: [hotGold, hotGold.opacity(0)],
                    startPoint: flip ? .trailing : .leading,
                    endPoint: flip ? .leading : .trailing
                ))
                .frame(width: 22, height: 1.5)
                .offset(x: flip ? -10 : 10, y: -8)
            // Vertical arm
            RoundedRectangle(cornerRadius: 1)
                .fill(LinearGradient(
                    colors: [hotGold, hotGold.opacity(0)],
                    startPoint: .top, endPoint: .bottom
                ))
                .frame(width: 1.5, height: 22)
                .offset(x: flip ? 8 : -8, y: -8 + 10)
        }
    }

    // MARK: - 5 · Content Stack

    private var content: some View {
        VStack(spacing: 0) {
            topBranding
                .padding(.top, 52)
                .padding(.horizontal, 36)

            Spacer().frame(height: 28)

            photoWindow
                .padding(.horizontal, 36)

            Spacer().frame(height: 24)

            fragranceBlock
                .padding(.horizontal, 36)

            Spacer().frame(height: 18)

            notesPreview
                .padding(.horizontal, 36)

            Spacer()

            ctaFooter
                .padding(.horizontal, 36)
                .padding(.bottom, 52)
        }
        .frame(width: w, height: h)
    }

    // MARK: – Top Branding

    private var topBranding: some View {
        HStack(spacing: 10) {
            // App icon placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(LinearGradient(
                    colors: [emerald, elecTeal],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                ))
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: "wand.and.stars")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                )
                .shadow(color: emerald.opacity(0.6), radius: 8)

            VStack(alignment: .leading, spacing: 1) {
                Text("ScentVibe AI")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.90))
                Text("Scent DNA Analysis")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(emerald.opacity(0.80))
                    .tracking(0.5)
            }

            Spacer()

            // Vibe score pill
            HStack(spacing: 5) {
                Text("VIBE")
                    .font(.system(size: 8, weight: .bold))
                    .tracking(1.5)
                    .foregroundStyle(hotGold)
                Text(String(format: "%.0f", matchResult.vibeScore))
                    .font(.system(size: 14, weight: .black, design: .monospaced))
                    .foregroundStyle(hotGold)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Capsule().fill(surface.opacity(0.55)))
            .overlay(Capsule().stroke(hotGold.opacity(0.35), lineWidth: 0.8))
            .shadow(color: hotGold.opacity(0.4), radius: 8)
        }
    }

    // MARK: – Photo Window with Neon Frame

    private var photoWindow: some View {
        Group {
            if let data = matchResult.photoData, let ui = UIImage(data: data) {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
                    .frame(width: w - 72, height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    // Neon photo frame — hot gold → electric teal
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        hotGold.opacity(0.80),
                                        emerald.opacity(0.60),
                                        elecTeal.opacity(0.40),
                                        hotGold.opacity(0.20)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .overlay(
                        VStack {
                            Spacer()
                            LinearGradient(colors: [.clear, bgDark.opacity(0.65)],
                                           startPoint: .top, endPoint: .bottom)
                            .frame(height: 65)
                            .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 18, bottomTrailingRadius: 18))
                        }
                    )
                    .shadow(color: hotGold.opacity(0.28), radius: 20, y: 6)
                    .shadow(color: emerald.opacity(0.20), radius: 30, y: 4)
            }
        }
    }

    // MARK: – Fragrance Info Block

    @ViewBuilder
    private var fragranceBlock: some View {
        if let frag = topFragrance {
            VStack(spacing: 12) {
                // "MY SIGNATURE SCENT" label
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(hotGold)
                    Text("MY SIGNATURE SCENT")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(3.0)
                        .foregroundStyle(hotGold)
                    Image(systemName: "sparkles")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(hotGold)
                }
                .shadow(color: hotGold.opacity(0.6), radius: 8)

                // Fragrance name — big, serif
                Text(frag.name)
                    .font(.system(size: 36, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.30), radius: 8, y: 2)

                Text("by \(frag.house)")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.48))

                matchBadge

                moodPills
            }
        }
    }

    // MARK: – Match Badge

    private var matchBadge: some View {
        HStack(spacing: 12) {
            // Score ring
            ZStack {
                Circle()
                    .stroke(.white.opacity(0.08), lineWidth: 2.5)
                    .frame(width: 44, height: 44)
                Circle()
                    .trim(from: 0, to: score)
                    .stroke(
                        LinearGradient(
                            colors: [hotGold, emerald, elecTeal],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                    )
                    .frame(width: 44, height: 44)
                    .rotationEffect(.degrees(-90))
                    .shadow(color: hotGold.opacity(0.6), radius: 6)
                Text(String(format: "%.0f", score * 100))
                    .font(.system(size: 14, weight: .black, design: .monospaced))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("MATCH SCORE")
                    .font(.system(size: 8, weight: .bold))
                    .tracking(2)
                    .foregroundStyle(hotGold)
                Text(matchLabel)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.90))
            }

            Spacer()

            // DNA helix accent
            VStack(spacing: 3) {
                ForEach(0..<4, id: \.self) { i in
                    HStack(spacing: CGFloat(i % 2 == 0 ? 4 : 8)) {
                        Circle().fill(emerald.opacity(0.7)).frame(width: 3, height: 3)
                        Circle().fill(hotGold.opacity(0.7)).frame(width: 3, height: 3)
                    }
                }
            }
            .shadow(color: emerald.opacity(0.5), radius: 4)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 11)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(surface.opacity(0.50))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    LinearGradient(
                        colors: [hotGold.opacity(0.35), emerald.opacity(0.20), .clear],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.8
                )
        )
        .shadow(color: hotGold.opacity(0.18), radius: 16, y: 4)
    }

    // MARK: – Mood Pills

    private var moodPills: some View {
        HStack(spacing: 7) {
            ForEach(matchResult.detectedMoodTags.prefix(3), id: \.self) { mood in
                Text(mood)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.88))
                    .padding(.horizontal, 13)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(surface.opacity(0.40)))
                    .overlay(Capsule().stroke(emerald.opacity(0.28), lineWidth: 0.6))
            }
        }
    }

    // MARK: – Notes Preview

    @ViewBuilder
    private var notesPreview: some View {
        if let frag = topFragrance {
            HStack(spacing: 0) {
                noteColumn("TOP", notes: frag.topNotes.prefix(2).joined(separator: " · "), color: emerald)
                    .frame(maxWidth: .infinity)
                Divider().background(.white.opacity(0.08)).frame(height: 32)
                noteColumn("HEART", notes: frag.heartNotes.prefix(2).joined(separator: " · "), color: hotGold)
                    .frame(maxWidth: .infinity)
                Divider().background(.white.opacity(0.08)).frame(height: 32)
                noteColumn("BASE", notes: frag.baseNotes.prefix(2).joined(separator: " · "), color: elecTeal)
                    .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(surface.opacity(0.38))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        LinearGradient(
                            colors: [hotGold.opacity(0.18), emerald.opacity(0.10), .clear],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.6
                    )
            )
        }
    }

    private func noteColumn(_ label: String, notes: String, color: Color) -> some View {
        VStack(spacing: 3) {
            Text(label)
                .font(.system(size: 8, weight: .bold))
                .tracking(1.5)
                .foregroundStyle(color)
                .shadow(color: color.opacity(0.6), radius: 4)
            Text(notes.isEmpty ? "–" : notes)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.white.opacity(0.72))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
    }

    // MARK: – CTA Footer

    private var ctaFooter: some View {
        VStack(spacing: 14) {
            // Neon divider
            Rectangle()
                .fill(LinearGradient(
                    colors: [.clear, hotGold.opacity(0.45), emerald.opacity(0.35), .clear],
                    startPoint: .leading, endPoint: .trailing
                ))
                .frame(height: 1)
                .shadow(color: hotGold.opacity(0.4), radius: 6)

            // CTA pill — vibrant gradient
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.system(size: 12, weight: .bold))
                Text("Find Your Scent DNA")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundStyle(Color(red: 0.05, green: 0.05, blue: 0.05))
            .padding(.horizontal, 28)
            .padding(.vertical, 13)
            .background(
                Capsule()
                    .fill(LinearGradient(
                        colors: [hotGold, lightGold, emerald],
                        startPoint: .leading, endPoint: .trailing
                    ))
            )
            .shadow(color: hotGold.opacity(0.45), radius: 16, y: 4)
            .shadow(color: emerald.opacity(0.25), radius: 22, y: 4)

            Text("ScentVibe AI • Available on the App Store")
                .font(.system(size: 9, weight: .medium))
                .foregroundStyle(.white.opacity(0.25))
                .tracking(0.3)
        }
    }

    // MARK: – Helpers

    private var matchLabel: String {
        let pct = score * 100
        switch pct {
        case 85...: return "Perfect Match"
        case 70..<85: return "Exceptional"
        case 55..<70: return "Strong Match"
        default: return "Good Match"
        }
    }
}

// MARK: - Share Card Generator

struct ShareCardGenerator {
    @MainActor
    static func render(matchResult: ScentMatchResult, topFragrance: Fragrance?, score: Double) -> UIImage? {
        let view = PremiumShareCardView(
            matchResult: matchResult,
            topFragrance: topFragrance,
            score: score
        )
        .environment(\.colorScheme, .dark)

        let renderer = ImageRenderer(content: view)
        renderer.scale = 2.0  // → 1080×1920 output
        return renderer.uiImage
    }
}
