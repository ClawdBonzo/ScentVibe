import Foundation

/// Manages region-aware Amazon affiliate links using OneLink auto-redirect.
///
/// **Setup instructions:**
/// 1. Sign up at https://affiliate-program.amazon.com (US) and each regional program
/// 2. Apply for Amazon OneLink at https://affiliate-program.amazon.com/onelink
/// 3. Replace the placeholder tags below with your actual associate tags
/// 4. Replace `oneLinkId` with your actual OneLink ID
///
/// OneLink automatically redirects users to their local Amazon store:
/// US user → amazon.com, DE user → amazon.de, etc.
final class AffiliateManager {
    static let shared = AffiliateManager()

    // MARK: - Configuration (Replace with your actual tags)

    /// Your Amazon OneLink ID — get this from the OneLink dashboard
    /// Set to nil to disable OneLink and use direct regional links instead
    private let oneLinkId: String? = nil  // e.g., "a1b2c3d4-5678-90ab-cdef"

    /// Associate tags per region — sign up at each Amazon regional affiliate program
    private let associateTags: [String: String] = [
        "US": "scentmatch0b-20",     // Live Amazon Associates tag
        "DE": "scentmatch-21",      // Replace with your DE tag
        "MX": "scentmatch-22",      // Replace with your MX tag
        "BR": "scentmatch-23",      // Replace with your BR tag
        "FR": "scentmatch-24",      // Replace with your FR tag
        "UK": "scentmatch-25",      // Replace with your UK tag
        "ES": "scentmatch-26",      // Replace with your ES tag
        "IT": "scentmatch-27",      // Replace with your IT tag
    ]

    /// Default tag if region can't be determined
    private let defaultTag = "scentmatch0b-20"

    // MARK: - Regional Amazon Domains

    private let amazonDomains: [String: String] = [
        "US": "www.amazon.com",
        "DE": "www.amazon.de",
        "MX": "www.amazon.com.mx",
        "BR": "www.amazon.com.br",
        "FR": "www.amazon.fr",
        "UK": "www.amazon.co.uk",
        "ES": "www.amazon.es",
        "IT": "www.amazon.it",
        "CA": "www.amazon.ca",
        "JP": "www.amazon.co.jp",
        "AU": "www.amazon.com.au",
    ]

    private init() {}

    // MARK: - Public API

    /// Generate the best affiliate URL for a fragrance.
    /// Uses ASIN + OneLink if available, falls back to search URL.
    func affiliateURL(for fragrance: Fragrance) -> URL? {
        if let asin = fragrance.amazonASIN, !asin.isEmpty {
            return asinURL(asin: asin)
        } else {
            return searchURL(name: fragrance.name, house: fragrance.house)
        }
    }

    // MARK: - URL Builders

    /// Direct ASIN link — uses OneLink if configured, otherwise regional redirect
    private func asinURL(asin: String) -> URL? {
        if let oneLinkId = oneLinkId {
            // OneLink auto-redirects to user's local Amazon
            return URL(string: "https://www.amazon.com/dp/\(asin)?tag=\(currentTag)&linkCode=ogi&th=1&psc=1&onelink=\(oneLinkId)")
        } else {
            // Direct regional link
            let domain = currentDomain
            return URL(string: "https://\(domain)/dp/\(asin)?tag=\(currentTag)")
        }
    }

    /// Search-based link for fragrances without ASIN — every fragrance gets a link
    private func searchURL(name: String, house: String) -> URL? {
        let query = "\(name) \(house) perfume"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        let domain = currentDomain
        return URL(string: "https://\(domain)/s?k=\(query)&tag=\(currentTag)")
    }

    // MARK: - Region Detection

    /// Current region code based on device locale
    private var currentRegionCode: String {
        let code = Locale.current.region?.identifier ?? "US"
        // Map to supported Amazon regions
        switch code {
        case "DE", "AT", "CH": return "DE"  // German-speaking
        case "MX": return "MX"
        case "BR": return "BR"
        case "FR", "BE", "LU", "MC": return "FR"  // French-speaking
        case "GB", "IE": return "UK"
        case "ES", "AR", "CL", "CO", "PE": return "ES"
        case "IT": return "IT"
        case "CA": return "CA"
        case "JP": return "JP"
        case "AU", "NZ": return "AU"
        default: return "US"
        }
    }

    private var currentTag: String {
        associateTags[currentRegionCode] ?? defaultTag
    }

    private var currentDomain: String {
        amazonDomains[currentRegionCode] ?? "www.amazon.com"
    }
}
