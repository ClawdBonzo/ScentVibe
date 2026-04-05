import SwiftUI
import SwiftData

struct PaywallView: View {
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
