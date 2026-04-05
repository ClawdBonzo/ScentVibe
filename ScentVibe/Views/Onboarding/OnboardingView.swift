import SwiftUI
import PhotosUI

// ╔══════════════════════════════════════════════════════════════════════╗
// ║  ScentVibe Cinematic Onboarding — 4 Screens + Flow Container       ║
// ║  Dark luxury: #0A1F1F → #0F3D3D, gold #D4AF77, serif headlines     ║
// ║  Perf: Canvas particles batched, drawsGroup for compositing,       ║
// ║        phaseAnimator for GPU-driven loops, 120 fps target           ║
// ║  Accessibility: Reduce Motion respected, VoiceOver labels on all   ║
// ╚══════════════════════════════════════════════════════════════════════╝

// MARK: - Palette

private let luxBlack     = Color(red: 0.031, green: 0.047, blue: 0.047)
private let luxDeepTeal  = Color(red: 0.039, green: 0.122, blue: 0.122)
private let luxTeal      = Color(red: 0.059, green: 0.239, blue: 0.239)
private let luxGold      = Color(red: 0.831, green: 0.686, blue: 0.467)
private let luxGoldLight = Color(red: 0.910, green: 0.812, blue: 0.627)
private let luxEmerald   = Color(red: 0.200, green: 0.651, blue: 0.451)
private let luxTextPri   = Color(red: 0.949, green: 0.949, blue: 0.933)
private let luxTextSec   = Color(red: 0.541, green: 0.604, blue: 0.604)
private let luxSurface   = Color(red: 0.055, green: 0.102, blue: 0.102)

// MARK: - MoleculeParticleView (TimelineView + Canvas, motion-aware)
// Respects iOS Reduce Motion. When enabled, renders static dim dots instead
// of animated Canvas to eliminate all motion for accessibility.

private struct MoleculeParticleView: View {
    var color: Color = luxGold
    var count: Int = 25

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct P {
        let x, y, size, speed, phase, orbitR: CGFloat
        let opacity: Double
    }

    @State private var particles: [P]
    private let tier = DevicePerformance.current
    private let effectiveCount: Int

    init(color: Color = luxGold, count: Int = 25) {
        self.color = color
        self.count = count
        let scaled = DevicePerformance.scaledCount(count)
        self.effectiveCount = scaled
        _particles = State(initialValue: (0..<scaled).map { _ in
            P(x: .random(in: 0...1), y: .random(in: 0...1),
              size: .random(in: 1.5...5), speed: .random(in: 0.2...0.8),
              phase: .random(in: 0...(.pi * 2)), orbitR: .random(in: 10...30),
              opacity: .random(in: 0.08...0.35))
        })
    }

    var body: some View {
        if reduceMotion || !DevicePerformance.shouldRenderEffects {
            // Static fallback: subtle fixed dots, no animation overhead
            Canvas { ctx, sz in
                for p in particles {
                    let x = p.x * sz.width
                    let y = p.y * sz.height
                    ctx.opacity = p.opacity * 0.5
                    ctx.fill(Circle().path(in: CGRect(x: x - p.size / 2, y: y - p.size / 2,
                                                      width: p.size, height: p.size)),
                             with: .color(color))
                }
            }
        } else {
            TimelineView(.animation(minimumInterval: tier.frameInterval)) { tl in
                Canvas { ctx, sz in
                    let t = tl.date.timeIntervalSinceReferenceDate
                    for p in particles {
                        let bx = p.x * sz.width
                        let by = p.y * sz.height
                        let ox = bx + sin(t * Double(p.speed) + Double(p.phase)) * Double(p.orbitR)
                        let oy = by + cos(t * Double(p.speed) * 0.7 + Double(p.phase)) * Double(p.orbitR)
                        let pulse = 0.6 + 0.4 * sin(t * 1.8 + Double(p.phase))

                        // Skip glow pass on low-tier devices for better perf
                        if tier >= .mid {
                            let gs = p.size * 4
                            ctx.opacity = p.opacity * 0.25 * pulse
                            ctx.fill(Circle().path(in: CGRect(x: ox - gs / 2, y: oy - gs / 2, width: gs, height: gs)),
                                     with: .color(color))
                        }

                        ctx.opacity = p.opacity * pulse
                        ctx.fill(Circle().path(in: CGRect(x: ox - p.size / 2, y: oy - p.size / 2,
                                                          width: p.size, height: p.size)),
                                 with: .color(color))
                    }
                }
            }
            .drawingGroup()
        }
    }
}

// MARK: - AuraRing

private struct AuraRing: View {
    var diameter: CGFloat
    var color: Color = luxGold
    var lineWidth: CGFloat = 1
    var blurRadius: CGFloat = 6

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pulse = false

    private var effectiveBlur: CGFloat {
        min(blurRadius, DevicePerformance.current.maxBlurRadius)
    }

    var body: some View {
        if reduceMotion || !DevicePerformance.shouldRenderEffects {
            // Static ring: no animation, no blur for minimal GPU cost
            Circle()
                .stroke(color.opacity(0.12), lineWidth: lineWidth)
                .frame(width: diameter, height: diameter)
                .accessibilityHidden(true)
        } else {
            Circle()
                .stroke(color.opacity(pulse ? 0.08 : 0.18), lineWidth: lineWidth)
                .frame(width: diameter, height: diameter)
                .blur(radius: effectiveBlur)
                .scaleEffect(pulse ? 1.06 : 0.96)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                        pulse = true
                    }
                }
                .drawingGroup()
                .accessibilityHidden(true)
        }
    }
}

// MARK: - ShimmerSweep

private struct ShimmerSweep: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var offset: CGFloat = -200

    var body: some View {
        if reduceMotion || !DevicePerformance.shouldRenderEffects {
            Color.clear
        } else {
            GeometryReader { geo in
                Rectangle()
                    .fill(LinearGradient(colors: [.clear, .white.opacity(0.12), .clear],
                                         startPoint: .leading, endPoint: .trailing))
                    .frame(width: 80)
                    .offset(x: offset)
                    .onAppear {
                        withAnimation(.linear(duration: 2.8).repeatForever(autoreverses: false)) {
                            offset = geo.size.width + 200
                        }
                    }
            }
            .allowsHitTesting(false)
            .drawingGroup()
            .accessibilityHidden(true)
        }
    }
}

// MARK: - LuxuryBackground

private struct LuxuryBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [luxBlack, luxDeepTeal.opacity(0.5), luxBlack],
                           startPoint: .top, endPoint: .bottom)
            RadialGradient(colors: [luxTeal.opacity(0.15), .clear],
                           center: .center, startRadius: 50, endRadius: 400)
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}

// MARK: - Progress Indicator

private struct OnboardingProgress: View {
    let current: Int
    let total: Int = 4

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { i in
                Capsule()
                    .fill(i == current ? luxGold : luxTextSec.opacity(0.25))
                    .frame(width: i == current ? 22 : 6, height: 4)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: current)
            }
        }
        .padding(.top, 16)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Onboarding progress: step \(current + 1) of \(total)")
        .accessibilityHint(current < total - 1
            ? "Swipe or tap Continue to advance to step \(current + 2)"
            : "Final step")
    }
}

// MARK: - Screen 1: Welcome & Interactive Photo Demo

struct OnboardingScreen1: View {
    @Binding var currentPage: Int
    @Binding var demoMood: String
    @Binding var demoScore: Int
    var animation: Namespace.ID

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showContent = false
    @State private var isScanning = false
    @State private var showResult = false
    @State private var scanAngle: Double = 0
    @State private var resultScale: CGFloat = 0.3

    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?

    var body: some View {
        ZStack {
            LuxuryBackground()
            MoleculeParticleView(color: luxGold, count: 20)
                .ignoresSafeArea()
                .accessibilityHidden(true)

            VStack(spacing: 0) {
                OnboardingProgress(current: 0)

                Spacer()

                VStack(spacing: 14) {
                    Text("Your Scent,\nDecoded")
                        .font(.system(size: 38, weight: .bold, design: .serif))
                        .foregroundStyle(luxTextPri)
                        .multilineTextAlignment(.center)

                    Text("Pick a photo — we'll match your fragrance in seconds.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(luxTextSec)
                        .multilineTextAlignment(.center)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 24)
                .padding(.horizontal, 32)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Your Scent, Decoded. Pick a photo and we'll match your fragrance in seconds.")

                Spacer().frame(height: 36)

                // ── Photo interaction area ──
                ZStack {
                    AuraRing(diameter: 280, color: luxGold, blurRadius: 10)
                    AuraRing(diameter: 220, color: luxTeal, blurRadius: 6)

                    Group {
                        if let img = selectedImage {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 160, height: 160)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(RadialGradient(colors: [luxTeal.opacity(0.5), luxDeepTeal],
                                                     center: .center, startRadius: 20, endRadius: 80))
                                .frame(width: 160, height: 160)
                                .overlay(
                                    Image(systemName: isScanning ? "wand.and.stars" : "camera.fill")
                                        .font(.system(size: 42, weight: .ultraLight))
                                        .foregroundStyle(luxGold.opacity(0.8))
                                )
                        }
                    }
                    .overlay(Circle().stroke(luxGold.opacity(0.15), lineWidth: 1).blur(radius: 5))
                    .phaseAnimator(reduceMotion ? [false] : [false, true]) { content, phase in
                        content.scaleEffect(reduceMotion ? 1.0 : (phase ? 1.03 : 0.97))
                    } animation: { _ in .easeInOut(duration: 3) }
                    .matchedGeometryEffect(id: "photoOrb", in: animation)
                    .accessibilityLabel(selectedImage != nil ? "Your selected photo" : "Photo placeholder")
                    .accessibilityHint("Tap to run a demo scent scan")

                    if isScanning {
                        Circle()
                            .trim(from: 0, to: 0.7)
                            .stroke(
                                AngularGradient(colors: [luxGold, luxEmerald, luxGold.opacity(0)],
                                                center: .center),
                                style: StrokeStyle(lineWidth: 3, lineCap: .round)
                            )
                            .frame(width: 185, height: 185)
                            .rotationEffect(.degrees(scanAngle))
                    }

                    if showResult {
                        resultCard
                            .matchedGeometryEffect(id: "matchCard", in: animation)
                            .offset(y: 130)
                            .scaleEffect(resultScale)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .frame(height: 320)
                .contentShape(Rectangle())
                .onTapGesture {
                    guard !isScanning, !showResult else { return }
                    startScan()
                }

                // Action row: PhotosPicker + "Use Demo Photo" + tap hint
                if !isScanning && !showResult {
                    VStack(spacing: 10) {
                        HStack(spacing: 12) {
                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                HStack(spacing: 6) {
                                    Image(systemName: "photo.on.rectangle")
                                        .font(.system(size: 13))
                                    Text("Choose Photo")
                                        .font(.system(size: 13, weight: .medium))
                                }
                                .foregroundStyle(luxGold)
                                .padding(.horizontal, 14).padding(.vertical, 8)
                                .background(luxGold.opacity(0.1))
                                .clipShape(Capsule())
                            }
                            .accessibilityLabel("Choose a photo from your library")
                            .accessibilityHint("Opens your photo library to select a photo for scent analysis")

                            Text("or")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(luxTextSec.opacity(0.4))

                            Button(action: startScan) {
                                HStack(spacing: 6) {
                                    Image(systemName: "wand.and.stars")
                                        .font(.system(size: 13))
                                    Text("Use Demo")
                                        .font(.system(size: 13, weight: .medium))
                                }
                                .foregroundStyle(luxEmerald)
                                .padding(.horizontal, 14).padding(.vertical, 8)
                                .background(luxEmerald.opacity(0.1))
                                .clipShape(Capsule())
                            }
                            .accessibilityLabel("Use demo photo")
                            .accessibilityHint("Runs a demo scan without needing photo library access")
                        }
                    }
                    .opacity(showContent ? 1 : 0)
                    .padding(.top, 8)
                }

                Spacer()

                luxButton("Continue", icon: "arrow.right") {
                    advancePage(to: 1)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) { showContent = true }
        }
        .onChange(of: selectedItem) { _, newItem in
            guard let newItem else { return }
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let img = UIImage(data: data) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedImage = img
                    }
                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                    try? await Task.sleep(nanoseconds: 400_000_000)
                    startScan()
                }
            }
        }
    }

    private var resultCard: some View {
        VStack(spacing: 8) {
            Text("TOM FORD").font(.system(size: 10, weight: .semibold)).tracking(2)
                .foregroundStyle(luxTextSec)
            Text("Tobacco Vanille").font(.system(size: 17, weight: .semibold, design: .serif))
                .foregroundStyle(luxTextPri)
            HStack(spacing: 5) {
                Image(systemName: "sparkle").font(.system(size: 10))
                Text("98% Vibe Match").font(.system(size: 12, weight: .semibold))
            }
            .foregroundStyle(luxGold)
            HStack(spacing: 6) {
                ForEach(["Tobacco", "Vanilla", "Amber"], id: \.self) { note in
                    Text(note).font(.system(size: 9, weight: .medium))
                        .foregroundStyle(luxTextPri.opacity(0.8))
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(luxTeal.opacity(0.5))
                        .clipShape(Capsule())
                }
            }
        }
        .padding(18)
        .background(.ultraThinMaterial.opacity(0.3))
        .background(luxSurface.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(luxGold.opacity(0.2), lineWidth: 0.5))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Match result: Tom Ford Tobacco Vanille, 98% vibe match")
    }

    private func startScan() {
        guard !isScanning else { return }
        isScanning = true
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        if reduceMotion {
            // Skip spinning animation; show result immediately
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isScanning = false
                demoMood = selectedImage != nil ? "Your Style" : "Bold & Mysterious"
                demoScore = 41
                showResult = true
                resultScale = 1.0
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        } else {
            withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) { scanAngle = 360 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                isScanning = false
                scanAngle = 0
                demoMood = selectedImage != nil ? "Your Style" : "Bold & Mysterious"
                demoScore = 41
                withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                    showResult = true
                    resultScale = 1.0
                }
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                }
            }
        }
    }

    private func advancePage(to page: Int) {
        var tx = Transaction(animation: .spring(response: 0.5, dampingFraction: 0.85))
        tx.disablesAnimations = false
        withTransaction(tx) { currentPage = page }
    }
}

// MARK: - Screen 2: AI Analysis Animation

struct OnboardingScreen2: View {
    @Binding var currentPage: Int
    var animation: Namespace.ID

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showContent = false
    @State private var stepDone: [Bool] = [false, false, false]
    @State private var orbRot: Double = 0

    private let steps: [(icon: String, title: String, sub: String)] = [
        ("eye.fill",                  "Vision Analysis",  "Reading colors, textures & mood"),
        ("brain.head.profile.fill",   "AI Matching",      "Mapping your scent signature"),
        ("person.crop.circle.fill",   "Personalization",  "Tuning to your style DNA"),
    ]

    var body: some View {
        ZStack {
            LuxuryBackground()
            MoleculeParticleView(color: luxEmerald.opacity(0.6), count: 15)
                .ignoresSafeArea()
                .accessibilityHidden(true)

            VStack(spacing: 0) {
                OnboardingProgress(current: 1)

                Spacer()

                VStack(spacing: 12) {
                    Text("Powered by\nAdvanced AI")
                        .font(.system(size: 34, weight: .bold, design: .serif))
                        .foregroundStyle(luxTextPri)
                        .multilineTextAlignment(.center)

                    Text("Three layers of intelligence, one perfect match.")
                        .font(.system(size: 16)).foregroundStyle(luxTextSec)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Powered by Advanced AI. Three layers of intelligence, one perfect match.")

                Spacer().frame(height: 32)

                ZStack {
                    ForEach(0..<3, id: \.self) { i in
                        let orbColors: [Color] = [luxEmerald, luxGold, luxEmerald.opacity(0.6)]
                        Circle()
                            .stroke(luxEmerald.opacity(0.06 + Double(i) * 0.04), lineWidth: 1)
                            .frame(width: CGFloat(80 + i * 40), height: CGFloat(80 + i * 40))
                            .rotationEffect(reduceMotion ? .zero : .degrees(orbRot * (i % 2 == 0 ? 1 : -1)))

                        Circle().fill(orbColors[i]).frame(width: 6, height: 6)
                            .offset(x: CGFloat(40 + i * 20))
                            .rotationEffect(reduceMotion ? .zero : .degrees(orbRot * (i % 2 == 0 ? 1 : -1)))
                    }

                    Circle().fill(RadialGradient(colors: [luxEmerald.opacity(0.25), .clear],
                                                 center: .center, startRadius: 5, endRadius: 35))
                        .frame(width: 70, height: 70)

                    Image(systemName: "brain")
                        .font(.system(size: 28, weight: .ultraLight))
                        .foregroundStyle(luxEmerald)
                        .matchedGeometryEffect(id: "brainIcon", in: animation)
                        .phaseAnimator(reduceMotion ? [false] : [false, true]) { c, p in
                            c.scaleEffect(reduceMotion ? 1.0 : (p ? 1.08 : 0.94))
                                .opacity(reduceMotion ? 1 : (p ? 1 : 0.7))
                        } animation: { _ in .easeInOut(duration: 2.5) }
                        .accessibilityLabel("AI brain icon")
                }
                .frame(height: 180)
                .drawingGroup()

                Spacer().frame(height: 28)

                VStack(spacing: 14) {
                    ForEach(Array(steps.enumerated()), id: \.offset) { i, step in
                        HStack(spacing: 14) {
                            ZStack {
                                Circle().fill(stepDone[i] ? luxEmerald : luxSurface)
                                    .frame(width: 40, height: 40)
                                if stepDone[i] {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundStyle(luxBlack)
                                        .transition(.scale)
                                } else {
                                    Image(systemName: step.icon)
                                        .font(.system(size: 16)).foregroundStyle(luxTextSec)
                                }
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(step.title).font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(stepDone[i] ? luxTextPri : luxTextSec)
                                Text(step.sub).font(.system(size: 12))
                                    .foregroundStyle(luxTextSec.opacity(0.6))
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 32)
                        .opacity(showContent ? 1 : 0)
                        .offset(x: showContent ? 0 : -30)
                        .animation(.easeOut(duration: 0.4).delay(0.3 + Double(i) * 0.15), value: showContent)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(step.title): \(step.sub). \(stepDone[i] ? "Complete" : "Pending")")
                    }
                }

                Spacer()

                luxButton("Continue", icon: "arrow.right") {
                    advancePage(to: 2)
                }
            }
        }
        .onAppear {
            if reduceMotion {
                showContent = true
                stepDone = [true, true, true]
            } else {
                withAnimation(.easeOut(duration: 0.5)) { showContent = true }
                withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) { orbRot = 360 }
                for i in 0..<3 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 + Double(i) * 0.8) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { stepDone[i] = true }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                }
            }
        }
    }

    private func advancePage(to page: Int) {
        var tx = Transaction(animation: .spring(response: 0.5, dampingFraction: 0.85))
        tx.disablesAnimations = false
        withTransaction(tx) { currentPage = page }
    }
}

// MARK: - Screen 3: First Match Reveal

struct OnboardingScreen3: View {
    @Binding var currentPage: Int
    var animation: Namespace.ID

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showContent = false
    @State private var showCard = false
    @State private var scoreValue: Int = 0
    @State private var showNotes = false
    @State private var shimmerX: CGFloat = -300

    private let notes = ["Tobacco", "Vanilla", "Amber", "Cacao", "Tonka"]

    var body: some View {
        ZStack {
            LuxuryBackground()
            MoleculeParticleView(color: luxGold, count: 22)
                .ignoresSafeArea()
                .accessibilityHidden(true)

            VStack(spacing: 0) {
                OnboardingProgress(current: 2)

                Spacer()

                Text("Your First\nPerfect Match")
                    .font(.system(size: 32, weight: .bold, design: .serif))
                    .foregroundStyle(luxTextPri)
                    .multilineTextAlignment(.center)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)

                Spacer().frame(height: 36)

                VStack(spacing: 16) {
                    ZStack {
                        AuraRing(diameter: 130, color: luxGold, blurRadius: 8)
                        Image(systemName: "flask.fill")
                            .font(.system(size: 48, weight: .ultraLight))
                            .foregroundStyle(
                                LinearGradient(colors: [luxGold, luxGoldLight],
                                               startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .scaleEffect(showCard ? 1 : 0.4)
                            .opacity(showCard ? 1 : 0)
                    }

                    VStack(spacing: 4) {
                        Text("TOM FORD").font(.system(size: 10, weight: .semibold)).tracking(2)
                            .foregroundStyle(luxTextSec)
                        Text("Tobacco Vanille").font(.system(size: 22, weight: .bold, design: .serif))
                            .foregroundStyle(luxTextPri)
                    }

                    Text("Warm tobacco & vanilla complement your bold aesthetic")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(luxTextSec)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                        .opacity(showCard ? 1 : 0)

                    HStack(spacing: 5) {
                        Image(systemName: "sparkle").font(.system(size: 14))
                        Text("\(scoreValue)%")
                            .font(.system(size: 28, weight: .bold, design: .monospaced))
                            .contentTransition(.numericText())
                        Text("Vibe Match").font(.system(size: 14, weight: .medium))
                    }
                    .foregroundStyle(luxGold)

                    if showNotes {
                        HStack(spacing: 8) {
                            ForEach(notes, id: \.self) { note in
                                Text(note).font(.system(size: 10, weight: .semibold))
                                    .foregroundStyle(luxTextPri.opacity(0.85))
                                    .padding(.horizontal, 10).padding(.vertical, 5)
                                    .background(luxTeal.opacity(0.4))
                                    .clipShape(Capsule())
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .padding(24)
                .background(luxSurface)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20).stroke(luxGold.opacity(0.2), lineWidth: 0.5)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(colors: [.clear, .white.opacity(0.05), .clear],
                                             startPoint: .leading, endPoint: .trailing))
                        .offset(x: shimmerX)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .allowsHitTesting(false)
                )
                .matchedGeometryEffect(id: "matchCard", in: animation)
                .padding(.horizontal, 32)
                .scaleEffect(showCard ? 1 : 0.88)
                .opacity(showCard ? 1 : 0)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Match: Tom Ford Tobacco Vanille, \(scoreValue) percent vibe match")

                Spacer()

                luxButton("See Your Full Profile", icon: "arrow.right", gold: true) {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    advancePage(to: 3)
                }
            }
        }
        .onAppear {
            if reduceMotion {
                showContent = true
                showCard = true
                scoreValue = 98
                showNotes = true
            } else {
                withAnimation(.easeOut(duration: 0.5)) { showContent = true }
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) { showCard = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                }
                animateScore()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) { showNotes = true }
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
                withAnimation(.linear(duration: 2.2).repeatForever(autoreverses: false).delay(0.4)) { shimmerX = 400 }
            }
        }
    }

    private func animateScore() {
        let steps = 28
        for i in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 + Double(i) * (1.4 / Double(steps))) {
                withAnimation(.easeOut(duration: 0.05)) {
                    scoreValue = Int(Double(i) / Double(steps) * 98)
                }
            }
        }
    }

    private func advancePage(to page: Int) {
        var tx = Transaction(animation: .spring(response: 0.5, dampingFraction: 0.85))
        tx.disablesAnimations = false
        withTransaction(tx) { currentPage = page }
    }
}

// MARK: - Screen 4: Personalized Paywall

struct PersonalizedPaywallView: View {
    let demoMood: String
    let demoScore: Int
    let onComplete: () -> Void

    @State private var selectedTier: PaywallTier = .yearly
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var errorMessage = ""
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showContent = false
    @State private var proofIdx = 0

    @AppStorage("hasSeenNormalPaywall") private var hasSeenNormalPaywall = false

    // Mood-adaptive social proof: bold/mysterious users see confidence/luxury quotes,
    // others see discovery/freshness quotes
    private var proof: [String] {
        let isBold = demoMood.lowercased().contains("bold") || demoMood.lowercased().contains("mysterious")
        if isBold {
            return [
                "\"ScentVibe matched my bold energy to Tom Ford — I get compliments daily\" — @luxfraghead",
                "\"My confidence went through the roof with my AI-matched scent\" — Marcus R.",
                "\"The AI understood my mysterious vibe better than any SA\" — @noseknows",
                "2,847 scent lovers joined this week",
                "Rated 4.9★ by fragrance enthusiasts",
            ]
        } else {
            return [
                "\"ScentVibe found my perfect fresh scent in 10 seconds\" — @scentlover",
                "\"I never knew what fragrance suited me until ScentVibe\" — Jessica T.",
                "\"The AI nailed my style — light, clean, and unforgettable\" — @fragrancedaily",
                "2,847 scent lovers joined this week",
                "Rated 4.9★ by fragrance enthusiasts",
            ]
        }
    }

    private let proofTimer = Timer.publish(every: 3.5, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            LuxuryBackground()
            MoleculeParticleView(color: luxGold.opacity(0.5), count: 12)
                .ignoresSafeArea()
                .accessibilityHidden(true)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    HStack {
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            onComplete()
                        }) {
                            Text("Maybe later").font(.system(size: 13, weight: .medium))
                                .foregroundStyle(luxTextSec)
                        }
                        Spacer()
                        Button(action: restorePurchases) {
                            Text("Restore").font(.system(size: 13, weight: .medium))
                                .foregroundStyle(luxTextSec)
                        }
                    }
                    .padding(.horizontal, 20).padding(.top, 14)

                    // ── Hero ──
                    VStack(spacing: 12) {
                        ZStack {
                            AuraRing(diameter: 150, color: luxGold, blurRadius: 10)
                            Image(systemName: "crown.fill")
                                .font(.system(size: 44))
                                .foregroundStyle(
                                    LinearGradient(colors: [luxGold, luxGoldLight],
                                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .phaseAnimator(reduceMotion ? [false] : [false, true]) { c, p in
                                    c.scaleEffect(reduceMotion ? 1.0 : (p ? 1.06 : 0.96))
                                } animation: { _ in .easeInOut(duration: 2.5) }
                        }

                        Text("Design Your Trial")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .foregroundStyle(luxTextPri)

                        if !demoMood.isEmpty {
                            Text("Based on your \"\(demoMood)\" analysis…")
                                .font(.system(size: 15)).foregroundStyle(luxTextSec)
                        }

                        Text("Go from \(demoScore) → 88 Vibe Alignment in just 7 days")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(luxEmerald)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)

                        HStack(spacing: 6) {
                            Image(systemName: "bolt.fill").font(.system(size: 10))
                            Text("Limited-time launch pricing").font(.system(size: 11, weight: .semibold))
                        }
                        .foregroundStyle(luxGold)
                        .padding(.horizontal, 12).padding(.vertical, 5)
                        .background(luxGold.opacity(0.1))
                        .clipShape(Capsule())

                        Text(proof[proofIdx])
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(luxGold.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .id(proofIdx)
                            .transition(.asymmetric(
                                insertion: .move(edge: .bottom).combined(with: .opacity),
                                removal: .move(edge: .top).combined(with: .opacity)))
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    .accessibilityElement(children: .combine)

                    // ── Features ──
                    VStack(spacing: 10) {
                        feat("infinity", "Unlimited scent matches")
                        feat("person.crop.rectangle.fill", "Personalized scent wardrobe")
                        feat("globe", "86+ fragrances from 5 regions")
                        feat("star.fill", "Premium AI recommendations")
                        feat("bell.fill", "New fragrance drop alerts")
                    }
                    .padding(.horizontal, 24)

                    // ── Tier Cards ──
                    VStack(spacing: 10) {
                        tierCard(.monthly)
                        tierCard(.yearly)
                        tierCard(.lifetime)
                    }
                    .padding(.horizontal, 20)

                    // ── CTA ──
                    Button(action: purchase) {
                        HStack {
                            if isPurchasing {
                                ProgressView().tint(luxBlack)
                            } else {
                                let label = selectedTier == .yearly
                                    ? "Start Your Free Trial"
                                    : "Continue with \(selectedTier.title)"
                                Text(label)
                                    .font(.system(size: 17, weight: .semibold))
                                Image(systemName: "arrow.right").font(.system(size: 14, weight: .bold))
                            }
                        }
                        .foregroundStyle(luxBlack)
                        .frame(maxWidth: .infinity).frame(height: 56)
                        .background(LinearGradient(colors: [luxGold, luxGoldLight],
                                                   startPoint: .leading, endPoint: .trailing))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(ShimmerSweep().clipShape(RoundedRectangle(cornerRadius: 16)))
                        .shadow(color: luxGold.opacity(0.25), radius: 12, y: 4)
                    }
                    .disabled(isPurchasing)
                    .padding(.horizontal, 24)
                    .accessibilityLabel(selectedTier == .yearly ? "Start seven day free trial" : "Continue with \(selectedTier.title)")
                    .accessibilityHint("Subscribes to the \(selectedTier.title) plan")

                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.shield.fill").font(.system(size: 12))
                        Text("Cancel anytime · Pause anytime · No risk")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundStyle(luxEmerald.opacity(0.8))

                    Button(action: {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        onComplete()
                    }) {
                        Text("Continue with 5 free matches")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(luxTextSec).underline()
                    }
                    .accessibilityLabel("Skip trial and continue with 5 free matches")

                    VStack(spacing: 6) {
                        Text("Payment charged to your Apple ID at confirmation. Subscription auto-renews unless canceled 24 hrs before period end.")
                            .font(.system(size: 9)).foregroundStyle(luxTextSec.opacity(0.5))
                            .multilineTextAlignment(.center)
                        HStack(spacing: 12) {
                            Link("Terms", destination: URL(string: "https://scentvibe-app.netlify.app/terms")!)
                            Link("Privacy", destination: URL(string: "https://scentvibe-app.netlify.app/privacy")!)
                        }
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(luxTextSec.opacity(0.5))
                    }
                    .padding(.horizontal, 32)

                    Spacer().frame(height: 40)
                }
            }
        }
        .onAppear {
            if reduceMotion {
                showContent = true
            } else {
                withAnimation(.easeOut(duration: 0.5)) { showContent = true }
            }
            EventLogger.shared.log(EventLogger.paywallShown)
            // Mark that the user has now seen a paywall — next time they
            // hit the paywall they'll get the promotional win-back offer.
            hasSeenNormalPaywall = true
        }
        .onReceive(proofTimer) { _ in
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 0.4)) { proofIdx = (proofIdx + 1) % proof.count }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: { Text(errorMessage) }
    }

    private func feat(_ icon: String, _ text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill").font(.system(size: 18)).foregroundStyle(luxEmerald)
            Text(text).font(.system(size: 15)).foregroundStyle(luxTextPri)
            Spacer()
        }
        .accessibilityElement(children: .combine)
    }

    private func tierCard(_ tier: PaywallTier) -> some View {
        let sel = selectedTier == tier
        let strokeColor: Color = sel ? luxGold : luxTextSec.opacity(0.4)
        let borderColor: Color = sel ? luxGold : .clear

        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { selectedTier = tier }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle().stroke(strokeColor, lineWidth: 2)
                        .frame(width: 22, height: 22)
                    if sel {
                        Circle().fill(luxGold).frame(width: 12, height: 12)
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(tier.title).font(.system(size: 16, weight: .semibold)).foregroundStyle(luxTextPri)
                        if tier == .yearly {
                            Text("SAVE 50%").font(.system(size: 9, weight: .bold))
                                .foregroundStyle(luxBlack)
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(luxGold).clipShape(Capsule())
                        }
                        if tier == .lifetime {
                            Text("BEST VALUE").font(.system(size: 9, weight: .bold))
                                .foregroundStyle(luxGold)
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(luxGold.opacity(0.15)).clipShape(Capsule())
                        }
                    }
                    if tier == .yearly {
                        Text("7-day FREE trial · then \(tier.price)/year")
                            .font(.system(size: 12, weight: .semibold)).foregroundStyle(luxEmerald)
                    } else {
                        Text(tier.pricePerMonth)
                            .font(.system(size: 12)).foregroundStyle(luxTextSec)
                    }
                }
                Spacer()
                let priceColor: Color = sel ? luxGold : luxTextSec
                Text(tier.price).font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(priceColor)
            }
            .padding(14)
            .background(luxSurface)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(borderColor, lineWidth: 1.5))
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(tierAccessibilityLabel(tier, selected: sel))
        .accessibilityHint(sel ? "Currently selected" : "Double-tap to select this plan")
        .accessibilityAddTraits(sel ? .isSelected : [])
    }

    private func tierAccessibilityLabel(_ tier: PaywallTier, selected: Bool) -> String {
        switch tier {
        case .monthly:
            return "Monthly plan, \(tier.price) per month"
        case .yearly:
            return "Yearly plan, \(tier.price) per year, save 50 percent, includes 7 day free trial"
        case .lifetime:
            return "Lifetime plan, \(tier.price) one time, best value"
        }
    }

    private func purchase() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        isPurchasing = true
        Task {
            do {
                try await PaywallManager.shared.purchase(tier: selectedTier)
                EventLogger.shared.log(EventLogger.paywallConverted, metadata: [
                    "tier": selectedTier.title, "price": selectedTier.price
                ])
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                onComplete()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
            isPurchasing = false
        }
    }

    private func restorePurchases() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        isPurchasing = true
        Task {
            do {
                try await PaywallManager.shared.restorePurchases()
                if PaywallManager.shared.isPremium {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    onComplete()
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
            isPurchasing = false
        }
    }
}

// MARK: - Onboarding Flow Container

struct ScentVibeOnboardingFlow: View {
    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var animation
    @State private var currentPage = 0
    @State private var demoMood = ""
    @State private var demoScore = 41

    var body: some View {
        ZStack {
            switch currentPage {
            case 0:
                OnboardingScreen1(currentPage: $currentPage,
                                  demoMood: $demoMood,
                                  demoScore: $demoScore,
                                  animation: animation)
                    .transition(fwd)
            case 1:
                OnboardingScreen2(currentPage: $currentPage,
                                  animation: animation)
                    .transition(fwd)
            case 2:
                OnboardingScreen3(currentPage: $currentPage,
                                  animation: animation)
                    .transition(fwd)
            case 3:
                PersonalizedPaywallView(demoMood: demoMood,
                                        demoScore: demoScore,
                                        onComplete: onComplete)
                    .transition(fwd)
            default:
                EmptyView()
            }
        }
        .animation(reduceMotion ? .none : .spring(response: 0.5, dampingFraction: 0.85), value: currentPage)
    }

    private var fwd: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }
}

// MARK: - Public entry point

struct OnboardingView: View {
    let onComplete: () -> Void

    var body: some View {
        ScentVibeOnboardingFlow(onComplete: onComplete)
    }
}

// MARK: - Luxury Button Helper

private func luxButton(_ title: String, icon: String, gold isGold: Bool = false,
                        action: @escaping () -> Void) -> some View {
    let bg: LinearGradient = isGold
        ? LinearGradient(colors: [luxGold, luxGoldLight], startPoint: .leading, endPoint: .trailing)
        : LinearGradient(colors: [luxEmerald, luxTeal], startPoint: .leading, endPoint: .trailing)

    return Button(action: {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        action()
    }) {
        HStack(spacing: 8) {
            Text(title).font(.system(size: 17, weight: .semibold))
            Image(systemName: icon).font(.system(size: 14, weight: .bold))
        }
        .foregroundStyle(luxBlack)
        .frame(maxWidth: .infinity).frame(height: 54)
        .background(bg)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(ShimmerSweep().clipShape(RoundedRectangle(cornerRadius: 16)))
    }
    .padding(.horizontal, 24)
    .padding(.bottom, 50)
}
