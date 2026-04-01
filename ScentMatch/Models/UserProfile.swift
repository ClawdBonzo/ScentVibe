import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var createdAt: Date
    var totalMatchesUsed: Int
    var isPremium: Bool
    var premiumExpiryDate: Date?
    var preferredRegion: String?
    var hasCompletedOnboarding: Bool
    var preferredGender: String?  // "Masculine", "Feminine", "Unisex", or nil for all

    static let freeMatchLimit = 5

    init() {
        self.id = UUID()
        self.createdAt = Date()
        self.totalMatchesUsed = 0
        self.isPremium = false
        self.premiumExpiryDate = nil
        self.preferredRegion = nil
        self.hasCompletedOnboarding = false
        self.preferredGender = nil
    }

    var remainingFreeMatches: Int {
        max(0, Self.freeMatchLimit - totalMatchesUsed)
    }

    var canPerformMatch: Bool {
        isPremium || totalMatchesUsed < Self.freeMatchLimit
    }

    func incrementMatchCount() {
        totalMatchesUsed += 1
    }
}
