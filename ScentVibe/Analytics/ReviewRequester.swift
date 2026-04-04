import StoreKit
import SwiftUI

// MARK: - StoreKit Review Helper

/// Manages in-app review requests with a single-ask policy.
/// Triggers after the user saves their **second** match to My Vibe Wardrobe,
/// proving genuine engagement before asking for a rating.
enum ReviewRequester {

    @AppStorage("numberOfSavedMatches") private static var numberOfSavedMatches = 0
    @AppStorage("hasRequestedReview") private static var hasRequestedReview = false

    /// Call each time the user saves a match to their wardrobe.
    /// The review prompt fires exactly once — after the second save.
    static func trackSaveAndRequestIfEligible() {
        numberOfSavedMatches += 1

        guard numberOfSavedMatches >= 2, !hasRequestedReview else { return }
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
