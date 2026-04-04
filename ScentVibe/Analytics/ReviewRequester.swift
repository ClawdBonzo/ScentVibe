import StoreKit
import SwiftUI

// MARK: - StoreKit Review Helper

/// Manages in-app review requests with a single-ask policy.
/// Triggers only after the user's first save to My Vibe Wardrobe —
/// never during onboarding or first launch.
enum ReviewRequester {

    @AppStorage("hasRequestedReview") private static var hasRequestedReview = false

    /// Call after the user saves a match to their wardrobe.
    /// The prompt fires at most once per lifetime of the install.
    static func requestIfEligible() {
        guard !hasRequestedReview else { return }
        hasRequestedReview = true

        // Brief delay lets the save animation land before the system
        // review sheet appears — feels intentional, not intrusive.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            guard let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
            else { return }

            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
