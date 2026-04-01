import SwiftUI
import PhotosUI

struct TestMatchView: View {
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var testImage: UIImage?
    @State private var analysisResult: ImageAnalysisResult?
    @State private var recommendations: [RecommendationEntry] = []
    @State private var vibeScore: Double = 0
    @State private var isAnalyzing = false
    @State private var errorMessage: String?
    @State private var selectedRegion: FragranceRegion?
    @State private var selectedGender: Gender?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Image picker
                    imageSection

                    // Analysis controls
                    controlsSection

                    if isAnalyzing {
                        ProgressView("Analyzing...")
                            .foregroundStyle(.smTextPrimary)
                            .padding()
                    }

                    if let error = errorMessage {
                        Text(error)
                            .foregroundStyle(.red)
                            .padding()
                    }

                    // Raw analysis output
                    if let result = analysisResult {
                        analysisSection(result)
                    }

                    // Recommendations
                    if !recommendations.isEmpty {
                        recommendationsSection
                    }
                }
                .padding()
            }
            .background(Color.smBackground)
            .navigationTitle("Engine Test Harness")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Image Section

    private var imageSection: some View {
        VStack(spacing: 12) {
            if let image = testImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.smSurfaceElevated)
                    .frame(height: 200)
                    .overlay {
                        VStack(spacing: 8) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 40))
                                .foregroundStyle(.smTextTertiary)
                            Text("Select a test photo")
                                .font(SMFont.body())
                                .foregroundStyle(.smTextSecondary)
                        }
                    }
            }

            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                Label("Choose Photo", systemImage: "photo.badge.plus")
                    .font(SMFont.headline(18))
                    .foregroundStyle(.smBackground)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.smEmerald)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .onChange(of: selectedPhoto) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        testImage = uiImage
                        analysisResult = nil
                        recommendations = []
                        vibeScore = 0
                        errorMessage = nil
                    }
                }
            }
        }
    }

    // MARK: - Controls

    private var controlsSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Region Filter:")
                    .font(SMFont.caption())
                    .foregroundStyle(.smTextSecondary)
                Spacer()
                Picker("Region", selection: $selectedRegion) {
                    Text("All").tag(nil as FragranceRegion?)
                    ForEach(FragranceRegion.allCases) { region in
                        Text("\(region.flag) \(region.displayName)").tag(region as FragranceRegion?)
                    }
                }
                .pickerStyle(.menu)
                .tint(.smEmerald)
            }

            HStack {
                Text("Gender Filter:")
                    .font(SMFont.caption())
                    .foregroundStyle(.smTextSecondary)
                Spacer()
                Picker("Gender", selection: $selectedGender) {
                    Text("All").tag(nil as Gender?)
                    ForEach(Gender.allCases, id: \.self) { gender in
                        Text(gender.rawValue).tag(gender as Gender?)
                    }
                }
                .pickerStyle(.menu)
                .tint(.smEmerald)
            }

            Button(action: runAnalysis) {
                Label("Run Analysis", systemImage: "play.fill")
                    .font(SMFont.headline(18))
                    .foregroundStyle(.smBackground)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(testImage != nil ? Color.smGold : Color.smTextTertiary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(testImage == nil || isAnalyzing)
        }
        .padding()
        .background(Color.smSurfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Analysis Section

    private func analysisSection(_ result: ImageAnalysisResult) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Vision Analysis", icon: "eye.fill")

            // Scene type
            debugRow("Scene Type", value: result.scanType)
            debugRow("Brightness", value: String(format: "%.2f", result.brightness))
            debugRow("Warmth", value: String(format: "%.2f (%.0f=cool, 1.0=warm)", result.warmth, 0.0))
            debugRow("Saturation", value: String(format: "%.2f", result.saturation))

            // Dominant colors
            sectionHeader("Dominant Colors", icon: "paintpalette.fill")
            ForEach(Array(result.dominantColors.enumerated()), id: \.offset) { idx, color in
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color(hue: color.hue / 360, saturation: color.saturation, brightness: color.brightness))
                        .frame(width: 24, height: 24)
                    Text("#\(idx + 1)")
                        .font(SMFont.mono(14))
                        .foregroundStyle(.smTextSecondary)
                    Text(color.colorName)
                        .font(SMFont.body(14))
                        .foregroundStyle(.smTextPrimary)
                    Text(color.hexString)
                        .font(SMFont.mono(12))
                        .foregroundStyle(.smTextTertiary)
                    Spacer()
                    Text(String(format: "%.0f%%", color.weight * 100))
                        .font(SMFont.mono(14))
                        .foregroundStyle(.smEmerald)
                }
            }

            // Scene classifications
            if !result.sceneClassifications.isEmpty {
                sectionHeader("Scene Labels", icon: "tag.fill")
                FlowLayout(spacing: 6) {
                    ForEach(result.sceneClassifications, id: \.self) { label in
                        Text(label)
                            .font(SMFont.label())
                            .foregroundStyle(.smTextPrimary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.smTeal.opacity(0.3))
                            .clipShape(Capsule())
                    }
                }
            }

            // Detected moods
            sectionHeader("Detected Moods", icon: "heart.fill")
            let sortedMoods = result.detectedMoods.sorted { $0.value > $1.value }
            ForEach(sortedMoods, id: \.key) { mood, score in
                HStack {
                    Text(mood.rawValue)
                        .font(SMFont.body(14))
                        .foregroundStyle(.smTextPrimary)
                        .frame(width: 100, alignment: .leading)
                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.smEmerald.opacity(0.6))
                            .frame(width: geo.size.width * score)
                    }
                    .frame(height: 16)
                    Text(String(format: "%.2f", score))
                        .font(SMFont.mono(12))
                        .foregroundStyle(.smTextSecondary)
                        .frame(width: 40)
                }
            }

            // Vibe score
            sectionHeader("Vibe Score", icon: "sparkles")
            Text(String(format: "%.0f / 100", vibeScore))
                .font(SMFont.display(28))
                .foregroundStyle(.smGold)
        }
        .padding()
        .background(Color.smSurfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Recommendations Section

    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Recommendations", icon: "list.star")

            ForEach(Array(recommendations.enumerated()), id: \.element.id) { idx, rec in
                if let fragrance = rec.fragrance() {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("#\(idx + 1)")
                                .font(SMFont.mono(16))
                                .foregroundStyle(.smGold)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(fragrance.name)
                                    .font(SMFont.headline(16))
                                    .foregroundStyle(.smTextPrimary)
                                Text(fragrance.house)
                                    .font(SMFont.caption())
                                    .foregroundStyle(.smTextSecondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(String(format: "%.1f%%", rec.score * 100))
                                    .font(SMFont.mono(16))
                                    .foregroundStyle(.smEmerald)
                                Text(fragrance.priceTier.rawValue)
                                    .font(SMFont.label())
                                    .foregroundStyle(.smTextTertiary)
                            }
                        }

                        // Details
                        HStack(spacing: 4) {
                            ForEach(fragrance.accords.prefix(3), id: \.self) { accord in
                                Text(accord.rawValue)
                                    .font(SMFont.label(10))
                                    .foregroundStyle(.smTextPrimary)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.smTeal.opacity(0.3))
                                    .clipShape(Capsule())
                            }
                            Spacer()
                            Text("\(fragrance.region.flag) \(fragrance.region.displayName)")
                                .font(SMFont.label(10))
                                .foregroundStyle(.smTextSecondary)
                        }

                        // Explanation
                        Text(rec.explanation)
                            .font(SMFont.body(13))
                            .foregroundStyle(.smTextSecondary)
                            .lineLimit(3)

                        // Matched moods
                        if !rec.matchedMoods.isEmpty {
                            HStack(spacing: 4) {
                                Text("Matched moods:")
                                    .font(SMFont.label(10))
                                    .foregroundStyle(.smTextTertiary)
                                ForEach(rec.matchedMoods, id: \.self) { mood in
                                    Text(mood)
                                        .font(SMFont.label(10))
                                        .foregroundStyle(.smEmerald)
                                }
                            }
                        }

                        if idx < recommendations.count - 1 {
                            Divider()
                                .background(Color.smTeal.opacity(0.2))
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.smSurfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(.smEmerald)
            Text(title)
                .font(SMFont.headline(16))
                .foregroundStyle(.smTextPrimary)
        }
    }

    private func debugRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(SMFont.body(14))
                .foregroundStyle(.smTextSecondary)
            Spacer()
            Text(value)
                .font(SMFont.mono(14))
                .foregroundStyle(.smTextPrimary)
        }
    }

    // MARK: - Analysis

    private func runAnalysis() {
        guard let image = testImage else { return }
        isAnalyzing = true
        errorMessage = nil

        Task {
            do {
                let result = try await VisionAnalyzer.shared.analyze(image: image)
                let matches = MatchingEngine.shared.findMatches(
                    for: result,
                    count: 5,
                    preferredRegion: selectedRegion,
                    preferredGender: selectedGender
                )
                let vibe = MatchingEngine.shared.computeVibeScore(
                    for: result,
                    topScore: matches.first?.score ?? 0
                )

                await MainActor.run {
                    analysisResult = result
                    recommendations = matches
                    vibeScore = vibe
                    isAnalyzing = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isAnalyzing = false
                }
            }
        }
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions = [CGPoint]()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxX = max(maxX, x)
        }

        return (CGSize(width: maxX, height: y + rowHeight), positions)
    }
}
