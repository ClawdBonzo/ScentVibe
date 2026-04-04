import Foundation
import UIKit
import WidgetKit

/// Bridges match data from the main app to the widget via shared UserDefaults.
/// Call `update(with:)` whenever a match is favorited or a new scan completes.
///
/// Requires App Group capability: group.com.scentvibe.shared
/// Add this to both the main app target and the widget extension target.
final class WidgetDataBridge {
    static let shared = WidgetDataBridge()
    private let suiteName = "group.com.scentvibe.shared"

    private init() {}

    /// Push the latest match data to the widget
    func update(with match: ScentMatchResult) {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return }

        let topRec = match.recommendations.first
        let fragrance = topRec?.fragrance()

        defaults.set(fragrance?.name ?? "Unknown", forKey: "widget_fragrance_name")
        defaults.set(fragrance?.house ?? "", forKey: "widget_fragrance_house")
        defaults.set(match.vibeScore, forKey: "widget_vibe_score")
        defaults.set(Array(match.detectedMoodTags.prefix(3)), forKey: "widget_mood_tags")

        // Store a small thumbnail (max 100x100) to keep widget data lean
        if let photoData = match.photoData,
           let image = UIImage(data: photoData) {
            let thumbnail = image.preparingThumbnail(of: CGSize(width: 100, height: 100))
            defaults.set(thumbnail?.jpegData(compressionQuality: 0.6), forKey: "widget_photo_data")
        }

        // Request widget timeline reload
        WidgetCenter.shared.reloadTimelines(ofKind: "TodaysVibeWidget")
        #if DEBUG
        print("[WidgetBridge] Updated widget data: \(fragrance?.name ?? "unknown")")
        #endif
    }

    /// Clear widget data (e.g., when all matches are deleted)
    func clear() {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return }
        defaults.removeObject(forKey: "widget_fragrance_name")
        defaults.removeObject(forKey: "widget_fragrance_house")
        defaults.removeObject(forKey: "widget_vibe_score")
        defaults.removeObject(forKey: "widget_mood_tags")
        defaults.removeObject(forKey: "widget_photo_data")
        WidgetCenter.shared.reloadTimelines(ofKind: "TodaysVibeWidget")
        #if DEBUG
        print("[WidgetBridge] Cleared widget data")
        #endif
    }
}
