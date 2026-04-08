import SwiftUI
import SwiftData

// ══════════════════════════════════════════════════════════════════════
//  ScentVibe — 8-Screen Woofz-Style Onboarding
//  Screen 1: Splash + brand reveal
//  Screen 2: Name capture
//  Screen 3: Vibe quiz (6 moods)
//  Screen 4: Occasion quiz
//  Screen 5: Fragrance region
//  Screen 6: Analyzing animation
//  Screen 7: Archetype reveal + first badge
//  Screen 8: Paywall
// ══════════════════════════════════════════════════════════════════════

// MARK: - Private Design Tokens

private let ob_bg       = Color(red: 0.030, green: 0.046, blue: 0.046)
private let ob_surface  = Color(red: 0.055, green: 0.100, blue: 0.100)
private let ob_gold     = Color(red: 0.831, green: 0.686, blue: 0.467)
private let ob_goldLt   = Color(red: 0.940, green: 0.820, blue: 0.640)
private let ob_emerald  = Color(red: 0.000, green: 0.851, blue: 0.620)
private let ob_teal     = Color(red: 0.039, green: 0.239, blue: 0.239)
private let ob_priText  = Color(red: 0.949, green: 0.949, blue: 0.933)
private let ob_secText  = Color(red: 0.541, green: 0.604, blue: 0.604)

// MARK: - OnboardingView (root coordinator)

struct OnboardingView: View {
    var onComplete: () -> Void

    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]

    @State private var page = 0
    @State private var name = ""
    @State private var selectedVibe = ""
    @State private var selectedOccasion = ""
    @State private var selectedRegion = ""
    @State private var archetype: ScentArchetype?
    @State private var analyzeProgress: Double = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // Navigation boundary: 0-7
    private let pageCount = 8

    var body: some View {
        ZStack {
            ob_bg.ignoresSafeArea()

            // Content switcher
            Group {
                switch page {
                case 0: splashScreen
                case 1: nameScreen
                case 2: vibeQuizScreen
                case 3: occasionQuizScreen
                case 4: regionScreen
                case 5: analyzingScreen
                case 6: archetypeRevealScreen
                case 7: paywallScreen
                default: EmptyView()
                }
            }
            .transition(pageTransition)
        }
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.4), value: page)
        .preferredColorScheme(.dark)
    }

    private var pageTransition: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal:   .move(edge: .leading).combined(with: .opacity)
        )
    }

    // MARK: - Advance helpers

    private func advance() {
        let next = page + 1

        // Derive archetype before reveal
        if next == 6 {
            archetype = Archetypes.forVibe(selectedVibe)
        }

        // Kick off analysis animation
        if next == 5 {
            startAnalysis()
        }

        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.4)) {
            page = next
        }
    }

    private func startAnalysis() {
        analyzeProgress = 0
        // Simulate progress: 0→1 over 2.2 s, then auto-advance
        withAnimation(.easeInOut(duration: 2.0)) {
            analyzeProgress = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.4)) {
                page = 6
            }
        }
    }

    private func completeOnboarding() {
        // Persist preferences to SwiftData profile
        let profile: UserProfile = {
            if let p = profiles.first { return p }
            let p = UserProfile()
            modelContext.insert(p)
            return p
        }()
        profile.preferredRegion  = selectedRegion.isEmpty ? nil : selectedRegion
        profile.hasCompletedOnboarding = true
        onComplete()
    }

    // ═══════════════════════════════
    // MARK: Screen 1 — Splash
    // ═══════════════════════════════

    private var splashScreen: some View {
        SplashScreenView {
            advance()
        }
    }

    // ═══════════════════════════════
    // MARK: Screen 2 — Name
    // ═══════════════════════════════

    private var nameScreen: some View {
        NameScreenView(name: $name, pageIndex: page, totalPages: pageCount) {
            advance()
        }
    }

    // ═══════════════════════════════
    // MARK: Screen 3 — Vibe Quiz
    // ═══════════════════════════════

    private var vibeQuizScreen: some View {
        VibeQuizScreenView(selectedVibe: $selectedVibe, pageIndex: page, totalPages: pageCount) {
            advance()
        }
    }

    // ═══════════════════════════════
    // MARK: Screen 4 — Occasion
    // ═══════════════════════════════

    private var occasionQuizScreen: some View {
        OccasionQuizScreenView(selectedOccasion: $selectedOccasion, pageIndex: page, totalPages: pageCount) {
            advance()
        }
    }

    // ═══════════════════════════════
    // MARK: Screen 5 — Region
    // ═══════════════════════════════

    private var regionScreen: some View {
        RegionQuizScreenView(selectedRegion: $selectedRegion, pageIndex: page, totalPages: pageCount) {
            advance()
        }
    }

    // ═══════════════════════════════
    // MARK: Screen 6 — Analyzing
    // ═══════════════════════════════

    private var analyzingScreen: some View {
        AnalyzingScreenView(
            userName: name,
            progress: analyzeProgress,
            pageIndex: page,
            totalPages: pageCount
        )
    }

    // ═══════════════════════════════
    // MARK: Screen 7 — Archetype
    // ═══════════════════════════════

    private var archetypeRevealScreen: some View {
        ArchetypeRevealView(
            archetype: archetype ?? Archetypes.forVibe("elegant"),
            userName: name,
            pageIndex: page,
            totalPages: pageCount
        ) {
            advance()
        }
    }

    // ═══════════════════════════════
    // MARK: Screen 8 — Paywall
    // ═══════════════════════════════

    private var paywallScreen: some View {
        OnboardingPaywallScreen(onComplete: completeOnboarding)
    }
}

// ══════════════════════════════════════════════════════════════════════
// MARK: - Shared Sub-Components
// ══════════════════════════════════════════════════════════════════════

// Progress dots

private struct OBProgressDots: View {
    let current: Int
    let total: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { i in
                Capsule()
                    .fill(i == current ? ob_gold : ob_secText.opacity(0.25))
                    .frame(width: i == current ? 20 : 6, height: 4)
                    .animation(.spring(response: 0.4, dampingFraction: 0.75), value: current)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Step \(current + 1) of \(total)")
    }
}

// CTA button

private struct OBCTAButton: View {
    let label: String
    var enabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(red: 0.06, green: 0.06, blue: 0.06))
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    Group {
                        if enabled {
                            LinearGradient(
                                colors: [ob_gold, ob_emerald],
                                startPoint: .leading, endPoint: .trailing
                            )
                        } else {
                            Color(red: 0.2, green: 0.2, blue: 0.2)
                        }
                    }
                )
                .cornerRadius(16)
        }
        .disabled(!enabled)
        .padding(.horizontal, 28)
        .accessibilityLabel(label)
        .accessibilityHint(enabled ? "" : "Complete your selection first")
    }
}

// ══════════════════════════════════════════════════════════════════════
// MARK: - Screen 1: Splash
// ══════════════════════════════════════════════════════════════════════

private struct SplashScreenView: View {
    let onContinue: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var taglineOpacity: Double = 0
    @State private var ctaOpacity: Double = 0
    @State private var orbPulse = false

    var body: some View {
        ZStack {
            ob_bg.ignoresSafeArea()

            // Background radial
            RadialGradient(
                colors: [ob_teal.opacity(0.2), ob_bg],
                center: .center,
                startRadius: 40,
                endRadius: 340
            )
            .ignoresSafeArea()
            .accessibilityHidden(true)

            VStack(spacing: 0) {
                Spacer()

                // Logo area
                ZStack {
                    // Outer glow
                    if !reduceMotion {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [ob_emerald.opacity(orbPulse ? 0.18 : 0.08), .clear],
                                    center: .center, startRadius: 10, endRadius: 90
                                )
                            )
                            .frame(width: 180, height: 180)
                            .blur(radius: 4)
                    }

                    // Ring
                    Circle()
                        .stroke(ob_gold.opacity(0.25), lineWidth: 1)
                        .frame(width: 130, height: 130)
                        .scaleEffect(orbPulse && !reduceMotion ? 1.06 : 0.96)

                    // Icon
                    Image(systemName: "sparkles")
                        .font(.system(size: 60, weight: .ultraLight))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [ob_gold, ob_emerald],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                .accessibilityHidden(true)

                Spacer().frame(height: 36)

                Text("ScentVibe")
                    .font(.system(size: 42, weight: .bold, design: .serif))
                    .foregroundStyle(ob_priText)
                    .opacity(logoOpacity)

                Spacer().frame(height: 10)

                Text("Your AI Fragrance Match")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(ob_secText)
                    .opacity(taglineOpacity)

                Spacer().frame(height: 12)

                HStack(spacing: 20) {
                    pill("📸 Photo-to-Scent")
                    pill("🧪 86+ Fragrances")
                }
                .opacity(taglineOpacity)

                HStack(spacing: 20) {
                    pill("🔥 Daily Streaks")
                    pill("🏆 Achievements")
                }
                .opacity(taglineOpacity)

                Spacer()

                // CTA
                OBCTAButton(label: "Get Started") {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    onContinue()
                }
                .opacity(ctaOpacity)

                Spacer().frame(height: 12)

                Text("Free • No credit card required")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(ob_secText.opacity(0.6))
                    .opacity(ctaOpacity)

                Spacer().frame(height: 36)
            }
        }
        .onAppear { runEntrance() }
    }

    private func pill(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(ob_secText)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(Capsule().fill(ob_surface))
    }

    private func runEntrance() {
        if reduceMotion {
            logoScale = 1; logoOpacity = 1; taglineOpacity = 1; ctaOpacity = 1
            return
        }
        withAnimation(.interpolatingSpring(mass: 1, stiffness: 120, damping: 14).delay(0.1)) {
            logoScale = 1; logoOpacity = 1
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.55)) { taglineOpacity = 1 }
        withAnimation(.easeOut(duration: 0.4).delay(0.85)) { ctaOpacity = 1 }
        withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true).delay(0.1)) {
            orbPulse = true
        }
    }
}

// ══════════════════════════════════════════════════════════════════════
// MARK: - Screen 2: Name
// ══════════════════════════════════════════════════════════════════════

private struct NameScreenView: View {
    @Binding var name: String
    let pageIndex: Int
    let totalPages: Int
    let onContinue: () -> Void

    @FocusState private var focused: Bool
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 0) {
            // Nav header
            HStack {
                Spacer()
                OBProgressDots(current: pageIndex, total: totalPages)
                Spacer()
            }
            .padding(.top, 16)
            .padding(.horizontal)

            Spacer()

            VStack(spacing: 24) {
                Text("✨")
                    .font(.system(size: 58))
                    .opacity(appeared ? 1 : 0)

                VStack(spacing: 10) {
                    Text("What should we\ncall you?")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundStyle(ob_priText)
                        .multilineTextAlignment(.center)

                    Text("We'll personalize your scent journey.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(ob_secText)
                        .multilineTextAlignment(.center)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)

                // Text field
                TextField("Your first name", text: $name)
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundStyle(ob_priText)
                    .multilineTextAlignment(.center)
                    .submitLabel(.done)
                    .focused($focused)
                    .onSubmit { if !name.trimmingCharacters(in: .whitespaces).isEmpty { onContinue() } }
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(ob_surface)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .strokeBorder(
                                        focused ? ob_gold.opacity(0.6) : Color.white.opacity(0.08),
                                        lineWidth: 1.5
                                    )
                            )
                    )
                    .padding(.horizontal, 28)
                    .opacity(appeared ? 1 : 0)
            }

            Spacer()

            OBCTAButton(
                label: name.trimmingCharacters(in: .whitespaces).isEmpty ? "Enter your name" : "Continue →",
                enabled: !name.trimmingCharacters(in: .whitespaces).isEmpty
            ) {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                focused = false
                onContinue()
            }

            Spacer().frame(height: 40)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.1)) { appeared = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { focused = true }
        }
    }
}

// ══════════════════════════════════════════════════════════════════════
// MARK: - Screen 3: Vibe Quiz
// ══════════════════════════════════════════════════════════════════════

private struct VibeQuizScreenView: View {
    @Binding var selectedVibe: String
    let pageIndex: Int
    let totalPages: Int
    let onContinue: () -> Void

    @State private var appeared = false

    private let vibes: [(id: String, label: String, emoji: String, desc: String)] = [
        ("elegant",     "Elegant",      "🕊️", "Refined & timeless"),
        ("bold",        "Bold",         "⚡️", "Magnetic & daring"),
        ("fresh",       "Fresh",        "🌿", "Vibrant & airy"),
        ("romantic",    "Romantic",     "🌹", "Warm & sensual"),
        ("mysterious",  "Mysterious",   "🌑", "Dark & complex"),
        ("adventurous", "Adventurous",  "🌊", "Exotic & free"),
    ]

    let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                OBProgressDots(current: pageIndex, total: totalPages)
                Spacer()
            }
            .padding(.top, 16)
            .padding(.horizontal)

            Spacer().frame(height: 28)

            VStack(spacing: 8) {
                Text("What's your vibe?")
                    .font(.system(size: 30, weight: .bold, design: .serif))
                    .foregroundStyle(ob_priText)

                Text("Choose the aesthetic that speaks to you.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(ob_secText)
            }
            .multilineTextAlignment(.center)
            .opacity(appeared ? 1 : 0)
            .padding(.horizontal)

            Spacer().frame(height: 24)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(vibes, id: \.id) { v in
                    VibeCard(
                        emoji: v.emoji,
                        label: v.label,
                        desc: v.desc,
                        isSelected: selectedVibe == v.id
                    ) {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        selectedVibe = v.id
                    }
                    .opacity(appeared ? 1 : 0)
                }
            }
            .padding(.horizontal)

            Spacer()

            OBCTAButton(
                label: selectedVibe.isEmpty ? "Pick a vibe" : "Continue →",
                enabled: !selectedVibe.isEmpty
            ) {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                onContinue()
            }

            Spacer().frame(height: 40)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.55).delay(0.1)) { appeared = true }
        }
    }
}

private struct VibeCard: View {
    let emoji: String
    let label: String
    let desc: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(emoji)
                    .font(.system(size: 34))
                Text(label)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(isSelected ? ob_bg : ob_priText)
                Text(desc)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(isSelected ? ob_bg.opacity(0.7) : ob_secText)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected
                        ? LinearGradient(colors: [ob_gold, ob_emerald], startPoint: .topLeading, endPoint: .bottomTrailing)
                        : LinearGradient(colors: [ob_surface, ob_surface], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(isSelected ? Color.clear : Color.white.opacity(0.08), lineWidth: 1)
                    )
            )
            .scaleEffect(isSelected ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(label): \(desc)")
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

// ══════════════════════════════════════════════════════════════════════
// MARK: - Screen 4: Occasion Quiz
// ══════════════════════════════════════════════════════════════════════

private struct OccasionQuizScreenView: View {
    @Binding var selectedOccasion: String
    let pageIndex: Int
    let totalPages: Int
    let onContinue: () -> Void

    @State private var appeared = false

    private let occasions: [(id: String, label: String, emoji: String)] = [
        ("work",      "Work & Office",    "💼"),
        ("dates",     "Date Nights",      "🌃"),
        ("casual",    "Everyday Casual",  "☀️"),
        ("events",    "Events & Parties", "🥂"),
        ("outdoor",   "Outdoors",         "🌿"),
        ("sport",     "Sport & Active",   "🏃"),
    ]

    let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                OBProgressDots(current: pageIndex, total: totalPages)
                Spacer()
            }
            .padding(.top, 16)
            .padding(.horizontal)

            Spacer().frame(height: 28)

            VStack(spacing: 8) {
                Text("When do you wear\nfragrance most?")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundStyle(ob_priText)
                    .multilineTextAlignment(.center)

                Text("We'll match your lifestyle perfectly.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(ob_secText)
            }
            .opacity(appeared ? 1 : 0)
            .padding(.horizontal)

            Spacer().frame(height: 24)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(occasions, id: \.id) { o in
                    SimpleChoiceCard(
                        emoji: o.emoji,
                        label: o.label,
                        isSelected: selectedOccasion == o.id
                    ) {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        selectedOccasion = o.id
                    }
                    .opacity(appeared ? 1 : 0)
                }
            }
            .padding(.horizontal)

            Spacer()

            OBCTAButton(
                label: selectedOccasion.isEmpty ? "Pick an occasion" : "Continue →",
                enabled: !selectedOccasion.isEmpty
            ) {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                onContinue()
            }

            Spacer().frame(height: 40)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.55).delay(0.1)) { appeared = true }
        }
    }
}

// ══════════════════════════════════════════════════════════════════════
// MARK: - Screen 5: Region
// ══════════════════════════════════════════════════════════════════════

private struct RegionQuizScreenView: View {
    @Binding var selectedRegion: String
    let pageIndex: Int
    let totalPages: Int
    let onContinue: () -> Void

    @State private var appeared = false

    private let regions: [(id: String, label: String, emoji: String, desc: String)] = [
        ("Western",   "Western",   "🇺🇸", "Fresh, modern classics"),
        ("German",    "German",    "🇩🇪", "Precise, innovative"),
        ("Mexican",   "Mexican",   "🇲🇽", "Warm, vibrant spices"),
        ("Brazilian", "Brazilian", "🇧🇷", "Tropical, exotic woods"),
        ("French",    "French",    "🇫🇷", "Artisanal, timeless"),
        ("all",       "All Worlds","🌍",  "Surprise me!"),
    ]

    let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                OBProgressDots(current: pageIndex, total: totalPages)
                Spacer()
            }
            .padding(.top, 16)
            .padding(.horizontal)

            Spacer().frame(height: 28)

            VStack(spacing: 8) {
                Text("Your fragrance world?")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundStyle(ob_priText)
                    .multilineTextAlignment(.center)

                Text("Choose the region that speaks to your soul.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(ob_secText)
                    .multilineTextAlignment(.center)
            }
            .opacity(appeared ? 1 : 0)
            .padding(.horizontal)

            Spacer().frame(height: 24)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(regions, id: \.id) { r in
                    VibeCard(
                        emoji: r.emoji,
                        label: r.label,
                        desc: r.desc,
                        isSelected: selectedRegion == r.id
                    ) {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        selectedRegion = r.id
                    }
                    .opacity(appeared ? 1 : 0)
                }
            }
            .padding(.horizontal)

            Spacer()

            OBCTAButton(
                label: selectedRegion.isEmpty ? "Choose a region" : "Build My Profile →",
                enabled: !selectedRegion.isEmpty
            ) {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                onContinue()
            }

            Spacer().frame(height: 40)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.55).delay(0.1)) { appeared = true }
        }
    }
}

// ══════════════════════════════════════════════════════════════════════
// MARK: - Screen 6: Analyzing
// ══════════════════════════════════════════════════════════════════════

private struct AnalyzingScreenView: View {
    let userName: String
    let progress: Double
    let pageIndex: Int
    let totalPages: Int

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var spinAngle: Double = 0
    @State private var pulseScale: CGFloat = 0.95
    @State private var stepIndex = 0

    private let steps = [
        "Reading your vibe preferences…",
        "Analyzing fragrance chemistry…",
        "Mapping color-to-scent patterns…",
        "Curating your personal wardrobe…",
        "Calibrating AI recommendations…",
    ]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Spinner orb
            ZStack {
                // Outer rings
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .stroke(
                            AngularGradient(
                                colors: [ob_emerald.opacity(0.6), ob_gold.opacity(0.4), ob_emerald.opacity(0)],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: CGFloat(3 - i), lineCap: .round)
                        )
                        .frame(width: CGFloat(120 + i * 24), height: CGFloat(120 + i * 24))
                        .rotationEffect(.degrees(spinAngle + Double(i) * 60))
                }

                // Inner core
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [ob_teal.opacity(0.7), ob_bg],
                            center: .center, startRadius: 4, endRadius: 50
                        )
                    )
                    .frame(width: 90, height: 90)
                    .scaleEffect(pulseScale)

                Image(systemName: "wand.and.stars")
                    .font(.system(size: 32, weight: .ultraLight))
                    .foregroundStyle(ob_gold)
                    .scaleEffect(pulseScale)
            }
            .accessibilityHidden(true)

            Spacer().frame(height: 36)

            VStack(spacing: 10) {
                let greeting = userName.isEmpty ? "Creating your scent profile…" : "Crafting \(userName)'s profile…"
                Text(greeting)
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundStyle(ob_priText)
                    .multilineTextAlignment(.center)

                Text(steps[min(stepIndex, steps.count - 1)])
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(ob_secText)
                    .animation(.easeInOut(duration: 0.4), value: stepIndex)
            }
            .padding(.horizontal, 32)

            Spacer().frame(height: 36)

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.08))

                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [ob_gold, ob_emerald],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(height: 8)
            .padding(.horizontal, 44)

            Spacer().frame(height: 12)

            Text("\(Int(progress * 100))%")
                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                .foregroundStyle(ob_secText)

            Spacer()
        }
        .onAppear { startAnimations() }
    }

    private func startAnimations() {
        guard !reduceMotion else { return }

        withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
            spinAngle = 360
        }
        withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
            pulseScale = 1.06
        }

        // Step through messages
        for i in 0..<steps.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.44) {
                withAnimation { stepIndex = i }
            }
        }
    }
}

// ══════════════════════════════════════════════════════════════════════
// MARK: - Screen 7: Archetype Reveal
// ══════════════════════════════════════════════════════════════════════

private struct ArchetypeRevealView: View {
    let archetype: ScentArchetype
    let userName: String
    let pageIndex: Int
    let totalPages: Int
    let onContinue: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var emojiScale: CGFloat = 0.3
    @State private var titleOpacity: Double = 0
    @State private var detailsOpacity: Double = 0
    @State private var ctaOpacity: Double = 0
    @State private var badgeBounce = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                OBProgressDots(current: pageIndex, total: totalPages)
                Spacer()
            }
            .padding(.top, 16)
            .padding(.horizontal)

            Spacer()

            // Archetype badge
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [archetype.accentColor.opacity(0.3), ob_bg],
                            center: .center, startRadius: 20, endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)

                Circle()
                    .stroke(archetype.accentColor.opacity(0.4), lineWidth: 1.5)
                    .frame(width: 130, height: 130)

                Text(archetype.emoji)
                    .font(.system(size: 68))
                    .scaleEffect(emojiScale)
                    .scaleEffect(badgeBounce && !reduceMotion ? 1.08 : 1.0)
            }

            Spacer().frame(height: 28)

            VStack(spacing: 12) {
                Group {
                    if !userName.isEmpty {
                        Text("\(userName), you're")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(ob_secText)
                    }
                }

                Text(archetype.title)
                    .font(.system(size: 32, weight: .bold, design: .serif))
                    .foregroundStyle(ob_priText)
                    .multilineTextAlignment(.center)

                Text(archetype.tagline)
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundStyle(archetype.accentColor)
                    .italic()
            }
            .opacity(titleOpacity)
            .padding(.horizontal, 28)

            Spacer().frame(height: 24)

            // Accord pills
            HStack(spacing: 8) {
                ForEach(archetype.accords, id: \.self) { accord in
                    Text(accord)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(ob_priText)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Capsule().fill(ob_surface).overlay(Capsule().stroke(archetype.accentColor.opacity(0.35), lineWidth: 1)))
                }
            }
            .opacity(detailsOpacity)

            Spacer().frame(height: 16)

            // First badge unlock hint
            HStack(spacing: 10) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(ob_gold)

                Text("Your journey starts now — earn your first badge!")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(ob_secText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ob_surface)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(ob_gold.opacity(0.25), lineWidth: 1))
            )
            .padding(.horizontal, 28)
            .opacity(detailsOpacity)

            Spacer()

            OBCTAButton(label: "Unlock My Scent Journey →") {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                onContinue()
            }
            .opacity(ctaOpacity)

            Spacer().frame(height: 40)
        }
        .onAppear { runEntrance() }
    }

    private func runEntrance() {
        if reduceMotion {
            emojiScale = 1; titleOpacity = 1; detailsOpacity = 1; ctaOpacity = 1; return
        }
        GamificationHaptics.successfulMatch()

        withAnimation(.interpolatingSpring(mass: 1, stiffness: 140, damping: 14).delay(0.1)) {
            emojiScale = 1.0
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.4)) { titleOpacity = 1 }
        withAnimation(.easeOut(duration: 0.4).delay(0.7)) { detailsOpacity = 1 }
        withAnimation(.easeOut(duration: 0.4).delay(0.9)) { ctaOpacity = 1 }
        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(0.4)) {
            badgeBounce = true
        }
    }
}

// ══════════════════════════════════════════════════════════════════════
// MARK: - Screen 8: Onboarding Paywall
// ══════════════════════════════════════════════════════════════════════

private struct OnboardingPaywallScreen: View {
    let onComplete: () -> Void

    @State private var appeared = false
    @State private var isLoading = false

    private let features = [
        ("Unlimited Scent Matches",         "camera.fill"),
        ("86+ Fragrances from 5 Regions",   "globe.americas.fill"),
        ("Personal Fragrance Wardrobe",      "hanger"),
        ("AI Recommendations",               "brain.head.profile.fill"),
        ("Daily Quests & Badges",            "star.circle.fill"),
        ("Daily Vibe Notifications",         "bell.badge.fill"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 10) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 40, weight: .light))
                    .foregroundStyle(
                        LinearGradient(colors: [ob_gold, ob_goldLt], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .opacity(appeared ? 1 : 0)
                    .scaleEffect(appeared ? 1 : 0.5)

                Text("Unlock ScentVibe Pro")
                    .font(.system(size: 26, weight: .bold, design: .serif))
                    .foregroundStyle(ob_priText)

                Text("Join 50,000+ scent lovers")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(ob_secText)
            }
            .padding(.top, 40)
            .opacity(appeared ? 1 : 0)

            Spacer().frame(height: 24)

            // Features
            VStack(spacing: 10) {
                ForEach(features, id: \.0) { f in
                    HStack(spacing: 14) {
                        Image(systemName: f.1)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(ob_emerald)
                            .frame(width: 22)

                        Text(f.0)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(ob_priText)

                        Spacer()

                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(ob_emerald)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(.horizontal, 28)
            .opacity(appeared ? 1 : 0)

            Spacer()

            // Price
            VStack(spacing: 6) {
                Text("$7.99 / month")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(ob_priText)

                Text("or $49.99/yr · $79.99 lifetime")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(ob_secText)

                Text("3-day free trial included")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(ob_emerald)
            }
            .opacity(appeared ? 1 : 0)

            Spacer().frame(height: 20)

            // CTA
            OBCTAButton(label: isLoading ? "Starting Trial…" : "Start Free Trial →") {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                isLoading = true
                Task {
                    _ = try? await PaywallManager.shared.purchase(tier: .monthly)
                    await MainActor.run { onComplete() }
                }
            }
            .opacity(appeared ? 1 : 0)

            Spacer().frame(height: 8)

            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                onComplete()   // Skip / "Maybe later"
            }) {
                Text("Maybe Later")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(ob_secText)
            }
            .opacity(appeared ? 1 : 0)

            Spacer().frame(height: 16)

            Text("Cancel anytime. Recurring billing. See Terms & Privacy.")
                .font(.system(size: 10, weight: .regular))
                .foregroundStyle(ob_secText.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)
                .opacity(appeared ? 1 : 0)

            Spacer().frame(height: 24)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.1)) { appeared = true }
        }
    }
}

// ══════════════════════════════════════════════════════════════════════
// MARK: - Shared SimpleChoiceCard
// ══════════════════════════════════════════════════════════════════════

private struct SimpleChoiceCard: View {
    let emoji: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(emoji).font(.system(size: 24))

                Text(label)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(isSelected ? ob_bg : ob_priText)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)

                Spacer()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        isSelected
                            ? LinearGradient(colors: [ob_gold, ob_emerald], startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(colors: [ob_surface, ob_surface], startPoint: .leading, endPoint: .trailing)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(isSelected ? Color.clear : Color.white.opacity(0.07), lineWidth: 1)
                    )
            )
            .scaleEffect(isSelected ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}
