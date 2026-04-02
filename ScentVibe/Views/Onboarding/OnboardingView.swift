import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void

    @State private var currentPage = 0
    @State private var showContent = false

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "camera.viewfinder",
            title: String(localized: "onboarding_title_1", defaultValue: "Snap Your Style"),
            subtitle: String(localized: "onboarding_subtitle_1", defaultValue: "Take a photo of your outfit or room and let AI analyze your visual vibe"),
            accentColor: .smEmerald
        ),
        OnboardingPage(
            icon: "wand.and.stars",
            title: String(localized: "onboarding_title_2", defaultValue: "Instant Scent Match"),
            subtitle: String(localized: "onboarding_subtitle_2", defaultValue: "Our engine matches your colors, mood, and style to the perfect fragrance from 86+ curated scents"),
            accentColor: .smGold
        ),
        OnboardingPage(
            icon: "sparkles",
            title: String(localized: "onboarding_title_3", defaultValue: "Discover & Collect"),
            subtitle: String(localized: "onboarding_subtitle_3", defaultValue: "Build your scent wardrobe, explore fragrances from 5 cultures, and shop your favorites"),
            accentColor: .smLightEmerald
        ),
    ]

    var body: some View {
        ZStack {
            Color.smBackground.ignoresSafeArea()

            // Animated background particles (always visible)
            AnimatedBackgroundView(accentColor: pages[currentPage].accentColor)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.8), value: currentPage)

            VStack(spacing: 0) {
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        OnboardingPageView(page: page, pageIndex: index, isActive: currentPage == index)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Bottom controls
                VStack(spacing: 20) {
                    // Animated page dots
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Capsule()
                                .fill(index == currentPage ? pages[currentPage].accentColor : Color.smTextTertiary.opacity(0.4))
                                .frame(width: index == currentPage ? 24 : 8, height: 8)
                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentPage)
                        }
                    }

                    // CTA button with shimmer
                    Button(action: advance) {
                        HStack {
                            Text(currentPage == pages.count - 1 ?
                                 String(localized: "onboarding_start", defaultValue: "Start Scanning") :
                                 String(localized: "onboarding_next", defaultValue: "Next"))
                                .font(SMFont.headline(17))

                            if currentPage == pages.count - 1 {
                                Image(systemName: "camera.fill")
                            } else {
                                Image(systemName: "arrow.right")
                            }
                        }
                        .foregroundStyle(Color.smBackground)
                        .frame(maxWidth: .infinity)
                        .frame(height: SMTheme.buttonHeight)
                        .background(
                            currentPage == pages.count - 1 ?
                            LinearGradient.smGoldGradient :
                            LinearGradient.smPrimaryGradient
                        )
                        .clipShape(RoundedRectangle(cornerRadius: SMTheme.cornerRadius))
                        .overlay(
                            ShimmerOverlay()
                                .clipShape(RoundedRectangle(cornerRadius: SMTheme.cornerRadius))
                        )
                    }

                    if currentPage < pages.count - 1 {
                        Button(action: { onComplete() }) {
                            Text(String(localized: "onboarding_skip", defaultValue: "Skip"))
                                .font(SMFont.caption())
                                .foregroundStyle(Color.smTextTertiary)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                showContent = true
            }
        }
    }

    private func advance() {
        if currentPage < pages.count - 1 {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                currentPage += 1
            }
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        } else {
            let impact = UINotificationFeedbackGenerator()
            impact.notificationOccurred(.success)
            onComplete()
        }
    }
}

// MARK: - Page Model

private struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
    let accentColor: Color
}

// MARK: - Individual Page View with Custom Animation

private struct OnboardingPageView: View {
    let page: OnboardingPage
    let pageIndex: Int
    let isActive: Bool

    @State private var animateIn = false

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            // Animated illustration area
            ZStack {
                // Outer pulsing rings
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .stroke(page.accentColor.opacity(animateIn ? 0.06 : 0.15), lineWidth: 1)
                        .frame(width: CGFloat(160 + i * 50), height: CGFloat(160 + i * 50))
                        .scaleEffect(animateIn ? 1.1 : 0.9)
                        .animation(
                            .easeInOut(duration: 2.5 + Double(i) * 0.4)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.3),
                            value: animateIn
                        )
                }

                // Page-specific animated graphic
                pageSpecificGraphic

                // Central glowing backdrop
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [page.accentColor.opacity(0.2), page.accentColor.opacity(0.05), .clear],
                            center: .center,
                            startRadius: 10,
                            endRadius: 90
                        )
                    )
                    .frame(width: 180, height: 180)
                    .scaleEffect(animateIn ? 1.05 : 0.95)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateIn)

                // Center icon with bounce
                Image(systemName: page.icon)
                    .font(.system(size: 52, weight: .thin))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [page.accentColor, page.accentColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(animateIn ? 1.0 : 0.8)
                    .opacity(animateIn ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2), value: animateIn)
            }
            .frame(height: 280)

            // Text with staggered entrance
            VStack(spacing: 14) {
                Text(page.title)
                    .font(SMFont.display(28))
                    .foregroundStyle(Color.smTextPrimary)
                    .multilineTextAlignment(.center)
                    .opacity(animateIn ? 1 : 0)
                    .offset(y: animateIn ? 0 : 15)
                    .animation(.easeOut(duration: 0.5).delay(0.3), value: animateIn)

                Text(page.subtitle)
                    .font(SMFont.body())
                    .foregroundStyle(Color.smTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
                    .opacity(animateIn ? 1 : 0)
                    .offset(y: animateIn ? 0 : 15)
                    .animation(.easeOut(duration: 0.5).delay(0.45), value: animateIn)
            }

            Spacer()
            Spacer()
        }
        .onAppear { animateIn = true }
        .onChange(of: isActive) { _, active in
            if active {
                animateIn = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    animateIn = true
                }
            }
        }
    }

    // MARK: - Page-specific animated graphics

    @ViewBuilder
    private var pageSpecificGraphic: some View {
        switch pageIndex {
        case 0:
            // Camera page: floating color swatches orbiting
            CameraOrbitAnimation(accentColor: page.accentColor, animate: animateIn)
        case 1:
            // Matching page: converging fragrance notes
            MatchingWaveAnimation(accentColor: page.accentColor, animate: animateIn)
        case 2:
            // Collection page: expanding constellation
            ConstellationAnimation(accentColor: page.accentColor, animate: animateIn)
        default:
            EmptyView()
        }
    }
}

// MARK: - Page 1: Camera Orbit Animation — color swatches orbit the center

private struct CameraOrbitAnimation: View {
    let accentColor: Color
    let animate: Bool

    @State private var rotation: Double = 0

    private let swatchColors: [Color] = [
        .pink, .orange, .cyan, .purple, .yellow, .mint
    ]

    var body: some View {
        ZStack {
            ForEach(0..<6, id: \.self) { i in
                let angle = (Double(i) / 6.0) * 360.0 + rotation
                let rad = angle * .pi / 180.0
                let radius: CGFloat = 105

                RoundedRectangle(cornerRadius: 5)
                    .fill(swatchColors[i].opacity(0.7))
                    .frame(width: 18, height: 18)
                    .rotationEffect(.degrees(-angle))
                    .offset(x: cos(rad) * radius, y: sin(rad) * radius)
                    .shadow(color: swatchColors[i].opacity(0.4), radius: 4)
            }

            // Scanning line effect
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.clear, accentColor.opacity(0.3), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 120, height: 2)
                .offset(y: animate ? 40 : -40)
                .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: animate)
        }
        .onAppear {
            withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

// MARK: - Page 2: Matching Wave Animation — pulsing color bands

private struct MatchingWaveAnimation: View {
    let accentColor: Color
    let animate: Bool

    @State private var phase: CGFloat = 0

    var body: some View {
        ZStack {
            // Orbiting fragrance accord pills
            ForEach(0..<5, id: \.self) { i in
                let names = ["Woody", "Floral", "Fresh", "Spicy", "Citrus"]
                let colors: [Color] = [.brown.opacity(0.7), .pink.opacity(0.7), .cyan.opacity(0.7), .orange.opacity(0.7), .yellow.opacity(0.7)]
                let yOffset = CGFloat(i - 2) * 28
                let delay = Double(i) * 0.15

                Text(names[i])
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(colors[i]))
                    .shadow(color: colors[i].opacity(0.4), radius: 3)
                    .offset(x: animate ? 0 : (i % 2 == 0 ? -80 : 80), y: yOffset)
                    .opacity(animate ? 1 : 0)
                    .scaleEffect(animate ? 1.0 : 0.5)
                    .animation(.spring(response: 0.6, dampingFraction: 0.65).delay(delay + 0.2), value: animate)
            }

            // Connecting lines from pills to center
            ForEach(0..<5, id: \.self) { i in
                let yOffset = CGFloat(i - 2) * 28
                Rectangle()
                    .fill(accentColor.opacity(animate ? 0.15 : 0))
                    .frame(width: animate ? 60 : 0, height: 1)
                    .offset(y: yOffset)
                    .animation(.easeOut(duration: 0.8).delay(Double(i) * 0.15 + 0.5), value: animate)
            }
        }
    }
}

// MARK: - Page 3: Constellation Animation — expanding stars

private struct ConstellationAnimation: View {
    let accentColor: Color
    let animate: Bool

    struct StarPoint: Identifiable {
        let id: Int
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let delay: Double
        let icon: String
    }

    private let stars: [StarPoint] = [
        StarPoint(id: 0, x: -70, y: -80, size: 10, delay: 0.1, icon: "star.fill"),
        StarPoint(id: 1, x: 80, y: -60, size: 8, delay: 0.2, icon: "sparkle"),
        StarPoint(id: 2, x: -90, y: 30, size: 12, delay: 0.3, icon: "star.fill"),
        StarPoint(id: 3, x: 60, y: 70, size: 9, delay: 0.4, icon: "sparkle"),
        StarPoint(id: 4, x: -30, y: 100, size: 7, delay: 0.5, icon: "star.fill"),
        StarPoint(id: 5, x: 100, y: 10, size: 11, delay: 0.15, icon: "sparkle"),
        StarPoint(id: 6, x: -50, y: -40, size: 6, delay: 0.35, icon: "star.fill"),
        StarPoint(id: 7, x: 40, y: -100, size: 8, delay: 0.25, icon: "sparkle"),
        StarPoint(id: 8, x: -100, y: -20, size: 7, delay: 0.45, icon: "star.fill"),
        StarPoint(id: 9, x: 20, y: 40, size: 10, delay: 0.55, icon: "sparkle"),
    ]

    @State private var twinkle = false

    var body: some View {
        ZStack {
            // Connection lines between nearby stars
            ForEach(0..<stars.count, id: \.self) { i in
                if i < stars.count - 1 {
                    let from = stars[i]
                    let to = stars[i + 1]
                    Path { path in
                        path.move(to: CGPoint(x: from.x + 140, y: from.y + 140))
                        path.addLine(to: CGPoint(x: to.x + 140, y: to.y + 140))
                    }
                    .stroke(accentColor.opacity(animate ? 0.15 : 0), lineWidth: 0.5)
                    .animation(.easeOut(duration: 0.8).delay(stars[i].delay + 0.3), value: animate)
                }
            }

            // Stars
            ForEach(stars) { star in
                Image(systemName: star.icon)
                    .font(.system(size: star.size))
                    .foregroundStyle(accentColor.opacity(twinkle && star.id % 2 == 0 ? 0.5 : 0.9))
                    .offset(x: animate ? star.x : 0, y: animate ? star.y : 0)
                    .scaleEffect(animate ? 1.0 : 0.0)
                    .opacity(animate ? 1 : 0)
                    .animation(
                        .spring(response: 0.7, dampingFraction: 0.5)
                        .delay(star.delay),
                        value: animate
                    )
            }

            // Floating region flags
            let flags = ["🇩🇪", "🇲🇽", "🇧🇷", "🇫🇷", "🌍"]
            ForEach(0..<5, id: \.self) { i in
                let angle = (Double(i) / 5.0) * 360.0
                let rad = angle * .pi / 180.0
                let radius: CGFloat = 75

                Text(flags[i])
                    .font(.system(size: 18))
                    .offset(
                        x: animate ? cos(rad) * radius : 0,
                        y: animate ? sin(rad) * radius : 0
                    )
                    .scaleEffect(animate ? 1.0 : 0.0)
                    .opacity(animate ? 1 : 0)
                    .animation(
                        .spring(response: 0.8, dampingFraction: 0.5)
                        .delay(0.4 + Double(i) * 0.1),
                        value: animate
                    )
            }
        }
        .frame(width: 280, height: 280)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                twinkle = true
            }
        }
    }
}

// MARK: - Animated Background (floating particles)

private struct AnimatedBackgroundView: View {
    let accentColor: Color

    @State private var animate = false

    struct Particle: Identifiable {
        let id: Int
        let startX: CGFloat
        let startY: CGFloat
        let endX: CGFloat
        let endY: CGFloat
        let size: CGFloat
        let duration: Double
        let delay: Double
        let opacity: Double
    }

    private let particles: [Particle] = (0..<25).map { i in
        Particle(
            id: i,
            startX: CGFloat.random(in: -200...200),
            startY: CGFloat.random(in: -400...400),
            endX: CGFloat.random(in: -200...200),
            endY: CGFloat.random(in: -400...400),
            size: CGFloat.random(in: 2...5),
            duration: Double.random(in: 3...7),
            delay: Double.random(in: 0...2),
            opacity: Double.random(in: 0.05...0.2)
        )
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(particles) { p in
                    Circle()
                        .fill(accentColor.opacity(p.opacity))
                        .frame(width: p.size, height: p.size)
                        .position(
                            x: geo.size.width / 2 + (animate ? p.endX : p.startX),
                            y: geo.size.height / 2 + (animate ? p.endY : p.startY)
                        )
                        .animation(
                            .easeInOut(duration: p.duration)
                            .repeatForever(autoreverses: true)
                            .delay(p.delay),
                            value: animate
                        )
                }

                // Soft gradient blob top-right
                Ellipse()
                    .fill(
                        RadialGradient(
                            colors: [accentColor.opacity(0.06), .clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 150
                        )
                    )
                    .frame(width: 300, height: 300)
                    .position(x: geo.size.width * 0.8, y: geo.size.height * 0.15)
                    .offset(x: animate ? 20 : -20, y: animate ? -15 : 15)
                    .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: animate)

                // Soft gradient blob bottom-left
                Ellipse()
                    .fill(
                        RadialGradient(
                            colors: [accentColor.opacity(0.04), .clear],
                            center: .center,
                            startRadius: 30,
                            endRadius: 120
                        )
                    )
                    .frame(width: 250, height: 250)
                    .position(x: geo.size.width * 0.2, y: geo.size.height * 0.75)
                    .offset(x: animate ? -15 : 15, y: animate ? 10 : -10)
                    .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animate)
            }
        }
        .onAppear { animate = true }
    }
}

// MARK: - Shimmer Overlay for CTA Button

private struct ShimmerOverlay: View {
    @State private var shimmerOffset: CGFloat = -200

    var body: some View {
        GeometryReader { geo in
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.clear, .white.opacity(0.15), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 80)
                .offset(x: shimmerOffset)
                .onAppear {
                    withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                        shimmerOffset = geo.size.width + 200
                    }
                }
        }
        .allowsHitTesting(false)
    }
}
