import WidgetKit
import SwiftUI

// MARK: - Today's Vibe Widget
// Add as a Widget Extension target in Xcode:
// File → New → Target → Widget Extension → "ScentVibeWidget"
// Then replace the generated code with this file.
//
// Requires App Group: group.com.scentvibe.shared
// Add the App Group capability to both the main app and widget targets.

// MARK: - Timeline Entry

struct TodaysVibeEntry: TimelineEntry {
    let date: Date
    let fragranceName: String
    let fragranceHouse: String
    let vibeScore: Double
    let moodTags: [String]
    let photoData: Data?
    let isEmpty: Bool

    static var placeholder: TodaysVibeEntry {
        TodaysVibeEntry(
            date: .now,
            fragranceName: "Bleu de Chanel",
            fragranceHouse: "Chanel",
            vibeScore: 87,
            moodTags: ["Elegant", "Confident"],
            photoData: nil,
            isEmpty: false
        )
    }

    static var empty: TodaysVibeEntry {
        TodaysVibeEntry(
            date: .now,
            fragranceName: "No Matches Yet",
            fragranceHouse: "Scan your first outfit",
            vibeScore: 0,
            moodTags: [],
            photoData: nil,
            isEmpty: true
        )
    }
}

// MARK: - Timeline Provider

struct TodaysVibeProvider: TimelineProvider {
    func placeholder(in context: Context) -> TodaysVibeEntry {
        .placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (TodaysVibeEntry) -> Void) {
        completion(loadEntry() ?? .placeholder)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TodaysVibeEntry>) -> Void) {
        let entry = loadEntry() ?? .empty
        // Refresh every 4 hours
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 4, to: .now)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    /// Load the latest favorited match from shared UserDefaults (App Group)
    private func loadEntry() -> TodaysVibeEntry? {
        let defaults = UserDefaults(suiteName: "group.com.scentvibe.shared")
        guard let name = defaults?.string(forKey: "widget_fragrance_name"),
              let house = defaults?.string(forKey: "widget_fragrance_house") else {
            return nil
        }
        let score = defaults?.double(forKey: "widget_vibe_score") ?? 0
        let moods = defaults?.stringArray(forKey: "widget_mood_tags") ?? []
        let photo = defaults?.data(forKey: "widget_photo_data")

        return TodaysVibeEntry(
            date: .now,
            fragranceName: name,
            fragranceHouse: house,
            vibeScore: score,
            moodTags: moods,
            photoData: photo,
            isEmpty: false
        )
    }
}

// MARK: - Widget View

struct TodaysVibeWidgetView: View {
    let entry: TodaysVibeEntry
    @Environment(\.widgetFamily) var family

    // Theme colors (matching main app)
    private let emerald = Color(red: 0.00, green: 0.78, blue: 0.33)
    private let gold = Color(red: 0.88, green: 0.75, blue: 0.35)
    private let bgDark = Color(red: 0.03, green: 0.05, blue: 0.07)
    private let surface = Color(red: 0.06, green: 0.08, blue: 0.11)
    private let teal = Color(red: 0.06, green: 0.32, blue: 0.32)
    private let textPrimary = Color(red: 0.96, green: 0.96, blue: 0.94)
    private let textSecondary = Color(red: 0.62, green: 0.66, blue: 0.69)

    var body: some View {
        ZStack {
            // Background
            ContainerRelativeShape()
                .fill(bgDark)

            // Ambient glow
            Circle()
                .fill(RadialGradient(
                    colors: [teal.opacity(0.15), .clear],
                    center: .topLeading,
                    startRadius: 0,
                    endRadius: 120
                ))
                .offset(x: -40, y: -30)

            if entry.isEmpty {
                emptyView
            } else {
                contentView
            }
        }
    }

    // MARK: - Content

    private var contentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 6) {
                Image(systemName: "wand.and.stars")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(emerald)
                Text("TODAY'S VIBE")
                    .font(.system(size: 9, weight: .bold))
                    .tracking(1.5)
                    .foregroundStyle(emerald)
                Spacer()
                if entry.vibeScore > 0 {
                    scoreRing
                }
            }
            .padding(.bottom, 8)

            // Photo + info
            HStack(spacing: 10) {
                // Photo thumbnail
                if let data = entry.photoData,
                   let ui = UIImage(data: data) {
                    Image(uiImage: ui)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 44, height: 44)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.fragranceName)
                        .font(.system(size: 15, weight: .bold, design: .serif))
                        .foregroundStyle(textPrimary)
                        .lineLimit(1)

                    Text(entry.fragranceHouse)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(textSecondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            // Mood pills
            if !entry.moodTags.isEmpty && family != .systemSmall {
                HStack(spacing: 4) {
                    ForEach(entry.moodTags.prefix(2), id: \.self) { mood in
                        Text(mood)
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundStyle(textPrimary)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(teal.opacity(0.3))
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(14)
    }

    // MARK: - Score Ring

    private var scoreRing: some View {
        ZStack {
            Circle()
                .stroke(teal.opacity(0.2), lineWidth: 2)
                .frame(width: 28, height: 28)
            Circle()
                .trim(from: 0, to: entry.vibeScore / 100)
                .stroke(emerald, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .frame(width: 28, height: 28)
                .rotationEffect(.degrees(-90))
            Text(String(format: "%.0f", entry.vibeScore))
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundStyle(textPrimary)
        }
    }

    // MARK: - Empty View

    private var emptyView: some View {
        VStack(spacing: 8) {
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 24, weight: .thin))
                .foregroundStyle(emerald.opacity(0.5))
            Text("Scan an outfit")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(textPrimary)
            Text("to see your vibe")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(textSecondary)
        }
        .padding()
    }
}

// MARK: - Widget Configuration

struct TodaysVibeWidget: Widget {
    let kind: String = "TodaysVibeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodaysVibeProvider()) { entry in
            TodaysVibeWidgetView(entry: entry)
        }
        .configurationDisplayName("Today's Vibe")
        .description("Your latest scent match at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Widget Bundle (if you add more widgets later)

@main
struct ScentVibeWidgetBundle: WidgetBundle {
    var body: some Widget {
        TodaysVibeWidget()
    }
}

// MARK: - Previews

#Preview("Small", as: .systemSmall) {
    TodaysVibeWidget()
} timeline: {
    TodaysVibeEntry.placeholder
    TodaysVibeEntry.empty
}

#Preview("Medium", as: .systemMedium) {
    TodaysVibeWidget()
} timeline: {
    TodaysVibeEntry.placeholder
}
