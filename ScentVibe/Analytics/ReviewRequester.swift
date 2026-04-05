import StoreKit
import SwiftUI

// MARK: - StoreKit Review Helper

/// Manages in-app review requests with a single-ask policy.
/// Triggers after the user saves their **second** match to My Vibe Wardrobe,
/// proving genuine engagement before asking for a rating.
/// Never fires during onboarding or before the user completes the full flow.
enum ReviewRequester {

    @AppStorage("numberOfSavedMatches") private static var numberOfSavedMatches = 0
    @AppStorage("hasRequestedReview") private static var hasRequestedReview = false
    @AppStorage("hasCompletedOnboarding") private static var hasCompletedOnboarding = false

    /// Call each time the user saves a match to their wardrobe.
    /// The review prompt fires exactly once — after the second save,
    /// only when onboarding is fully complete.
    static func trackSaveAndRequestIfEligible() {
        numberOfSavedMatches += 1

        // Never prompt during or before onboarding completes.
        guard hasCompletedOnboarding else { return }

        // Only ask once, after genuine engagement (2+ saves).
        guard numberOfSavedMatches >= 2, !hasRequestedReview else { return }
        hasRequestedReview = true

        // 1.2s delay lets the save animation land before the system
        // review sheet appears — feels intentional, not intrusive.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            guard let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
            else { return }

            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
