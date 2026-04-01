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
                        regionPicker
                        genderPicker
                    } header: {
                        Text("Preferences")
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

                        Link(destination: URL(string: "https://scentmatch.app/privacy")!) {
                            HStack {
                                Text("Privacy Policy")
                                    .foregroundStyle(.smTextPrimary)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.smTextTertiary)
                            }
                        }

                        Link(destination: URL(string: "https://scentmatch.app/terms")!) {
                            HStack {
                                Text("Terms of Use")
                                    .foregroundStyle(.smTextPrimary)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.smTextTertiary)
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
            .fullScreenCover(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }

    // MARK: - Account

    private var accountRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    if profile?.isPremium == true {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(.smGold)
                            .font(.system(size: 14))
                    }
                    Text(profile?.isPremium == true ? "ScentMatch Pro" : "Free Plan")
                        .font(SMFont.headline(16))
                        .foregroundStyle(.smTextPrimary)
                }
                Text("\(profile?.totalMatchesUsed ?? 0) matches used")
                    .font(SMFont.caption())
                    .foregroundStyle(.smTextSecondary)
            }

            Spacer()

            if profile?.isPremium != true {
                Button("Upgrade") {
                    showPaywall = true
                }
                .font(SMFont.label())
                .foregroundStyle(.smBackground)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(LinearGradient.smGoldGradient)
                .clipShape(Capsule())
            }
        }
    }

    // MARK: - Preferences

    private var regionPicker: some View {
        HStack {
            Text("Preferred Region")
                .foregroundStyle(.smTextPrimary)
            Spacer()
            Picker("Region", selection: $selectedRegion) {
                Text("All Regions").tag(nil as FragranceRegion?)
                ForEach(FragranceRegion.allCases) { region in
                    Text("\(region.flag) \(region.displayName)").tag(region as FragranceRegion?)
                }
            }
            .pickerStyle(.menu)
            .tint(.smEmerald)
        }
        .onChange(of: selectedRegion) { _, newValue in
            profile?.preferredRegion = newValue?.rawValue
        }
        .onAppear {
            selectedRegion = profile?.preferredRegion.flatMap { FragranceRegion(rawValue: $0) }
        }
    }

    private var genderPicker: some View {
        HStack {
            Text("Fragrance Style")
                .foregroundStyle(.smTextPrimary)
            Spacer()
            Picker("Style", selection: $selectedGender) {
                Text("All Styles").tag(nil as Gender?)
                ForEach(Gender.allCases, id: \.self) { gender in
                    Text(gender.rawValue).tag(gender as Gender?)
                }
            }
            .pickerStyle(.menu)
            .tint(.smEmerald)
        }
        .onChange(of: selectedGender) { _, newValue in
            profile?.preferredGender = newValue?.rawValue
        }
        .onAppear {
            selectedGender = profile?.preferredGender.flatMap { Gender(rawValue: $0) }
        }
    }

    // MARK: - Export

    private var exportButton: some View {
        Button(action: exportMatchHistory) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                    .foregroundStyle(.smEmerald)
                Text("Export Match History")
                    .foregroundStyle(.smTextPrimary)
                Spacer()
                Text("\(matches.count) matches")
                    .font(SMFont.caption())
                    .foregroundStyle(.smTextTertiary)
            }
        }
    }

    private var exportAnalyticsButton: some View {
        Button(action: exportAnalytics) {
            HStack {
                Image(systemName: "chart.bar")
                    .foregroundStyle(.smEmerald)
                Text("Export Analytics")
                    .foregroundStyle(.smTextPrimary)
                Spacer()
                Text("\(events.count) events")
                    .font(SMFont.caption())
                    .foregroundStyle(.smTextTertiary)
            }
        }
    }

    // MARK: - Delete

    private var deleteAllButton: some View {
        Button(action: { showDeleteConfirmation = true }) {
            HStack {
                Image(systemName: "trash")
                    .foregroundStyle(.smError)
                Text("Delete All Matches")
                    .foregroundStyle(.smError)
            }
        }
    }

    // MARK: - Helpers

    private func statsRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.smTextPrimary)
            Spacer()
            Text(value)
                .font(SMFont.mono(14))
                .foregroundStyle(.smEmerald)
        }
    }

    private func aboutRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.smTextPrimary)
            Spacer()
            Text(value)
                .foregroundStyle(.smTextSecondary)
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

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
