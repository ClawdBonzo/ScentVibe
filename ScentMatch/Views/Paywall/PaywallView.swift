import SwiftUI
import SwiftData

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @State private var selectedTier: PaywallTier = .yearly
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var errorMessage = ""

    private var profile: UserProfile? {
        profiles.first
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.smBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 28) {
                        // Hero
                        heroSection

                        // Value props
                        valuePropsSection

                        // Pricing tiers
                        pricingSection

                        // CTA
                        purchaseButton

                        // Restore
                        Button(action: restore) {
                            Text("Restore Purchases")
                                .font(SMFont.caption())
                                .foregroundStyle(.smTextTertiary)
                        }

                        // Legal
                        legalText

                        Spacer(minLength: 40)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.smTextSecondary)
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
            EventLogger.shared.log(EventLogger.paywallShown)
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.smGold.opacity(0.2), .clear],
                            center: .center,
                            startRadius: 10,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)

                Image(systemName: "crown.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(LinearGradient.smGoldGradient)
            }

            Text("Unlock ScentMatch Pro")
                .font(SMFont.display(28))
                .foregroundStyle(.smTextPrimary)
                .multilineTextAlignment(.center)

            if let profile = profile {
                Text("You've used \(profile.totalMatchesUsed) of \(UserProfile.freeMatchLimit) free matches")
                    .font(SMFont.body(14))
                    .foregroundStyle(.smTextSecondary)
            }
        }
    }

    // MARK: - Value Props

    private var valuePropsSection: some View {
        VStack(spacing: 14) {
            valueProp(icon: "infinity", title: "Unlimited Scent Matches", subtitle: "Scan as many outfits & rooms as you want")
            valueProp(icon: "person.crop.rectangle.fill", title: "Personalized Scent Wardrobe", subtitle: "Build your fragrance collection profile")
            valueProp(icon: "globe", title: "Global Fragrance Library", subtitle: "Access 86+ curated scents from 5 regions")
            valueProp(icon: "star.fill", title: "Premium Recommendations", subtitle: "Enhanced matching with deeper explanations")
        }
    }

    private func valueProp(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(.smEmerald)
                .frame(width: 36, height: 36)
                .background(Color.smEmerald.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(SMFont.headline(15))
                    .foregroundStyle(.smTextPrimary)
                Text(subtitle)
                    .font(SMFont.caption(12))
                    .foregroundStyle(.smTextSecondary)
            }

            Spacer()
        }
        .padding(12)
        .background(Color.smSurfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Pricing

    private var pricingSection: some View {
        VStack(spacing: 10) {
            ForEach(PaywallTier.allCases) { tier in
                pricingCard(tier: tier)
            }
        }
    }

    private func pricingCard(tier: PaywallTier) -> some View {
        let isSelected = selectedTier == tier

        return Button(action: { selectedTier = tier }) {
            HStack(spacing: 12) {
                // Radio
                Circle()
                    .stroke(isSelected ? Color.smEmerald : Color.smTextTertiary, lineWidth: 2)
                    .frame(width: 22, height: 22)
                    .overlay {
                        if isSelected {
                            Circle()
                                .fill(Color.smEmerald)
                                .frame(width: 12, height: 12)
                        }
                    }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(tier.title)
                            .font(SMFont.headline(16))
                            .foregroundStyle(.smTextPrimary)

                        if let savings = tier.savings {
                            Text(savings)
                                .font(SMFont.label(10))
                                .foregroundStyle(tier.isPopular ? .smBackground : .smEmerald)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(tier.isPopular ? Color.smEmerald : Color.smEmerald.opacity(0.15))
                                .clipShape(Capsule())
                        }
                    }
                    Text(tier.pricePerMonth)
                        .font(SMFont.caption(12))
                        .foregroundStyle(.smTextSecondary)
                }

                Spacer()

                Text(tier.price)
                    .font(SMFont.headline(18))
                    .foregroundStyle(isSelected ? .smEmerald : .smTextSecondary)
            }
            .padding(14)
            .background(Color.smSurfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.smEmerald : Color.clear, lineWidth: 1.5)
            )
        }
    }

    // MARK: - Purchase

    private var purchaseButton: some View {
        Button(action: purchase) {
            HStack {
                if isPurchasing {
                    ProgressView()
                        .tint(.smBackground)
                } else {
                    Text("Continue with \(selectedTier.title)")
                        .font(SMFont.headline(17))
                }
            }
            .foregroundStyle(.smBackground)
            .frame(maxWidth: .infinity)
            .frame(height: SMTheme.buttonHeight)
            .background(LinearGradient.smGoldGradient)
            .clipShape(RoundedRectangle(cornerRadius: SMTheme.cornerRadius))
        }
        .disabled(isPurchasing)
    }

    // MARK: - Legal

    private var legalText: some View {
        VStack(spacing: 6) {
            Text("Payment will be charged to your Apple ID account at confirmation of purchase. Subscription automatically renews unless it is canceled at least 24 hours before the end of the current period.")
                .font(SMFont.label(9))
                .foregroundStyle(.smTextTertiary)
                .multilineTextAlignment(.center)

            HStack(spacing: 12) {
                Button("Terms of Use") {}
                    .font(SMFont.label(10))
                    .foregroundStyle(.smTextTertiary)
                Button("Privacy Policy") {}
                    .font(SMFont.label(10))
                    .foregroundStyle(.smTextTertiary)
            }
        }
    }

    // MARK: - Actions

    private func purchase() {
        isPurchasing = true
        Task {
            do {
                try await PaywallManager.shared.purchase(tier: selectedTier)
                profile?.isPremium = true
                EventLogger.shared.log(EventLogger.paywallConverted, metadata: [
                    "tier": selectedTier.title,
                    "price": selectedTier.price
                ])
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
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
                    dismiss()
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
            isPurchasing = false
        }
    }
}
