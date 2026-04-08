import Foundation
import SwiftUI

// MARK: - Paywall Manager

@Observable
final class PaywallManager {
    static let shared = PaywallManager()

    // Product identifiers (configure in RevenueCat dashboard)
    static let weeklyProductId = "scentvibe_weekly_499"
    static let monthlyProductId = "scentvibe_monthly_799"
    static let yearlyProductId = "scentvibe_yearly_4999"
    static let lifetimeProductId = "scentvibe_lifetime_7999"

    var isPremium: Bool = false
    var isLoading: Bool = false

    private init() {
        // In production, configure RevenueCat here:
        // Purchases.configure(withAPIKey: "your_revenuecat_api_key")
        // checkSubscriptionStatus()
    }

    // MARK: - RevenueCat Integration Points

    func configure() {
        // TODO: Uncomment when RevenueCat SDK is added
        // Purchases.configure(withAPIKey: "appl_YOUR_API_KEY")
        // Purchases.shared.delegate = self
        checkSubscriptionStatus()
    }

    func checkSubscriptionStatus() {
        // TODO: Replace with RevenueCat implementation
        // Purchases.shared.getCustomerInfo { customerInfo, error in
        //     self.isPremium = customerInfo?.entitlements["premium"]?.isActive ?? false
        // }
    }

    func purchase(tier: PaywallTier) async throws {
        isLoading = true
        defer { isLoading = false }

        // TODO: Replace with RevenueCat implementation
        // let product = try await Purchases.shared.products([tier.productId]).first
        // let (_, customerInfo, _) = try await Purchases.shared.purchase(product: product!)
        // isPremium = customerInfo.entitlements["premium"]?.isActive ?? false

        // Simulated purchase for development
        try await Task.sleep(nanoseconds: 1_500_000_000)
        isPremium = true
    }

    func restorePurchases() async throws {
        isLoading = true
        defer { isLoading = false }

        // TODO: Replace with RevenueCat
        // let customerInfo = try await Purchases.shared.restorePurchases()
        // isPremium = customerInfo.entitlements["premium"]?.isActive ?? false

        try await Task.sleep(nanoseconds: 1_000_000_000)
    }

    // MARK: - Promotional Offer Purchase

    /// Purchase with a promotional discount applied.
    /// In production this calls RevenueCat's promotional offer API.
    func purchaseWithPromo(tier: PaywallTier) async throws {
        isLoading = true
        defer { isLoading = false }

        // TODO: Replace with RevenueCat promotional offer implementation
        // let product = try await Purchases.shared.products([tier.productId]).first!
        // let promoOffer = try await Purchases.shared.promotionalOffer(
        //     forProductDiscount: product.discounts.first!,
        //     product: product
        // )
        // let (_, customerInfo, _) = try await Purchases.shared.purchase(
        //     product: product,
        //     promotionalOffer: promoOffer
        // )
        // isPremium = customerInfo.entitlements["premium"]?.isActive ?? false

        // Simulated promo purchase for development
        try await Task.sleep(nanoseconds: 1_500_000_000)
        isPremium = true
    }
}

// MARK: - Paywall Tier

enum PaywallTier: CaseIterable, Identifiable {
    case weekly
    case monthly
    case yearly
    case lifetime

    var id: String { productId }

    var productId: String {
        switch self {
        case .weekly: return PaywallManager.weeklyProductId
        case .monthly: return PaywallManager.monthlyProductId
        case .yearly: return PaywallManager.yearlyProductId
        case .lifetime: return PaywallManager.lifetimeProductId
        }
    }

    var title: String {
        switch self {
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        case .lifetime: return "Lifetime"
        }
    }

    var price: String {
        switch self {
        case .weekly: return "$4.99"
        case .monthly: return "$7.99"
        case .yearly: return "$49.99"
        case .lifetime: return "$79.99"
        }
    }

    var pricePerMonth: String {
        switch self {
        case .weekly: return "$4.99/wk"
        case .monthly: return "$7.99/mo"
        case .yearly: return "$4.17/mo"
        case .lifetime: return "One time"
        }
    }

    /// Subtitle shown under the tier title (trial info, etc.)
    var trialNote: String? {
        switch self {
        case .monthly: return "3-day free trial"
        default: return nil
        }
    }

    var savings: String? {
        switch self {
        case .weekly: return nil
        case .monthly: return "BEST VALUE"
        case .yearly: return "Most Popular"
        case .lifetime: return nil
        }
    }

    var isPopular: Bool {
        self == .monthly
    }

    // MARK: - Promotional Pricing

    var promoPrice: String {
        switch self {
        case .weekly: return "$2.99"
        case .monthly: return "$5.59"
        case .yearly: return "$34.99"
        case .lifetime: return "$59.99"
        }
    }

    var promoPricePerMonth: String {
        switch self {
        case .weekly: return "$2.99/wk"
        case .monthly: return "$5.59/mo"
        case .yearly: return "$2.92/mo"
        case .lifetime: return "One time"
        }
    }

    var promoDiscount: String {
        switch self {
        case .weekly: return "40% OFF"
        case .monthly: return "30% OFF"
        case .yearly: return "30% OFF"
        case .lifetime: return "25% OFF"
        }
    }
}
