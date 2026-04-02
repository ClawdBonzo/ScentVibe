import Foundation
import SwiftUI

// MARK: - Paywall Manager

@Observable
final class PaywallManager {
    static let shared = PaywallManager()

    // Product identifiers (configure in RevenueCat dashboard)
    static let monthlyProductId = "scentvibe_monthly_499"
    static let yearlyProductId = "scentvibe_yearly_2999"
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
}

// MARK: - Paywall Tier

enum PaywallTier: CaseIterable, Identifiable {
    case monthly
    case yearly
    case lifetime

    var id: String { productId }

    var productId: String {
        switch self {
        case .monthly: return PaywallManager.monthlyProductId
        case .yearly: return PaywallManager.yearlyProductId
        case .lifetime: return PaywallManager.lifetimeProductId
        }
    }

    var title: String {
        switch self {
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        case .lifetime: return "Lifetime"
        }
    }

    var price: String {
        switch self {
        case .monthly: return "$4.99"
        case .yearly: return "$29.99"
        case .lifetime: return "$79.99"
        }
    }

    var pricePerMonth: String {
        switch self {
        case .monthly: return "$4.99/mo"
        case .yearly: return "$2.50/mo"
        case .lifetime: return "One time"
        }
    }

    var savings: String? {
        switch self {
        case .monthly: return nil
        case .yearly: return "Most Popular"
        case .lifetime: return "Best Value"
        }
    }

    var isPopular: Bool {
        self == .yearly
    }
}
