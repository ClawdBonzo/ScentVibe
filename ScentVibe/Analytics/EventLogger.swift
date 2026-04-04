import Foundation
import SwiftData

@Model
final class AnalyticsEvent {
    var id: UUID
    var eventName: String
    var timestamp: Date
    var metadataJSON: String

    init(eventName: String, metadata: [String: String] = [:]) {
        self.id = UUID()
        self.eventName = eventName
        self.timestamp = Date()
        self.metadataJSON = (try? JSONEncoder().encode(metadata)).flatMap { String(data: $0, encoding: .utf8) } ?? "{}"
    }

    var metadata: [String: String] {
        guard let data = metadataJSON.data(using: .utf8),
              let dict = try? JSONDecoder().decode([String: String].self, from: data) else { return [:] }
        return dict
    }
}

final class EventLogger {
    static let shared = EventLogger()

    private var modelContext: ModelContext?

    private init() {}

    func configure(with context: ModelContext) {
        self.modelContext = context
    }

    func log(_ eventName: String, metadata: [String: String] = [:]) {
        guard let context = modelContext else { return }
        let event = AnalyticsEvent(eventName: eventName, metadata: metadata)
        context.insert(event)
    }

    // Event names
    static let scanCompleted = "scan_completed"
    static let recommendationTapped = "recommendation_tapped"
    static let affiliateLinkTapped = "affiliate_link_tapped"
    static let paywallShown = "paywall_shown"
    static let paywallConverted = "paywall_converted"
    static let matchFavorited = "match_favorited"
    static let matchDeleted = "match_deleted"
    static let historyExported = "history_exported"
    static let savedToWardrobe = "saved_to_wardrobe"
    static let regenerateMatch = "regenerate_match"
    static let regenerateWithMood = "regenerate_with_mood"
    static let shareStoryCard = "share_story_card"

    func exportCSV(events: [AnalyticsEvent]) -> String {
        var csv = "event_name,timestamp,metadata\n"
        let formatter = ISO8601DateFormatter()
        for event in events {
            let ts = formatter.string(from: event.timestamp)
            let meta = event.metadataJSON.replacingOccurrences(of: ",", with: ";")
            csv += "\(event.eventName),\(ts),\"\(meta)\"\n"
        }
        return csv
    }
}
