import SwiftUI
import PhotosUI
import SwiftData

struct ScanView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var capturedImage: UIImage?
    @State private var showCamera = false
    @State private var showResults = false
    @State private var showPaywall = false
    @State private var isScanning = false
    @State private var matchResult: ScentMatchResult?
    @State private var analysisResult: ImageAnalysisResult?
    @State private var recommendations: [RecommendationEntry] = []

    private var profile: UserProfile {
        profiles.first ?? UserProfile()
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.smBackground.ignoresSafeArea()

                if isScanning {
                    ScanningAnimationView()
                } else {
                    scanInterface
                }
            }
            .navigationTitle("ScentMatch")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !profile.isPremium {
                        HStack(spacing: 4) {
                            Image(systemName: "sparkle")
                                .font(.system(size: 12))
                            Text("\(profile.remainingFreeMatches) left")
                                .font(SMFont.label())
                        }
                        .foregroundStyle(.smGold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.smGold.opacity(0.15))
                        .clipShape(Capsule())
                    }
                }
            }
        }
        .sheet(isPresented: $showCamera) {
            CameraView(image: $capturedImage)
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $showResults) {
            if let result = matchResult {
                ResultsRevealView(
                    matchResult: result,
                    recommendations: recommendations,
                    analysisResult: analysisResult
                )
            }
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView()
        }
        .onChange(of: capturedImage) { _, newImage in
            if let image = newImage {
                processImage(image)
            }
        }
    }

    // MARK: - Scan Interface

    private var scanInterface: some View {
        VStack(spacing: 32) {
            Spacer()

            // Hero illustration
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.smEmerald.opacity(0.15), .clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 120
                        )
                    )
                    .frame(width: 240, height: 240)

                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 72, weight: .thin))
                    .foregroundStyle(.smEmerald)
            }

            VStack(spacing: 12) {
                Text("Find Your Scent Match")
                    .font(SMFont.display(28))
                    .foregroundStyle(.smTextPrimary)
                    .multilineTextAlignment(.center)

                Text("Snap a photo of your outfit or room\nand discover your perfect fragrance")
                    .font(SMFont.body())
                    .foregroundStyle(.smTextSecondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            // Action buttons
            VStack(spacing: 14) {
                Button(action: {
                    if profile.canPerformMatch {
                        showCamera = true
                    } else {
                        showPaywall = true
                    }
                }) {
                    Label("Take Photo", systemImage: "camera.fill")
                        .font(SMFont.headline(18))
                        .foregroundStyle(.smBackground)
                        .frame(maxWidth: .infinity)
                        .frame(height: SMTheme.buttonHeight)
                        .background(LinearGradient.smPrimaryGradient)
                        .clipShape(RoundedRectangle(cornerRadius: SMTheme.cornerRadius))
                }

                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Label("Choose from Library", systemImage: "photo.on.rectangle")
                        .font(SMFont.headline(18))
                        .foregroundStyle(.smEmerald)
                        .frame(maxWidth: .infinity)
                        .frame(height: SMTheme.buttonHeight)
                        .background(Color.smEmerald.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: SMTheme.cornerRadius))
                }
                .onChange(of: selectedPhoto) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            if profile.canPerformMatch {
                                capturedImage = uiImage
                            } else {
                                showPaywall = true
                            }
                        }
                    }
                }

                #if DEBUG
                NavigationLink(destination: TestMatchView()) {
                    Label("Engine Test Harness", systemImage: "wrench.and.screwdriver")
                        .font(SMFont.caption())
                        .foregroundStyle(.smTextTertiary)
                }
                #endif
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .padding()
    }

    // MARK: - Process Image

    private func processImage(_ image: UIImage) {
        isScanning = true

        Task {
            do {
                let analysis = try await VisionAnalyzer.shared.analyze(image: image)
                let matches = MatchingEngine.shared.findMatches(
                    for: analysis,
                    count: 5,
                    preferredRegion: profile.preferredRegion.flatMap { FragranceRegion(rawValue: $0) },
                    preferredGender: profile.preferredGender.flatMap { Gender(rawValue: $0) }
                )
                let vibeScore = MatchingEngine.shared.computeVibeScore(
                    for: analysis,
                    topScore: matches.first?.score ?? 0
                )

                // Compress photo for storage
                let photoData = image.jpegData(compressionQuality: 0.5)

                let result = ScentMatchResult(
                    photoData: photoData,
                    scanType: analysis.scanType,
                    vibeScore: vibeScore,
                    dominantColors: analysis.dominantColors.map { $0.asArray },
                    detectedMoodTags: analysis.detectedMoods.sorted { $0.value > $1.value }.map { $0.key.rawValue },
                    sceneClassification: analysis.sceneClassifications.first ?? "general",
                    brightnessLevel: analysis.brightness,
                    warmthLevel: analysis.warmth,
                    recommendations: matches
                )

                await MainActor.run {
                    modelContext.insert(result)
                    profile.incrementMatchCount()

                    matchResult = result
                    analysisResult = analysis
                    recommendations = matches

                    EventLogger.shared.log(EventLogger.scanCompleted, metadata: [
                        "scan_type": analysis.scanType,
                        "vibe_score": String(format: "%.0f", vibeScore),
                        "top_match": matches.first?.id ?? "none"
                    ])

                    // Brief delay for scanning animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isScanning = false
                        showResults = true
                        capturedImage = nil
                    }
                }
            } catch {
                await MainActor.run {
                    isScanning = false
                    capturedImage = nil
                }
            }
        }
    }
}

// MARK: - Camera View (UIImagePickerController wrapper)

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
