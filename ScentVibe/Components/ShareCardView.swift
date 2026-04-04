import SwiftUI

// MARK: - Premium Share Story Card (1080×1920 @ 2x)
/// Luxury perfume-house aesthetic story card for Instagram/TikTok sharing.
/// Blurred photo backdrop · deep teal gradient · glass-morphism badges · CTA.

struct PremiumShareCardView: View {
    let matchResult: ScentMatchResult
    let topFragrance: Fragrance?
    let score: Double

    // True 9:16 story ratio — renders at 1080×1920 @2x
    private let w: CGFloat = 540
    private let h: CGFloat = 960

    // ── Palette ──
    private let emerald   = Color(red: 0.00, green: 0.78, blue: 0.33)
    private let neon      = Color(red: 0.22, green: 1.00, blue: 0.08)
    private let deepTeal  = Color(red: 0.04, green: 0.15, blue: 0.15)
    private let bgDark    = Color(red: 0.03, green: 0.05, blue: 0.07)
    private let surface   = Color(red: 0.06, green: 0.08, blue: 0.11)
    private let gold      = Color(red: 0.88, green: 0.75, blue: 0.35)

    var body: some View {
        ZStack {
            photoBackground
            gradientOverlay
            ambientGlows
            content
        }
        .frame(width: w, height: h)
        .clipped()
    }

    // MARK: - 1 · Blurred Photo Background

    private var photoBackground: some View {
        Group {
            if let data = matchResult.photoData,
               let ui = UIImage(data: data) {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
                    .frame(width: w, height: h)
                    .blur(radius: 44)
                    .scaleEffect(1.2)
                    .clipped()
            } else {
                bgDark
            }
        }
        .frame(width: w, height: h)
    }

    // MARK: - 2 · Teal / Dark Gradient Overlay

    private var gradientOverlay: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: deepTeal.opacity(0.72), location: 0),
                    .init(color: bgDark.opacity(0.82),   location: 0.45),
                    .init(color: bgDark.opacity(0.94),   location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            // Subtle emerald radial behind centre content
            RadialGradient(
                colors: [emerald.opacity(0.07), .clear],
                center: .init(x: 0.5, y: 0.62),
                startRadius: 10,
                endRadius: 280
            )
        }
    }

    // MARK: - 3 · Ambient Bokeh Glows

    private var ambientGlows: some View {
        ZStack {
            Circle()
                .fill(RadialGradient(colors: [Color(red: 0.06, green: 0.32, blue: 0.32).opacity(0.22), .clear],
                                     center: .center, startRadius: 0, endRadius: 180))
                .frame(width: 360, height: 360)
                .offset(x: -160, y: -300)

            Circle()
                .fill(RadialGradient(colors: [emerald.opacity(0.08), .clear],
                                     center: .center, startRadius: 0, endRadius: 150))
                .frame(width: 300, height: 300)
                .offset(x: 140, y: 280)
        }
    }

    // MARK: - 4 · Content Stack

    private var content: some View {
        VStack(spacing: 0) {
            // ── Top branding ──
            topBranding
                .padding(.top, 52)
                .padding(.horizontal, 40)

            Spacer().frame(height: 32)

            // ── Photo window ──
            photoWindow
                .padding(.horizontal, 40)

            Spacer().frame(height: 28)

            // ── Fragrance block ──
            fragranceBlock
                .padding(.horizontal, 40)

            Spacer().frame(height: 20)

            // ── Notes preview ──
            notesPreview
                .padding(.horizontal, 40)

            Spacer()

            // ── CTA footer ──
            ctaFooter
                .padding(.horizontal, 40)
                .padding(.bottom, 52)
        }
        .frame(width: w, height: h)
    }

    // MARK: – Top Branding

    private var topBranding: some View {
        HStack(spacing: 10) {
            if let icon = UIImage(named: "AppIcon") {
                Image(uiImage: icon)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(RoundedRectangle(cornerRadius: 7))
            } else {
                RoundedRectangle(cornerRadius: 7)
                    .fill(LinearGradient(colors: [emerald, Color(red: 0.06, green: 0.32, blue: 0.32)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 30, height: 30)
                    .overlay(
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                    )
            }

            Text("ScentVibe AI")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.80))

            Spacer()

            // Vibe score pill
            Text(String(format: "VIBE %.0f", matchResult.vibeScore))
                .font(.system(size: 10, weight: .bold))
                .tracking(1.5)
                .foregroundStyle(emerald)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Capsule().fill(surface.opacity(0.6)))
                .overlay(Capsule().stroke(emerald.opacity(0.2), lineWidth: 0.5))
        }
    }

    // MARK: – Photo Window

    private var photoWindow: some View {
        Group {
            if let data = matchResult.photoData,
               let ui = UIImage(data: data) {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
                    .frame(width: w - 80, height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(colors: [.white.opacity(0.14), emerald.opacity(0.18), .clear],
                                               startPoint: .topLeading, endPoint: .bottomTrailing),
                                lineWidth: 1
                            )
                    )
                    .overlay(
                        VStack {
                            Spacer()
                            LinearGradient(colors: [.clear, bgDark.opacity(0.6)],
                                           startPoint: .top, endPoint: .bottom)
                            .frame(height: 70)
                            .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 20, bottomTrailingRadius: 20))
                        }
                    )
                    .shadow(color: .black.opacity(0.45), radius: 28, y: 8)
            }
        }
    }

    // MARK: – Fragrance Info

    @ViewBuilder
    private var fragranceBlock: some View {
        if let frag = topFragrance {
            VStack(spacing: 12) {
                Text("YOUR SCENT MATCH")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(3.5)
                    .foregroundStyle(emerald)

                Text(frag.name)
                    .font(.system(size: 34, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.25), radius: 6, y: 2)

                Text("by \(frag.house)")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.50))

                matchBadge

                moodPills
            }
        }
    }

    // MARK: – Glass Match Badge

    private var matchBadge: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(.white.opacity(0.06), lineWidth: 2.5)
                    .frame(width: 42, height: 42)
                Circle()
                    .trim(from: 0, to: score)
                    .stroke(
                        LinearGradient(colors: [emerald, neon], startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                    )
                    .frame(width: 42, height: 42)
                    .rotationEffect(.degrees(-90))
                Text(String(format: "%.0f", score * 100))
                    .font(.system(size: 15, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 1) {
                Text("MATCH")
                    .font(.system(size: 9, weight: .bold))
                    .tracking(2)
                    .foregroundStyle(emerald)
                Text(matchLabel)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.80))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 11)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(surface.opacity(0.55))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    LinearGradient(colors: [.white.opacity(0.10), emerald.opacity(0.12), .clear],
                                   startPoint: .topLeading, endPoint: .bottomTrailing),
                    lineWidth: 0.5
                )
        )
        .shadow(color: emerald.opacity(0.12), radius: 16, y: 4)
    }

    // MARK: – Mood Pills

    private var moodPills: some View {
        HStack(spacing: 8) {
            ForEach(matchResult.detectedMoodTags.prefix(3), id: \.self) { mood in
                Text(mood)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.85))
                    .padding(.horizontal, 13)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().fill(surface.opacity(0.45))
                    )
                    .overlay(
                        Capsule().stroke(emerald.opacity(0.22), lineWidth: 0.5)
                    )
            }
        }
    }

    // MARK: – Notes Preview

    @ViewBuilder
    private var notesPreview: some View {
        if let frag = topFragrance {
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "triangle.fill")
                        .font(.system(size: 8))
                        .foregroundStyle(emerald)
                    Text("FRAGRANCE NOTES")
                        .font(.system(size: 9, weight: .bold))
                        .tracking(2)
                        .foregroundStyle(.white.opacity(0.5))
                }

                HStack(spacing: 16) {
                    noteColumn("TOP", notes: frag.topNotes.prefix(2).joined(separator: ", "), color: emerald)
                    noteColumn("HEART", notes: frag.heartNotes.prefix(2).joined(separator: ", "), color: gold)
                    noteColumn("BASE", notes: frag.baseNotes.prefix(2).joined(separator: ", "), color: Color(red: 0.06, green: 0.32, blue: 0.32))
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(surface.opacity(0.4))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white.opacity(0.06), lineWidth: 0.5)
            )
        }
    }

    private func noteColumn(_ label: String, notes: String, color: Color) -> some View {
        VStack(spacing: 3) {
            Text(label)
                .font(.system(size: 8, weight: .bold))
                .tracking(1.5)
                .foregroundStyle(color)
            Text(notes)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: – CTA Footer

    private var ctaFooter: some View {
        VStack(spacing: 14) {
            Rectangle()
                .fill(LinearGradient(colors: [.clear, emerald.opacity(0.25), .clear],
                                     startPoint: .leading, endPoint: .trailing))
                .frame(height: 0.5)

            HStack(spacing: 7) {
                Image(systemName: "arrow.down.app.fill")
                    .font(.system(size: 13, weight: .semibold))
                Text("Try ScentVibe AI")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                Image(systemName: "arrow.right")
                    .font(.system(size: 11, weight: .bold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 26)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(LinearGradient(colors: [emerald, Color(red: 0.06, green: 0.32, blue: 0.32)],
                                         startPoint: .leading, endPoint: .trailing))
            )
            .shadow(color: emerald.opacity(0.28), radius: 14, y: 4)

            Text("Available on the App Store")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.white.opacity(0.28))
        }
    }

    // MARK: – Helpers

    private var matchLabel: String {
        let pct = score * 100
        switch pct {
        case 80...: return "Exceptional"
        case 60..<80: return "Strong Match"
        case 40..<60: return "Good Match"
        default: return "Interesting"
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
