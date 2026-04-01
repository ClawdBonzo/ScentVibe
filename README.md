# ScentMatch AI

**Photo-to-fragrance recommendation engine for iOS.** Snap a photo of your outfit or room and get instant AI-powered scent recommendations with visual vibe matching.

## How It Works

1. **Snap** a photo of your outfit, room, or any visual scene
2. **AI analyzes** colors, mood, brightness, and style using the Vision framework
3. **Get matched** to the perfect fragrance from 200+ curated scents across 5 cultural regions
4. **Explore** detailed match explanations, fragrance notes, and vibe scores
5. **Shop** your favorites via one-tap affiliate links

## Features

- **200+ curated fragrances** across Western, German, Mexican, Brazilian, and French regions
- **On-device Vision analysis** — works offline, no server needed
- **6-factor matching engine** (mood 40%, color 30%, season 10%, scene 10%, brightness 5%, warmth 5%)
- **Diversity enforcement** — results span multiple price tiers, regions, and accord families
- **Template-driven explanations** — 22 templates across 5 mood categories
- **Animated onboarding** with per-page particle effects, orbiting elements, and spring animations
- **Dark luxury theme** — deep teal, emerald accents, serif display typography
- **Hard paywall** after 5 free matches (RevenueCat-ready)
- **Full localization** — English, German, Spanish (Mexico), Portuguese (Brazil), French
- **Region-aware affiliate links** — Amazon OneLink auto-redirects to user's local store
- **Analytics** — event logging with CSV export
- **SwiftData** — offline-first persistence

## Tech Stack

| Component | Technology |
|-----------|-----------|
| UI | SwiftUI |
| Data | SwiftData |
| Image Analysis | Vision framework |
| Color Extraction | CoreImage + pixel sampling |
| Payments | RevenueCat (ready to configure) |
| Affiliate | Amazon Associates + OneLink |
| Min iOS | 17.0 |
| Languages | Swift 5 |

## Project Structure

```
ScentMatch/
├── Models/           # Fragrance, ScentMatchResult, UserProfile, FragranceDatabase
├── Engine/           # VisionAnalyzer, MatchingEngine, ExplanationGenerator
├── Views/
│   ├── Dashboard/    # Match history grid
│   ├── Scan/         # Camera + photo library + scanning animation
│   ├── Results/      # Reveal animation + match detail
│   ├── Paywall/      # 3-tier subscription paywall
│   ├── Onboarding/   # Animated 3-page onboarding
│   ├── Settings/     # Preferences, export, stats
│   └── Testing/      # Engine validation harness
├── Components/       # VibeScoreGauge, FragranceBottleView, FragranceCard, LuxuryButton
├── Theme/            # Colors, typography, view modifiers
├── Analytics/        # Event logging + CSV export
├── Paywall/          # PaywallManager, AffiliateManager
└── Localization/     # String catalog (5 languages)
```

## Setup

1. **Clone** the repo and open `ScentMatch.xcodeproj` in Xcode 15+
2. **Build** and run on iOS 17+ simulator or device
3. **Configure RevenueCat** — add your API key in `PaywallManager.swift`
4. **Configure Amazon Associates** — add your associate tags in `AffiliateManager.swift`
5. **App icon** — add your 1024x1024 icon to `Assets.xcassets/AppIcon.appiconset`

### Amazon Affiliate Setup

1. Sign up at [affiliate-program.amazon.com](https://affiliate-program.amazon.com)
2. Apply for [Amazon OneLink](https://affiliate-program.amazon.com/onelink) for international routing
3. Update `AffiliateManager.swift` with your associate tags per region
4. All 200+ fragrances automatically get affiliate links (ASIN-based or search-based)

## Fragrance Database

| Region | Count | Example Brands |
|--------|-------|---------------|
| Western | 45 | Dior, Chanel, Tom Ford, Creed, Jo Malone |
| German | 35 | 4711, Hugo Boss, Escada, Xerjoff, Joop! |
| Mexican | 35 | Artisan copal, vanilla, cactus, mezcal blends |
| Brazilian | 35 | Natura, O Boticario, artisan tropical blends |
| French | 45 | Guerlain, Hermes, Frederic Malle, MFK, Mugler |

Each fragrance includes: name, house, accords, top/heart/base notes, mood tags, color associations, seasonality, region, price tier, gender, and affiliate link.

## Matching Engine

The engine uses a weighted 6-factor scoring system:

1. **Mood Similarity (40%)** — Cosine similarity between image mood vector and fragrance mood profile
2. **Color Match (30%)** — Hue/saturation/brightness overlap with fragrance color associations
3. **Seasonal Relevance (10%)** — Current season alignment
4. **Scene Context (10%)** — Outfit vs. room optimization
5. **Brightness Harmony (5%)** — Light images → fresh scents, dark → deep scents
6. **Warmth Harmony (5%)** — Warm palette → oriental/spicy, cool → fresh/aquatic

**Diversity enforcement** ensures top 5 results span at least 2 price tiers and 2 accord families.

## Monetization

- **Freemium**: 5 free matches, then hard paywall
- **Tiers**: $4.99/month, $29.99/year (save 50%), $49.99 lifetime
- **Affiliate**: Amazon Associates commission on fragrance purchases (all 200+ fragrances linked)

## License

Proprietary. All rights reserved.
