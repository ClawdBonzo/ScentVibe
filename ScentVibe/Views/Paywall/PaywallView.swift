import SwiftUI
import SwiftData

// MARK: - PaywallView (Router)
// Shows the normal paywall on first encounter, then the promotional
// win-back offer on every subsequent visit for non-subscribers.

struct PaywallView: View {
    @AppStorage("hasSeenNormalPaywall") private var hasSeenNormalPaywall = false

    var body: some View {
        if hasSeenNormalPaywall && !PaywallManager.shared.isPremium {
            PromoPaywallView()
        } else {
            NormalPaywallView()
        }
    }
}

// MARK: - Normal Paywall

private struct NormalPaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query private var profiles: [UserProfile]
    @State private var selectedTier: PaywallTier = .yearly
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showContent = false
    @State private var socialProofIndex = 0
    @State private var crownPulse = false

    @AppStorage("vibeAlignmentScore") private var storedVibeScore: Int = 0
    @AppStorage("hasSeenNormalPaywall") private var hasSeenNormalPaywall = false

    private var profile: UserProfile? { profiles.first }

    private let socialProofMessages = [
        "2,847 scent lovers joined this week",
        "Rated 4.9★ by fragrance enthusiasts",
        "Join 50,000+ who found their signature scent",
        "Featured in Vogue, GQ & Hypebeast",
    ]

    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.smBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        heroSection

                        VStack(spacing: 10) {
                            featureRow(icon: "infinity", text: "Unlimited scent matches")
                            featureRow(icon: "person.crop.rectangle.fill", text: "Personalized scent wardrobe")
                            featureRow(icon: "globe", text: "86+ fragrances from 5 regions")
                            featureRow(icon: "star.fill", text: "Premium AI recommendations")
                            featureRow(icon: "bell.fill", text: "New fragrance alerts")
                        }
                        .padding(.horizontal, 24)

                        VStack(spacing: 10) {
                            ForEach(PaywallTier.allCases) { tier in
                                tierCard(tier: tier)
                            }
                        }

                        purchaseButton

                        Button(action: {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            restore()
                        }) {
                            Text("Restore Purchases")
                                .font(SMFont.caption())
                                .foregroundStyle(Color.smTextTertiary)
                        }

                        legalText

                        Spacer(minLength: 40)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.smTextSecondary)
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            if reduceMotion {
                showContent = true
            } else {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) { showContent = true }
            }
            EventLogger.shared.log(EventLogger.paywallShown)
            // Mark that the user has seen the normal paywall — next time they
            // hit the paywall they'll see the promotional win-back offer.
            hasSeenNormalPaywall = true
        }
        .onReceive(timer) { _ in
            guard !reduceMotion else { return }
            withAnimation {
                socialProofIndex = (socialProofIndex + 1) % socialProofMessages.count
            }
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(colors: [.smGold.opacity(0.2), .clear],
                                       center: .center, startRadius: 10, endRadius: 70)
                    )
                    .frame(width: 140, height: 140)

                Image(systemName: "crown.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(LinearGradient.smGoldGradient)
                    .scaleEffect(crownPulse ? 1.06 : 0.96)
                    .onAppear {
                        guard !reduceMotion else { return }
                        withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                            crownPulse = true
                        }
                    }
            }

            Text("Unlock ScentVibe Pro")
                .font(SMFont.display(28))
                .foregroundStyle(Color.smTextPrimary)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)

            Text(socialProofMessages[socialProofIndex])
                .font(SMFont.caption(12))
                .foregroundStyle(Color.smGold)
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
                .id(socialProofIndex)
                .animation(.easeInOut(duration: 0.4), value: socialProofIndex)

            if let profile = profile {
                Text("You've used \(profile.totalMatchesUsed) of \(UserProfile.freeMatchLimit) free matches")
                    .font(SMFont.body(14))
                    .foregroundStyle(Color.smTextSecondary)
            }
        }
    }

    // MARK: - Helpers

    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 18))
                .foregroundStyle(Color.smEmerald)
            Text(text)
                .font(SMFont.body(15))
                .foregroundStyle(Color.smTextPrimary)
            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(text)
    }

    private func tierCard(tier: PaywallTier) -> some View {
        let isSelected = selectedTier == tier
        return Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { selectedTier = tier }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }) {
            HStack(spacing: 12) {
                Circle()
                    .stroke(isSelected ? Color.smGold : Color.smTextTertiary, lineWidth: 2)
                    .frame(width: 22, height: 22)
                    .overlay {
                        if isSelected {
                            Circle().fill(Color.smGold).frame(width: 12, height: 12)
                        }
                    }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(tier.title)
                            .font(SMFont.headline(16))
                            .foregroundStyle(Color.smTextPrimary)
                        if let savings = tier.savings {
                            Text(savings)
                                .font(SMFont.label(10))
                                .foregroundStyle(tier.isPopular ? Color.smBackground : Color.smGold)
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(tier.isPopular ? Color.smGold : Color.smGold.opacity(0.15))
                                .clipShape(Capsule())
                        }
                    }
                    Text(tier.pricePerMonth)
                        .font(SMFont.caption(12))
                        .foregroundStyle(Color.smTextSecondary)
                }
                Spacer()
                Text(tier.price)
                    .font(SMFont.headline(18))
                    .foregroundStyle(isSelected ? Color.smGold : Color.smTextSecondary)
            }
            .padding(14)
            .background(Color.smSurfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.smGold : Color.clear, lineWidth: 1.5)
            )
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(tier.title), \(tier.price)\(tier.savings.map { ", \($0)" } ?? "")")
        .accessibilityHint(isSelected ? "Currently selected" : "Double-tap to select this plan")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var purchaseButton: some View {
        Button(action: purchase) {
            HStack {
                if isPurchasing {
                    ProgressView().tint(Color.smBackground)
                } else {
                    Text("Continue with \(selectedTier.title)")
                        .font(SMFont.headline(17))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .bold))
                }
            }
            .foregroundStyle(Color.smBackground)
            .frame(maxWidth: .infinity)
            .frame(height: SMTheme.buttonHeight)
            .background(LinearGradient.smGoldGradient)
            .clipShape(RoundedRectangle(cornerRadius: SMTheme.cornerRadius))
        }
        .disabled(isPurchasing)
        .accessibilityLabel(isPurchasing ? "Purchasing" : "Continue with \(selectedTier.title)")
        .accessibilityHint("Subscribes to the \(selectedTier.title) plan")
    }

    private var legalText: some View {
        VStack(spacing: 6) {
            Text("Payment will be charged to your Apple ID account at confirmation of purchase. Subscription automatically renews unless canceled at least 24 hours before the end of the current period.")
                .font(SMFont.label(9))
                .foregroundStyle(Color.smTextTertiary)
                .multilineTextAlignment(.center)
            HStack(spacing: 12) {
                Link("Terms of Use", destination: URL(string: "https://scentvibe-app.netlify.app/terms")!)
                    .font(SMFont.label(10))
                    .foregroundStyle(Color.smTextTertiary)
                Link("Privacy Policy", destination: URL(string: "https://scentvibe-app.netlify.app/privacy")!)
                    .font(SMFont.label(10))
                    .foregroundStyle(Color.smTextTertiary)
            }
        }
    }

    // MARK: - Actions

    private func purchase() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        isPurchasing = true
        Task {
            do {
                try await PaywallManager.shared.purchase(tier: selectedTier)
                profile?.isPremium = true
                EventLogger.shared.log(EventLogger.paywallConverted, metadata: [
                    "tier": selectedTier.title, "price": selectedTier.price,
                ])
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
            isPurchasing = false
        }
    }

    private func restore() {
        isPurchasing = true
        Task {
            do {
                try await PaywallManager.shared.restorePurchases()
                if PaywallManager.shared.isPremium {
                    profile?.isPremium = true
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    dismiss()
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
            isPurchasing = false
        }
    }
}

// MARK: - Promotional Win-Back Paywall

struct PromoPaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query private var profiles: [UserProfile]

    @State private var selectedTier: PaywallTier = .yearly
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showContent = false
    @State private var showConfetti = false
    @State private var badgePulse = false
    @State private var countdownSeconds = 900  // 15 minute urgency timer
    @State private var socialProofIndex = 0

    private var profile: UserProfile? { profiles.first }

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let proofTimer = Timer.publish(every: 3.5, on: .main, in: .common).autoconnect()

    private let socialProof = [
        "1,247 people claimed this offer today",
        "Rated 4.9★ — \"Worth every penny\" — @scentlover",
        "This offer expires soon — don't miss out",
        "Join 50,000+ fragrance enthusiasts",
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.smBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        promoBanner

                        heroSection

                        VStack(spacing: 10) {
                            featureRow(icon: "infinity", text: "Unlimited scent matches")
                            featureRow(icon: "person.crop.rectangle.fill", text: "Personalized scent wardrobe")
                            featureRow(icon: "globe", text: "86+ fragrances from 5 regions")
                            featureRow(icon: "star.fill", text: "Premium AI recommendations")
                            featureRow(icon: "bell.fill", text: "New fragrance alerts")
                        }
                        .padding(.horizontal, 24)

                        VStack(spacing: 10) {
                            ForEach(PaywallTier.allCases) { tier in
                                promoTierCard(tier: tier)
                            }
                        }

                        promoCtaButton

                        Button(action: {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            restore()
                        }) {
                            Text("Restore Purchases")
                                .font(SMFont.caption())
                                .foregroundStyle(Color.smTextTertiary)
                        }

                        legalText

                        Spacer(minLength: 40)
                    }
                    .padding()
                }

                // Confetti celebration on purchase
                ConfettiView(isActive: $showConfetti)
                    .zIndex(999)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.smTextSecondary)
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            if reduceMotion {
                showContent = true
            } else {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) { showContent = true }
            }
            EventLogger.shared.log(EventLogger.paywallShown, metadata: ["type": "promo_winback"])
        }
        .onReceive(timer) { _ in
            if countdownSeconds > 0 { countdownSeconds -= 1 }
        }
        .onReceive(proofTimer) { _ in
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 0.4)) {
                socialProofIndex = (socialProofIndex + 1) % socialProof.count
            }
        }
    }

    // MARK: - Promo Banner

    private var promoBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "tag.fill")
                .font(.system(size: 14))
                .foregroundStyle(Color.smBackground)

            Text("Welcome back! Special offer just for you")
                .font(SMFont.label(13))
                .foregroundStyle(Color.smBackground)

            Spacer()

            Text(countdownFormatted)
                .font(SMFont.mono(13))
                .foregroundStyle(Color.smBackground.opacity(0.9))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(LinearGradient.smGoldGradient)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Special promotional offer. Time remaining: \(countdownFormatted)")
    }

    private var countdownFormatted: String {
        let m = countdownSeconds / 60
        let s = countdownSeconds % 60
        return String(format: "%d:%02d", m, s)
    }

    // MARK: - Hero

    private var heroSection: some View {
        VStack(spacing: 14) {
            ZStack {
                // Animated glow ring
                Circle()
                    .fill(
                        RadialGradient(colors: [.smGold.opacity(0.25), .smEmerald.opacity(0.08), .clear],
                                       center: .center, startRadius: 10, endRadius: 80)
                    )
                    .frame(width: 160, height: 160)

                Image(systemName: "gift.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(LinearGradient.smGoldGradient)
                    .scaleEffect(badgePulse ? 1.08 : 0.94)
                    .onAppear {
                        guard !reduceMotion else { return }
                        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                            badgePulse = true
                        }
                    }

                // Discount badge
                Text(selectedTier.promoDiscount)
                    .font(SMFont.label(11))
                    .foregroundStyle(Color.smBackground)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.smEmerald)
                    .clipShape(Capsule())
                    .offset(x: 45, y: -45)
                    .accessibilityHidden(true)
            }

            Text("We Missed You!")
                .font(SMFont.display(28))
                .foregroundStyle(Color.smTextPrimary)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)

            Text("Unlock Pro at a special price — just for returning users")
                .font(SMFont.body(15))
                .foregroundStyle(Color.smTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)

            Text(socialProof[socialProofIndex])
                .font(SMFont.caption(12))
                .foregroundStyle(Color.smGold)
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
                .id(socialProofIndex)
                .animation(.easeInOut(duration: 0.4), value: socialProofIndex)

            if let profile = profile {
                Text("You've used \(profile.totalMatchesUsed) of \(UserProfile.freeMatchLimit) free matches")
                    .font(SMFont.body(14))
                    .foregroundStyle(Color.smTextSecondary)
            }
        }
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : 20)
    }

    // MARK: - Helpers

    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 18))
                .foregroundStyle(Color.smEmerald)
            Text(text)
                .font(SMFont.body(15))
                .foregroundStyle(Color.smTextPrimary)
            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(text)
    }

    // MARK: - Promo Tier Card

    private func promoTierCard(tier: PaywallTier) -> some View {
        let isSelected = selectedTier == tier
        return Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { selectedTier = tier }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }) {
            HStack(spacing: 12) {
                Circle()
                    .stroke(isSelected ? Color.smGold : Color.smTextTertiary, lineWidth: 2)
                    .frame(width: 22, height: 22)
                    .overlay {
                        if isSelected {
                            Circle().fill(Color.smGold).frame(width: 12, height: 12)
                        }
                    }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(tier.title)
                            .font(SMFont.headline(16))
                            .foregroundStyle(Color.smTextPrimary)

                        // Discount badge
                        Text(tier.promoDiscount)
                            .font(SMFont.label(9))
                            .foregroundStyle(Color.smBackground)
                            .padding(.horizontal, 6).padding(.vertical, 2)
                            .background(Color.smEmerald)
                            .clipShape(Capsule())

                        if tier.isPopular {
                            Text("BEST DEAL")
                                .font(SMFont.label(9))
                                .foregroundStyle(Color.smBackground)
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(Color.smGold)
                                .clipShape(Capsule())
                        }
                    }

                    HStack(spacing: 6) {
                        // Crossed-out original price
                        Text(tier.pricePerMonth)
                            .font(SMFont.caption(12))
                            .foregroundStyle(Color.smTextTertiary)
                            .strikethrough(true, color: Color.smTextTertiary)

                        Text(tier.promoPricePerMonth)
                            .font(SMFont.caption(12))
                            .foregroundStyle(Color.smEmerald)
                    }
                }
                Spacer()

                VStack(alignment: .trailing, spacing: 1) {
                    Text(tier.price)
                        .font(SMFont.caption(13))
                        .foregroundStyle(Color.smTextTertiary)
                        .strikethrough(true, color: Color.smTextTertiary)
                    Text(tier.promoPrice)
                        .font(SMFont.headline(18))
                        .foregroundStyle(isSelected ? Color.smGold : Color.smTextSecondary)
                }
            }
            .padding(14)
            .background(Color.smSurfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.smGold : Color.clear, lineWidth: 1.5)
            )
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(tier.title), \(tier.promoDiscount), was \(tier.price), now \(tier.promoPrice)")
        .accessibilityHint(isSelected ? "Currently selected" : "Double-tap to select this plan")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    // MARK: - CTA Button

    private var promoCtaButton: some View {
        Button(action: purchasePromo) {
            HStack(spacing: 8) {
                if isPurchasing {
                    ProgressView().tint(Color.smBackground)
                } else {
                    Image(systemName: "gift.fill")
                        .font(.system(size: 15, weight: .semibold))
                    Text("Claim \(selectedTier.promoDiscount) — \(selectedTier.promoPrice)")
                        .font(SMFont.headline(17))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .bold))
                }
            }
            .foregroundStyle(Color.smBackground)
            .frame(maxWidth: .infinity)
            .frame(height: SMTheme.buttonHeight)
            .background(
                LinearGradient(
                    colors: [.smEmerald, Color(red: 0.15, green: 0.55, blue: 0.40)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: SMTheme.cornerRadius))
            .shadow(color: .smEmerald.opacity(0.3), radius: 12, y: 4)
        }
        .disabled(isPurchasing)
        .accessibilityLabel(isPurchasing ? "Purchasing" : "Claim \(selectedTier.promoDiscount) discount for \(selectedTier.promoPrice)")
        .accessibilityHint("Subscribes to the \(selectedTier.title) plan at the promotional price")
    }

    private var legalText: some View {
        VStack(spacing: 6) {
            Text("Promotional pricing applies to first billing period. Payment will be charged to your Apple ID account at confirmation. Subscription auto-renews at regular price unless canceled 24 hours before period end.")
                .font(SMFont.label(9))
                .foregroundStyle(Color.smTextTertiary)
                .multilineTextAlignment(.center)
            HStack(spacing: 12) {
                Link("Terms of Use", destination: URL(string: "https://scentvibe-app.netlify.app/terms")!)
                    .font(SMFont.label(10))
                    .foregroundStyle(Color.smTextTertiary)
                Link("Privacy Policy", destination: URL(string: "https://scentvibe-app.netlify.app/privacy")!)
                    .font(SMFont.label(10))
                    .foregroundStyle(Color.smTextTertiary)
            }
        }
    }

    // MARK: - Actions

    private func purchasePromo() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        isPurchasing = true
        Task {
            do {
                try await PaywallManager.shared.purchaseWithPromo(tier: selectedTier)
                profile?.isPremium = true
                EventLogger.shared.log(EventLogger.paywallConverted, metadata: [
                    "tier": selectedTier.title,
                    "price": selectedTier.promoPrice,
                    "type": "promo_winback",
                    "discount": selectedTier.promoDiscount,
                ])
                UINotificationFeedbackGenerator().notificationOccurred(.success)

                // Show confetti celebration before dismissing
                showConfetti = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    dismiss()
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
            isPurchasing = false
        }
    }

    private func restore() {
        isPurchasing = true
        Task {
            do {
                try await PaywallManager.shared.restorePurchases()
                if PaywallManager.shared.isPremium {
                    profile?.isPremium = true
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    dismiss()
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
            isPurchasing = false
        }
    }
}
