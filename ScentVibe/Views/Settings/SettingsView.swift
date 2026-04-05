import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @Query private var matches: [ScentMatchResult]
    @Query private var events: [AnalyticsEvent]
    @State private var showDeleteConfirmation = false
    @State private var showExportSheet = false
    @State private var showPaywall = false
    @State private var exportURL: URL?
    @State private var selectedRegion: FragranceRegion?
    @State private var selectedGender: Gender?
    @State private var showRegionPicker = false
    @State private var showStylePicker = false

    @AppStorage("dailyVibeEnabled") private var dailyVibeEnabled = false

    private var profile: UserProfile? {
        profiles.first
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.smBackground.ignoresSafeArea()

                List {
                    // Account section
                    Section {
                        accountRow
                    } header: {
                        Text("Account")
                    }
                    .listRowBackground(Color.smSurfaceElevated)

                    // Preferences
                    Section {
                        regionRow
                        styleRow
                    } header: {
                        Text("Preferences")
                    }
                    .listRowBackground(Color.smSurfaceElevated)

                    // Notifications
                    Section {
                        dailyVibeToggle
                    } header: {
                        Text("Notifications")
                    }
                    .listRowBackground(Color.smSurfaceElevated)

                    // Data section
                    Section {
                        exportButton
                        exportAnalyticsButton
                    } header: {
                        Text("Data")
                    }
                    .listRowBackground(Color.smSurfaceElevated)

                    // Stats section
                    Section {
                        statsRow("Total Matches", value: "\(matches.count)")
                        statsRow("Favorites", value: "\(matches.filter(\.isFavorited).count)")
                        statsRow("Affiliate Taps", value: "\(matches.reduce(0) { $0 + $1.affiliateLinksTapped })")
                        statsRow("Fragrances in Library", value: "\(FragranceDatabase.shared.fragrances.count)")
                    } header: {
                        Text("Statistics")
                    }
                    .listRowBackground(Color.smSurfaceElevated)

                    // Danger zone
                    Section {
                        deleteAllButton
                    } header: {
                        Text("Danger Zone")
                    }
                    .listRowBackground(Color.smSurfaceElevated)

                    // About
                    Section {
                        aboutRow("Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                        aboutRow("Build", value: Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")

                        Link(destination: URL(string: "https://scentvibe-app.netlify.app/privacy")!) {
                            HStack {
                                Text("Privacy Policy")
                                    .foregroundStyle(Color.smTextPrimary)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.smTextTertiary)
                            }
                        }

                        Link(destination: URL(string: "https://scentvibe-app.netlify.app/terms")!) {
                            HStack {
                                Text("Terms of Use")
                                    .foregroundStyle(Color.smTextPrimary)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.smTextTertiary)
                            }
                        }
                    } header: {
                        Text("About")
                    }
                    .listRowBackground(Color.smSurfaceElevated)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .confirmationDialog("Delete All Matches", isPresented: $showDeleteConfirmation) {
                Button("Delete All", role: .destructive) {
                    deleteAllMatches()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete all \(matches.count) match(es). This cannot be undone.")
            }
            .sheet(isPresented: $showExportSheet) {
                if let url = exportURL {
                    ShareSheet(items: [url])
                }
            }
            .sheet(isPresented: $showRegionPicker) {
                RegionPickerSheet(
                    selectedRegion: $selectedRegion,
                    onSave: { newRegion in
                        profile?.preferredRegion = newRegion?.rawValue
                    }
                )
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationBackground(Color.smBackground)
            }
            .sheet(isPresented: $showStylePicker) {
                StylePickerSheet(
                    selectedGender: $selectedGender,
                    onSave: { newGender in
                        profile?.preferredGender = newGender?.rawValue
                    }
                )
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationBackground(Color.smBackground)
            }
            .fullScreenCover(isPresented: $showPaywall) {
                PaywallView()
            }
        }
        .onAppear {
            selectedRegion = profile?.preferredRegion.flatMap { FragranceRegion(rawValue: $0) }
            selectedGender = profile?.preferredGender.flatMap { Gender(rawValue: $0) }
        }
    }

    // MARK: - Account

    private var accountRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    if profile?.isPremium == true {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(Color.smGold)
                            .font(.system(size: 14))
                    }
                    Text(profile?.isPremium == true ? "ScentVibe Pro" : "Free Plan")
                        .font(SMFont.headline(16))
                        .foregroundStyle(Color.smTextPrimary)
                }
                Text("\(profile?.totalMatchesUsed ?? 0) matches used")
                    .font(SMFont.caption())
                    .foregroundStyle(Color.smTextSecondary)
            }

            Spacer()

            if profile?.isPremium != true {
                Button("Upgrade") {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    showPaywall = true
                }
                .font(SMFont.label())
                .foregroundStyle(Color.smBackground)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(LinearGradient.smGoldGradient)
                .clipShape(Capsule())
                .accessibilityLabel("Upgrade to ScentVibe Pro")
                .accessibilityHint("Opens the upgrade screen to unlock premium features")
            }
        }
    }

    // MARK: - Preferences

    private var regionRow: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            showRegionPicker = true
        } label: {
            HStack {
                Text("Preferred Region")
                    .foregroundStyle(Color.smTextPrimary)
                Spacer()
                Text(selectedRegion.map { "\($0.flag) \($0.displayName)" } ?? "All Regions")
                    .font(SMFont.caption())
                    .foregroundStyle(Color.smEmerald)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.smTextTertiary)
            }
        }
        .accessibilityLabel("Preferred Region: \(selectedRegion?.displayName ?? "All Regions")")
        .accessibilityHint("Opens a picker to choose your preferred fragrance region")
    }

    private var styleRow: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            showStylePicker = true
        } label: {
            HStack {
                Text("Fragrance Style")
                    .foregroundStyle(Color.smTextPrimary)
                Spacer()
                Text(selectedGender?.rawValue ?? "All Styles")
                    .font(SMFont.caption())
                    .foregroundStyle(Color.smEmerald)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.smTextTertiary)
            }
        }
        .accessibilityLabel("Fragrance Style: \(selectedGender?.rawValue ?? "All Styles")")
        .accessibilityHint("Opens a picker to choose your preferred fragrance style")
    }

    // MARK: - Notifications

    private var dailyVibeToggle: some View {
        Toggle(isOn: $dailyVibeEnabled) {
            HStack(spacing: 12) {
                Image(systemName: "bell.badge.fill")
                    .foregroundStyle(Color.smEmerald)
                    .font(.system(size: 16))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Daily Vibe")
                        .foregroundStyle(Color.smTextPrimary)
                    Text("9 AM fragrance suggestion")
                        .font(SMFont.caption())
                        .foregroundStyle(Color.smTextTertiary)
                }
            }
        }
        .tint(Color.smEmerald)
        .onChange(of: dailyVibeEnabled) { _, enabled in
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            if enabled {
                Task {
                    let status = await DailyVibeNotificationManager.shared.checkPermission()
                    if status == .notDetermined {
                        let granted = await DailyVibeNotificationManager.shared.requestPermission()
                        if !granted {
                            await MainActor.run { dailyVibeEnabled = false }
                            return
                        }
                    } else if status == .denied {
                        await MainActor.run { dailyVibeEnabled = false }
                        return
                    }
                    DailyVibeNotificationManager.shared.scheduleDailyNotification(modelContext: modelContext)
                }
            } else {
                DailyVibeNotificationManager.shared.cancelDailyNotification()
            }
        }
        .accessibilityLabel("Daily Vibe notifications, \(dailyVibeEnabled ? "enabled" : "disabled")")
        .accessibilityHint("Toggles a daily fragrance suggestion notification at 9 AM")
    }

    // MARK: - Export

    private var exportButton: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            exportMatchHistory()
        }) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                    .foregroundStyle(Color.smEmerald)
                Text("Export Match History")
                    .foregroundStyle(Color.smTextPrimary)
                Spacer()
                Text("\(matches.count) matches")
                    .font(SMFont.caption())
                    .foregroundStyle(Color.smTextTertiary)
            }
        }
        .accessibilityLabel("Export match history, \(matches.count) matches")
        .accessibilityHint("Exports your match history as a CSV file")
    }

    private var exportAnalyticsButton: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            exportAnalytics()
        }) {
            HStack {
                Image(systemName: "chart.bar")
                    .foregroundStyle(Color.smEmerald)
                Text("Export Analytics")
                    .foregroundStyle(Color.smTextPrimary)
                Spacer()
                Text("\(events.count) events")
                    .font(SMFont.caption())
                    .foregroundStyle(Color.smTextTertiary)
            }
        }
        .accessibilityLabel("Export analytics, \(events.count) events")
        .accessibilityHint("Exports your analytics data as a CSV file")
    }

    // MARK: - Delete

    private var deleteAllButton: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            showDeleteConfirmation = true
        }) {
            HStack {
                Image(systemName: "trash")
                    .foregroundStyle(Color.smError)
                Text("Delete All Matches")
                    .foregroundStyle(Color.smError)
            }
        }
        .accessibilityLabel("Delete all matches")
        .accessibilityHint("Permanently deletes all \(matches.count) saved matches. This cannot be undone.")
    }

    // MARK: - Helpers

    private func statsRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(Color.smTextPrimary)
            Spacer()
            Text(value)
                .font(SMFont.mono(14))
                .foregroundStyle(Color.smEmerald)
        }
    }

    private func aboutRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(Color.smTextPrimary)
            Spacer()
            Text(value)
                .foregroundStyle(Color.smTextSecondary)
        }
    }

    // MARK: - Actions

    private func exportMatchHistory() {
        var csv = "date,scan_type,vibe_score,top_match,top_score,explanation\n"
        let formatter = ISO8601DateFormatter()
        for match in matches {
            let ts = formatter.string(from: match.timestamp)
            let topRec = match.recommendations.first
            let fragName = topRec?.fragrance()?.name ?? "Unknown"
            let score = String(format: "%.1f", (topRec?.score ?? 0) * 100)
            let explanation = (topRec?.explanation ?? "").replacingOccurrences(of: ",", with: ";").replacingOccurrences(of: "\n", with: " ")
            csv += "\(ts),\(match.scanType),\(String(format: "%.0f", match.vibeScore)),\"\(fragName)\",\(score)%,\"\(explanation)\"\n"
        }

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("scentmatch_history.csv")
        try? csv.write(to: tempURL, atomically: true, encoding: .utf8)
        exportURL = tempURL
        showExportSheet = true
        EventLogger.shared.log(EventLogger.historyExported)
    }

    private func exportAnalytics() {
        let csv = EventLogger.shared.exportCSV(events: events)
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("scentmatch_analytics.csv")
        try? csv.write(to: tempURL, atomically: true, encoding: .utf8)
        exportURL = tempURL
        showExportSheet = true
    }

    private func deleteAllMatches() {
        for match in matches {
            modelContext.delete(match)
        }
        EventLogger.shared.log(EventLogger.matchDeleted, metadata: ["count": "\(matches.count)"])
    }
}

// MARK: - Region Picker Sheet

private struct RegionPickerSheet: View {
    @Binding var selectedRegion: FragranceRegion?
    let onSave: (FragranceRegion?) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var localSelection: FragranceRegion?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.smBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 8) {
                        pickerOption(label: "All Regions", emoji: "🌎", region: nil)

                        ForEach(FragranceRegion.allCases) { region in
                            pickerOption(label: region.displayName, emoji: region.flag, region: region)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Preferred Region")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        selectedRegion = localSelection
                        onSave(localSelection)
                        dismiss()
                    }
                    .font(SMFont.label())
                    .foregroundStyle(Color.smEmerald)
                }
            }
        }
        .onAppear { localSelection = selectedRegion }
    }

    private func pickerOption(label: String, emoji: String, region: FragranceRegion?) -> some View {
        let isSelected = localSelection == region

        return Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            localSelection = region
        } label: {
            HStack(spacing: 14) {
                Text(emoji)
                    .font(.system(size: 22))
                Text(label)
                    .font(SMFont.headline(16))
                    .foregroundStyle(Color.smTextPrimary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.smEmerald)
                } else {
                    Circle()
                        .stroke(Color.smTextTertiary.opacity(0.4), lineWidth: 1.5)
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(isSelected ? Color.smEmerald.opacity(0.08) : Color.smSurfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.smEmerald.opacity(0.3) : Color.smTeal.opacity(0.1), lineWidth: isSelected ? 1.5 : 0.5)
            )
        }
    }
}

// MARK: - Style Picker Sheet

private struct StylePickerSheet: View {
    @Binding var selectedGender: Gender?
    let onSave: (Gender?) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var localSelection: Gender?

    private let styleIcons: [Gender?: String] = [
        nil: "sparkles",
        .masculine: "bolt.fill",
        .feminine: "leaf.fill",
        .unisex: "circle.hexagongrid.fill"
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.smBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 8) {
                        styleOption(label: "All Styles", icon: "sparkles", gender: nil)

                        ForEach(Gender.allCases, id: \.self) { gender in
                            styleOption(
                                label: gender.rawValue,
                                icon: styleIcons[gender] ?? "circle",
                                gender: gender
                            )
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Fragrance Style")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        selectedGender = localSelection
                        onSave(localSelection)
                        dismiss()
                    }
                    .font(SMFont.label())
                    .foregroundStyle(Color.smEmerald)
                }
            }
        }
        .onAppear { localSelection = selectedGender }
    }

    private func styleOption(label: String, icon: String, gender: Gender?) -> some View {
        let isSelected = localSelection == gender

        return Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            localSelection = gender
        } label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(isSelected ? Color.smEmerald : Color.smGold.opacity(0.7))
                    .frame(width: 28)
                Text(label)
                    .font(SMFont.headline(16))
                    .foregroundStyle(Color.smTextPrimary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.smEmerald)
                } else {
                    Circle()
                        .stroke(Color.smTextTertiary.opacity(0.4), lineWidth: 1.5)
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(isSelected ? Color.smEmerald.opacity(0.08) : Color.smSurfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.smEmerald.opacity(0.3) : Color.smTeal.opacity(0.1), lineWidth: isSelected ? 1.5 : 0.5)
            )
        }
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
