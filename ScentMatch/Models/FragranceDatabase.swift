import Foundation

// MARK: - Fragrance Database (Merger + Shared Helpers)

final class FragranceDatabase {
    static let shared = FragranceDatabase()

    let fragrances: [Fragrance]

    private init() {
        var all = [Fragrance]()
        all.append(contentsOf: FragranceDB_Western.all)
        all.append(contentsOf: FragranceDB_German.all)
        all.append(contentsOf: FragranceDB_Mexican.all)
        all.append(contentsOf: FragranceDB_Brazilian.all)
        all.append(contentsOf: FragranceDB_French.all)
        fragrances = all
    }

    func fragrance(byId id: String) -> Fragrance? {
        fragrances.first { $0.id == id }
    }

    func fragrances(forRegion region: FragranceRegion) -> [Fragrance] {
        fragrances.filter { $0.region == region }
    }

    func fragrances(forTier tier: PriceTier) -> [Fragrance] {
        fragrances.filter { $0.priceTier == tier }
    }

    func fragrances(forAccord accord: AccordFamily) -> [Fragrance] {
        fragrances.filter { $0.accords.contains(accord) }
    }
}

// MARK: - Shared Color Association Builders
// Used by all regional database files to define color-mood mappings

enum ColorPreset {
    // Hue ranges: Red=0/360, Orange=30, Yellow=60, Green=120, Cyan=180, Blue=240, Purple=270, Pink=330
    static func warm(_ w: Double = 1.0) -> [ColorAssociation] {
        [ColorAssociation(hueMin: 0, hueMax: 50, weight: w),
         ColorAssociation(hueMin: 330, hueMax: 360, weight: w)]
    }
    static func cool(_ w: Double = 1.0) -> [ColorAssociation] {
        [ColorAssociation(hueMin: 180, hueMax: 270, weight: w)]
    }
    static func green(_ w: Double = 1.0) -> [ColorAssociation] {
        [ColorAssociation(hueMin: 80, hueMax: 160, weight: w)]
    }
    static func gold(_ w: Double = 1.0) -> [ColorAssociation] {
        [ColorAssociation(hueMin: 35, hueMax: 55, satMin: 0.3, weight: w)]
    }
    static func dark(_ w: Double = 1.0) -> [ColorAssociation] {
        [ColorAssociation(hueMin: 0, hueMax: 360, satMin: 0.0, satMax: 1.0, briMin: 0.0, briMax: 0.35, weight: w)]
    }
    static func neutral(_ w: Double = 1.0) -> [ColorAssociation] {
        [ColorAssociation(hueMin: 0, hueMax: 360, satMin: 0.0, satMax: 0.15, briMin: 0.3, briMax: 0.8, weight: w)]
    }
    static func bright(_ w: Double = 1.0) -> [ColorAssociation] {
        [ColorAssociation(hueMin: 0, hueMax: 360, satMin: 0.4, briMin: 0.7, weight: w)]
    }
    static func pink(_ w: Double = 1.0) -> [ColorAssociation] {
        [ColorAssociation(hueMin: 300, hueMax: 350, satMin: 0.2, weight: w)]
    }
    static func purple(_ w: Double = 1.0) -> [ColorAssociation] {
        [ColorAssociation(hueMin: 260, hueMax: 310, weight: w)]
    }
    static func white(_ w: Double = 1.0) -> [ColorAssociation] {
        [ColorAssociation(hueMin: 0, hueMax: 360, satMin: 0.0, satMax: 0.1, briMin: 0.85, briMax: 1.0, weight: w)]
    }
    static func earthy(_ w: Double = 1.0) -> [ColorAssociation] {
        [ColorAssociation(hueMin: 20, hueMax: 45, satMin: 0.2, satMax: 0.6, briMin: 0.2, briMax: 0.6, weight: w)]
    }
}
