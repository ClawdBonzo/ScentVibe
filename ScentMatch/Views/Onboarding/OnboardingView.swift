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

            VStack(spacing: 0) {
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        pageView(page: page)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Bottom controls
                VStack(spacing: 20) {
                    // Page dots
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Capsule()
                                .fill(index == currentPage ? pages[currentPage].accentColor : Color.smTextTertiary.opacity(0.4))
                                .frame(width: index == currentPage ? 24 : 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }

                    // CTA button
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
                        .foregroundStyle(.smBackground)
                        .frame(maxWidth: .infinity)
                        .frame(height: SMTheme.buttonHeight)
                        .background(
                            currentPage == pages.count - 1 ?
                            LinearGradient.smGoldGradient :
                            LinearGradient.smPrimaryGradient
                        )
                        .clipShape(RoundedRectangle(cornerRadius: SMTheme.cornerRadius))
                    }

                    if currentPage < pages.count - 1 {
                        Button(action: { onComplete() }) {
                            Text(String(localized: "onboarding_skip", defaultValue: "Skip"))
                                .font(SMFont.caption())
                                .foregroundStyle(.smTextTertiary)
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

    private func pageView(page: OnboardingPage) -> some View {
        VStack(spacing: 32) {
            Spacer()

            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [page.accentColor.opacity(0.15), .clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)

                Image(systemName: page.icon)
                    .font(.system(size: 64, weight: .thin))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [page.accentColor, page.accentColor.opacity(0.6)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)

            VStack(spacing: 14) {
                Text(page.title)
                    .font(SMFont.display(28))
                    .foregroundStyle(.smTextPrimary)
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(SMFont.body())
                    .foregroundStyle(.smTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
            .opacity(showContent ? 1 : 0)

            Spacer()
            Spacer()
        }
    }

    private func advance() {
        if currentPage < pages.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
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
