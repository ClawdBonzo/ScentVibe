import Foundation

// MARK: - German / DACH Market Fragrances (~150)
// Real products popular at Douglas, Flaconi, and other DACH retailers

enum FragranceDB_German {
    static let all: [Fragrance] = [

        // ─────────────────────────────────────────────
        // MARK: - Hugo Boss
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_boss_bottled",
            name: "Boss Bottled",
            house: "Hugo Boss",
            accords: [.woody, .spicy, .fruity],
            topNotes: ["Apple", "Plum", "Lemon", "Bergamot", "Oakmoss"],
            heartNotes: ["Geranium", "Cinnamon", "Mahogany", "Carnation"],
            baseNotes: ["Sandalwood", "Cedar", "Vetiver", "Olive Tree", "Vanilla"],
            moodTags: [.sophisticated, .confident, .elegant],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.fall, .winter, .spring],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "boss_bottled",
            shortDescription: "A timeless masculine classic with warm apple-cinnamon charm.",
            bottleColor: "#C8A96E",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_boss_bottled_infinite",
            name: "Boss Bottled Infinite",
            house: "Hugo Boss",
            accords: [.woody, .aromatic, .fresh],
            topNotes: ["Apple", "Mandarin Orange", "Rosemary"],
            heartNotes: ["Sage", "Patchouli", "Cinnamon"],
            baseNotes: ["Sandalwood", "Olive Tree", "Vetiver", "Labdanum"],
            moodTags: [.confident, .bold, .warm],
            colorAssociations: ColorPreset.earthy(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "boss_bottled_infinite",
            shortDescription: "Deeper, earthier evolution of the Boss Bottled line.",
            bottleColor: "#5A3E2B",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_hugo_man",
            name: "Hugo Man",
            house: "Hugo Boss",
            accords: [.fresh, .green, .aromatic],
            topNotes: ["Green Apple", "Mint", "Basil"],
            heartNotes: ["Sage", "Geranium", "Pine Needles"],
            baseNotes: ["Cedar", "Moss", "Fir Resin"],
            moodTags: [.energetic, .fresh, .playful],
            colorAssociations: ColorPreset.green(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "hugo_man",
            shortDescription: "Green, invigorating freshness in an iconic flask.",
            bottleColor: "#4CAF50",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_boss_the_scent",
            name: "Boss The Scent",
            house: "Hugo Boss",
            accords: [.oriental, .spicy, .leather],
            topNotes: ["Ginger", "Mandarin Orange", "Freesia"],
            heartNotes: ["Maninka Fruit", "Lavender"],
            baseNotes: ["Leather", "Virginia Cedar", "Patchouli"],
            moodTags: [.sensual, .mysterious, .bold],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "boss_the_scent",
            shortDescription: "Seductive ginger-leather with exotic Maninka fruit.",
            bottleColor: "#8B6914",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_boss_alive",
            name: "Boss Alive",
            house: "Hugo Boss",
            accords: [.woody, .floral, .fresh],
            topNotes: ["Apple", "Plum", "Damson Plum"],
            heartNotes: ["Jasmine Sambac", "Thyme", "Olive Blossom"],
            baseNotes: ["Sandalwood", "Cedarwood", "Cashmeran"],
            moodTags: [.confident, .elegant, .bold],
            colorAssociations: ColorPreset.purple(),
            seasonality: [.spring, .fall],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "boss_alive",
            shortDescription: "Empowering woody-floral blend for confident women.",
            bottleColor: "#7B3F8D",
            bottleShape: .square
        ),

        // ─────────────────────────────────────────────
        // MARK: - Dior
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_dior_sauvage_edt",
            name: "Sauvage Eau de Toilette",
            house: "Dior",
            accords: [.aromatic, .fresh, .spicy],
            topNotes: ["Bergamot", "Pepper"],
            heartNotes: ["Lavender", "Pink Pepper", "Vetiver", "Patchouli", "Geranium", "Elemi"],
            baseNotes: ["Ambroxan", "Cedar", "Labdanum"],
            moodTags: [.bold, .confident, .energetic],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer, .fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "dior_sauvage",
            shortDescription: "The #1 selling men's fragrance in Germany, wildly magnetic.",
            bottleColor: "#1A237E",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_dior_sauvage_edp",
            name: "Sauvage Eau de Parfum",
            house: "Dior",
            accords: [.aromatic, .spicy, .woody],
            topNotes: ["Bergamot", "Pepper", "Mandarin Orange"],
            heartNotes: ["Sichuan Pepper", "Lavender", "Star Anise", "Nutmeg"],
            baseNotes: ["Ambroxan", "Vanilla", "Cedar"],
            moodTags: [.bold, .warm, .sophisticated],
            colorAssociations: ColorPreset.dark(),
            seasonality: [.fall, .winter, .spring],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "dior_sauvage_edp",
            shortDescription: "Richer, spicier Sauvage with vanilla depth.",
            bottleColor: "#0D1B3E",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_dior_jadore",
            name: "J'adore",
            house: "Dior",
            accords: [.floral, .fruity, .musky],
            topNotes: ["Pear", "Melon", "Magnolia", "Peach", "Mandarin Orange", "Bergamot"],
            heartNotes: ["Jasmine", "Lily of the Valley", "Tuberose", "Rose", "Plum", "Orchid"],
            baseNotes: ["Musk", "Vanilla", "Cedar", "Blackberry", "Sandalwood"],
            moodTags: [.elegant, .romantic, .sophisticated],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "dior_jadore",
            shortDescription: "Iconic golden floral, an enduring symbol of femininity.",
            bottleColor: "#D4AF37",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_miss_dior",
            name: "Miss Dior Eau de Parfum",
            house: "Dior",
            accords: [.floral, .fresh, .powdery],
            topNotes: ["Blood Orange", "Mandarin Orange"],
            heartNotes: ["Rose", "Peony", "Lily of the Valley", "Iris"],
            baseNotes: ["Musk", "Rosewood", "Patchouli"],
            moodTags: [.romantic, .elegant, .playful],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "miss_dior",
            shortDescription: "Fresh rose-peony bouquet, effortlessly chic.",
            bottleColor: "#F5C6D0",
            bottleShape: .flacon
        ),

        // ─────────────────────────────────────────────
        // MARK: - Chanel
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_chanel_allure_homme",
            name: "Allure Homme Sport",
            house: "Chanel",
            accords: [.fresh, .aromatic, .citrus],
            topNotes: ["Orange", "Aldehydes", "Sea Notes"],
            heartNotes: ["Pepper", "Cedar", "Neroli"],
            baseNotes: ["Tonka Bean", "Musk", "Vetiver", "Amber"],
            moodTags: [.energetic, .fresh, .confident],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "chanel_allure_homme",
            shortDescription: "Sporty, dynamic Chanel for the active man.",
            bottleColor: "#A8A8A8",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_chanel_coco_noir",
            name: "Coco Noir",
            house: "Chanel",
            accords: [.oriental, .woody, .floral],
            topNotes: ["Grapefruit", "Bergamot"],
            heartNotes: ["Rose", "Jasmine", "Narcissus", "Geranium"],
            baseNotes: ["Patchouli", "Sandalwood", "Tonka Bean", "Vanilla", "Musk"],
            moodTags: [.mysterious, .sensual, .opulent],
            colorAssociations: ColorPreset.dark(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "chanel_coco_noir",
            shortDescription: "Dark, Venetian elegance with oriental depth.",
            bottleColor: "#1A1A1A",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_chanel_bleu",
            name: "Bleu de Chanel",
            house: "Chanel",
            accords: [.woody, .aromatic, .citrus],
            topNotes: ["Grapefruit", "Lemon", "Mint", "Pink Pepper"],
            heartNotes: ["Ginger", "Nutmeg", "Jasmine", "Iso E Super"],
            baseNotes: ["Incense", "Vetiver", "Cedar", "Sandalwood", "Patchouli"],
            moodTags: [.sophisticated, .confident, .elegant],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer, .fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "chanel_bleu",
            shortDescription: "Refined woody-aromatic, a modern icon of elegance.",
            bottleColor: "#1A3A5C",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_chanel_chance_tendre",
            name: "Chance Eau Tendre",
            house: "Chanel",
            accords: [.floral, .fruity, .musky],
            topNotes: ["Quince", "Grapefruit"],
            heartNotes: ["Hyacinth", "Jasmine", "Rose"],
            baseNotes: ["White Musk", "Iris", "Cedar", "Amber"],
            moodTags: [.romantic, .playful, .fresh],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "chanel_chance_tendre",
            shortDescription: "Soft, tender floral-fruity with a musky embrace.",
            bottleColor: "#FFB6C1",
            bottleShape: .round
        ),

        // ─────────────────────────────────────────────
        // MARK: - YSL
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_ysl_libre",
            name: "Libre",
            house: "Yves Saint Laurent",
            accords: [.floral, .oriental, .woody],
            topNotes: ["Mandarin Orange", "Lavender", "Black Currant"],
            heartNotes: ["Orange Blossom", "Jasmine", "Orchid"],
            baseNotes: ["Vanilla", "Cedar", "Musk", "Ambergris"],
            moodTags: [.bold, .confident, .sensual],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.fall, .winter, .spring],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "ysl_libre",
            shortDescription: "#1 women's fragrance at Douglas -- lavender meets orange blossom.",
            bottleColor: "#D4A44C",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_ysl_lhomme",
            name: "L'Homme",
            house: "Yves Saint Laurent",
            accords: [.woody, .spicy, .fresh],
            topNotes: ["Ginger", "Bergamot", "Lemon"],
            heartNotes: ["White Pepper", "Violet Leaf", "Basil"],
            baseNotes: ["Tonka Bean", "Cedar", "Vetiver"],
            moodTags: [.elegant, .sophisticated, .warm],
            colorAssociations: ColorPreset.neutral(),
            seasonality: [.spring, .fall],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "ysl_lhomme",
            shortDescription: "Understated ginger-wood sophistication.",
            bottleColor: "#C0C0C0",
            bottleShape: .tall
        ),

        // ─────────────────────────────────────────────
        // MARK: - Prada
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_prada_paradoxe",
            name: "Paradoxe",
            house: "Prada",
            accords: [.floral, .musky, .woody],
            topNotes: ["Pear", "Bergamot", "Neroli"],
            heartNotes: ["Jasmine", "Floral Notes"],
            baseNotes: ["Amber", "Musk", "Virginia Cedar"],
            moodTags: [.elegant, .sophisticated, .confident],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.spring, .fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "prada_paradoxe",
            shortDescription: "Shape-shifting floral that evolves uniquely on each wearer.",
            bottleColor: "#E8B4C8",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_prada_luna_rossa_carbon",
            name: "Luna Rossa Carbon",
            house: "Prada",
            accords: [.aromatic, .woody, .fresh],
            topNotes: ["Bergamot", "Pepper"],
            heartNotes: ["Lavender", "Metallic Notes"],
            baseNotes: ["Ambroxan", "Patchouli"],
            moodTags: [.bold, .confident, .cool],
            colorAssociations: ColorPreset.dark(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "prada_luna_rossa_carbon",
            shortDescription: "Metallic-modern lavender powerhouse.",
            bottleColor: "#2C2C2C",
            bottleShape: .modern
        ),

        // ─────────────────────────────────────────────
        // MARK: - Gisada
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_gisada_ambassador",
            name: "Ambassador",
            house: "Gisada",
            accords: [.fresh, .fruity, .aromatic],
            topNotes: ["Pineapple", "Bergamot", "Elemi"],
            heartNotes: ["Iris", "Lavender", "Black Pepper"],
            baseNotes: ["Ambroxan", "Cashmeran", "Musk", "Vanilla"],
            moodTags: [.energetic, .bold, .playful],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "gisada_ambassador",
            shortDescription: "Swiss-made pineapple freshness loved in the DACH market.",
            bottleColor: "#4169E1",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_gisada_donna",
            name: "Donna",
            house: "Gisada",
            accords: [.fruity, .floral, .gourmand],
            topNotes: ["Pineapple", "Pear", "Mandarin Orange"],
            heartNotes: ["Rose", "Jasmine", "Iris"],
            baseNotes: ["Vanilla", "Musk", "Cashmeran", "Sandalwood"],
            moodTags: [.playful, .romantic, .warm],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "gisada_donna",
            shortDescription: "Sweet pineapple-vanilla femininity from Swiss niche house.",
            bottleColor: "#F08080",
            bottleShape: .modern
        ),

        // ─────────────────────────────────────────────
        // MARK: - 4711 (Mäurer & Wirtz)
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_4711_original",
            name: "4711 Original Eau de Cologne",
            house: "4711",
            accords: [.citrus, .aromatic, .fresh],
            topNotes: ["Lemon", "Orange", "Bergamot"],
            heartNotes: ["Rosemary", "Neroli", "Lavender"],
            baseNotes: ["Musk", "Cedar", "Petitgrain"],
            moodTags: [.fresh, .vintage, .serene],
            colorAssociations: ColorPreset.green(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .budget,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "4711_original",
            shortDescription: "The legendary Cologne from 1792, a German heritage classic.",
            bottleColor: "#5F9EA0",
            bottleShape: .tall
        ),

        // ─────────────────────────────────────────────
        // MARK: - Joop!
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_joop_homme",
            name: "Joop! Homme",
            house: "Joop!",
            accords: [.oriental, .floral, .spicy],
            topNotes: ["Orange Blossom", "Bergamot", "Lemon"],
            heartNotes: ["Jasmine", "Heliotrope", "Lily of the Valley", "Cinnamon"],
            baseNotes: ["Vanilla", "Tonka Bean", "Sandalwood", "Patchouli", "Cedar"],
            moodTags: [.sensual, .bold, .vintage],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .budget,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "joop_homme",
            shortDescription: "Iconic sweet-oriental in a pink bottle, unmistakably bold.",
            bottleColor: "#C71585",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_joop_wow",
            name: "Joop! WOW!",
            house: "Joop!",
            accords: [.aromatic, .fresh, .woody],
            topNotes: ["Bergamot", "Cardamom", "Pineapple"],
            heartNotes: ["Sage", "Violet Leaf", "Black Pepper"],
            baseNotes: ["Tonka Bean", "Vetiver", "Sandalwood"],
            moodTags: [.energetic, .bold, .playful],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .budget,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "joop_wow",
            shortDescription: "Modern, spicy-aromatic refresh of the Joop! line.",
            bottleColor: "#3CB371",
            bottleShape: .modern
        ),

        // ─────────────────────────────────────────────
        // MARK: - Baldessarini
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_baldessarini_edc",
            name: "Baldessarini",
            house: "Baldessarini",
            accords: [.woody, .aromatic, .oriental],
            topNotes: ["Mint", "Cypress", "Lavender", "Artemisia"],
            heartNotes: ["Clary Sage", "Juniper Berries", "Tobacco"],
            baseNotes: ["Sandalwood", "Amber", "Vanilla", "Musk", "Cedar"],
            moodTags: [.sophisticated, .warm, .vintage],
            colorAssociations: ColorPreset.earthy(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "baldessarini_classic",
            shortDescription: "Refined German luxury, herbal tobacco warmth.",
            bottleColor: "#4A3728",
            bottleShape: .flacon
        ),

        Fragrance(
            id: "de_baldessarini_ambre",
            name: "Baldessarini Ambré",
            house: "Baldessarini",
            accords: [.oriental, .woody, .spicy],
            topNotes: ["Mandarin Orange", "Rum", "Apple"],
            heartNotes: ["Clary Sage", "Cinnamon", "Violet"],
            baseNotes: ["Amber", "Vanilla", "Labdanum", "Sandalwood", "Tonka Bean"],
            moodTags: [.warm, .cozy, .opulent],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "baldessarini_ambre",
            shortDescription: "Rich amber-rum warmth for cold German winters.",
            bottleColor: "#B8860B",
            bottleShape: .flacon
        ),

        // ─────────────────────────────────────────────
        // MARK: - Tabac Original
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_tabac_original",
            name: "Tabac Original",
            house: "Mäurer & Wirtz",
            accords: [.aromatic, .spicy, .powdery],
            topNotes: ["Bergamot", "Neroli", "Petitgrain", "Lemon"],
            heartNotes: ["Lavender", "Geranium", "Carnation", "Pepper"],
            baseNotes: ["Tobacco", "Oak Moss", "Sandalwood", "Vanilla", "Musk"],
            moodTags: [.vintage, .warm, .sophisticated],
            colorAssociations: ColorPreset.earthy(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .budget,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "tabac_original",
            shortDescription: "A barbershop legend since 1959, unapologetically classic.",
            bottleColor: "#8B4513",
            bottleShape: .tall
        ),

        // ─────────────────────────────────────────────
        // MARK: - Escada
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_escada_cherry_japan",
            name: "Cherry in Japan",
            house: "Escada",
            accords: [.fruity, .floral, .gourmand],
            topNotes: ["Cherry Blossom", "Apple"],
            heartNotes: ["Rose", "Jasmine", "Cherry"],
            baseNotes: ["Vanilla", "Musk", "Cedar"],
            moodTags: [.playful, .romantic, .fresh],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .budget,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "escada_cherry",
            shortDescription: "Limited edition cherry blossom sweetness.",
            bottleColor: "#FF69B4",
            bottleShape: .round
        ),

        Fragrance(
            id: "de_escada_celebrate_life",
            name: "Celebrate Life",
            house: "Escada",
            accords: [.floral, .fruity, .fresh],
            topNotes: ["Raspberry", "Red Currant", "Grapefruit"],
            heartNotes: ["Rose", "Peony", "Magnolia"],
            baseNotes: ["Musk", "Ambrette", "Cashmere Wood"],
            moodTags: [.playful, .energetic, .romantic],
            colorAssociations: ColorPreset.bright(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .budget,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "escada_celebrate",
            shortDescription: "Joyful berry-floral cocktail for sunny days.",
            bottleColor: "#FF6F61",
            bottleShape: .round
        ),

        Fragrance(
            id: "de_escada_especially",
            name: "Especially Escada",
            house: "Escada",
            accords: [.floral, .fruity, .musky],
            topNotes: ["Pear", "Rose Petals"],
            heartNotes: ["Rose", "Ilang-Ilang", "Magnolia"],
            baseNotes: ["Musk", "Ambroxan", "Cashmere Wood"],
            moodTags: [.romantic, .elegant, .serene],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .budget,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "escada_especially",
            shortDescription: "A delicate rose-pear fragrance for everyday grace.",
            bottleColor: "#DB7093",
            bottleShape: .round
        ),

        // ─────────────────────────────────────────────
        // MARK: - Betty Barclay
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_betty_tender_blossom",
            name: "Tender Blossom",
            house: "Betty Barclay",
            accords: [.floral, .fruity, .fresh],
            topNotes: ["Pink Pepper", "Pear", "Raspberry"],
            heartNotes: ["Peony", "Rose", "Magnolia"],
            baseNotes: ["Musk", "Cashmere Wood", "Sandalwood"],
            moodTags: [.romantic, .serene, .playful],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .budget,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "betty_tender",
            shortDescription: "Affordable, soft floral beloved at German drugstores.",
            bottleColor: "#FFB6C1",
            bottleShape: .round
        ),

        Fragrance(
            id: "de_betty_pure_pastel",
            name: "Pure Pastel Mint",
            house: "Betty Barclay",
            accords: [.fresh, .green, .citrus],
            topNotes: ["Bergamot", "Apple", "Mint"],
            heartNotes: ["Lily of the Valley", "Green Tea", "Rose"],
            baseNotes: ["Musk", "Cedar", "Ambroxan"],
            moodTags: [.fresh, .serene, .minimal],
            colorAssociations: ColorPreset.green(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .budget,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "betty_pastel",
            shortDescription: "Light, minty-green freshness for warm days.",
            bottleColor: "#98FB98",
            bottleShape: .round
        ),

        // ─────────────────────────────────────────────
        // MARK: - Bogner
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_bogner_man",
            name: "Bogner Man",
            house: "Bogner",
            accords: [.aromatic, .fresh, .woody],
            topNotes: ["Bergamot", "Grapefruit", "Cardamom"],
            heartNotes: ["Lavender", "Geranium", "Violet Leaf"],
            baseNotes: ["Vetiver", "Cedar", "Musk", "Tonka Bean"],
            moodTags: [.confident, .fresh, .sophisticated],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "bogner_man",
            shortDescription: "Alpine-inspired freshness from the Bavarian fashion house.",
            bottleColor: "#4682B4",
            bottleShape: .square
        ),

        // ─────────────────────────────────────────────
        // MARK: - Aigner
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_aigner_no1",
            name: "Aigner No 1",
            house: "Etienne Aigner",
            accords: [.woody, .aromatic, .leather],
            topNotes: ["Bergamot", "Grapefruit", "Cardamom"],
            heartNotes: ["Geranium", "Nutmeg", "Violet Leaf"],
            baseNotes: ["Leather", "Vetiver", "Patchouli", "Cedar"],
            moodTags: [.sophisticated, .elegant, .warm],
            colorAssociations: ColorPreset.earthy(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "aigner_no1",
            shortDescription: "Leather-accented elegance from the Munich fashion house.",
            bottleColor: "#8B4513",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_aigner_debut",
            name: "Début",
            house: "Etienne Aigner",
            accords: [.floral, .fruity, .musky],
            topNotes: ["Mandarin Orange", "Pear"],
            heartNotes: ["Rose", "Jasmine", "Peony"],
            baseNotes: ["Musk", "Sandalwood", "Amber"],
            moodTags: [.romantic, .elegant, .fresh],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "aigner_debut",
            shortDescription: "Munich-crafted floral for the modern German woman.",
            bottleColor: "#DDA0DD",
            bottleShape: .round
        ),

        // ─────────────────────────────────────────────
        // MARK: - Philipp Plein
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_plein_no_limits",
            name: "No Limits",
            house: "Philipp Plein",
            accords: [.fresh, .aromatic, .woody],
            topNotes: ["Bergamot", "Mandarin Orange", "Pink Pepper"],
            heartNotes: ["Iris", "Violet Leaf", "Cardamom"],
            baseNotes: ["Ambroxan", "Cashmeran", "Cedar", "Vetiver"],
            moodTags: [.bold, .rebellious, .energetic],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "plein_no_limits",
            shortDescription: "Extravagant freshness, skull bottle included.",
            bottleColor: "#1E90FF",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_plein_the_skull",
            name: "The $kull",
            house: "Philipp Plein",
            accords: [.oriental, .spicy, .woody],
            topNotes: ["Black Pepper", "Saffron", "Ginger"],
            heartNotes: ["Iris", "Oud", "Rose"],
            baseNotes: ["Amber", "Leather", "Sandalwood", "Musk"],
            moodTags: [.rebellious, .bold, .opulent],
            colorAssociations: ColorPreset.dark(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "plein_skull",
            shortDescription: "Loud, luxury oud in a crystal skull bottle.",
            bottleColor: "#2F2F2F",
            bottleShape: .modern
        ),

        // ─────────────────────────────────────────────
        // MARK: - Xerjoff
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_xerjoff_naxos",
            name: "Naxos",
            house: "Xerjoff",
            accords: [.oriental, .gourmand, .aromatic],
            topNotes: ["Lavender", "Bergamot", "Lemon"],
            heartNotes: ["Cinnamon", "Cashmeran", "Honey"],
            baseNotes: ["Tobacco", "Vanilla", "Tonka Bean"],
            moodTags: [.opulent, .warm, .sophisticated],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "xerjoff_naxos",
            shortDescription: "Niche honey-tobacco-lavender masterpiece from Turin.",
            bottleColor: "#DAA520",
            bottleShape: .flacon
        ),

        Fragrance(
            id: "de_xerjoff_erba_pura",
            name: "Erba Pura",
            house: "Xerjoff",
            accords: [.fruity, .musky, .oriental],
            topNotes: ["Orange", "Lemon", "Bergamot", "Sicilian Orange"],
            heartNotes: ["Fruit Notes", "White Flowers"],
            baseNotes: ["Musk", "Amber", "Vanilla", "Sugar"],
            moodTags: [.energetic, .playful, .opulent],
            colorAssociations: ColorPreset.bright(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .luxury,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "xerjoff_erba_pura",
            shortDescription: "Explosive fruit-amber that projects for days.",
            bottleColor: "#FF8C00",
            bottleShape: .flacon
        ),

        // ─────────────────────────────────────────────
        // MARK: - Escentric Molecules
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_molecule_01",
            name: "Molecule 01",
            house: "Escentric Molecules",
            accords: [.woody, .musky, .fresh],
            topNotes: ["Iso E Super"],
            heartNotes: ["Iso E Super"],
            baseNotes: ["Iso E Super"],
            moodTags: [.minimal, .sophisticated, .serene],
            colorAssociations: ColorPreset.neutral(),
            seasonality: [.spring, .summer, .fall, .winter],
            region: .german,
            priceTier: .mid,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "molecule_01",
            shortDescription: "Single molecule fragrance, a Berlin cult favorite.",
            bottleColor: "#F5F5DC",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_escentric_02",
            name: "Escentric 02",
            house: "Escentric Molecules",
            accords: [.musky, .woody, .spicy],
            topNotes: ["Hedione", "Elemi", "Pink Pepper"],
            heartNotes: ["Orris Root", "Violet", "Jasmine"],
            baseNotes: ["Ambroxan", "Vetiver", "Musk"],
            moodTags: [.minimal, .sophisticated, .elegant],
            colorAssociations: ColorPreset.neutral(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .mid,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "escentric_02",
            shortDescription: "Ambroxan-centered artistry with luminous depth.",
            bottleColor: "#E0E0E0",
            bottleShape: .modern
        ),

        // ─────────────────────────────────────────────
        // MARK: - Armani
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_armani_si",
            name: "Sì",
            house: "Giorgio Armani",
            accords: [.oriental, .floral, .fruity],
            topNotes: ["Black Currant", "Mandarin Orange"],
            heartNotes: ["Rose", "Freesia", "Osmanthus"],
            baseNotes: ["Vanilla", "Patchouli", "Ambroxan", "Woody Notes"],
            moodTags: [.elegant, .confident, .sensual],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.fall, .winter, .spring],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "armani_si",
            shortDescription: "Black currant elegance, a perennial Douglas bestseller.",
            bottleColor: "#8B0000",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_armani_code",
            name: "Armani Code",
            house: "Giorgio Armani",
            accords: [.oriental, .woody, .spicy],
            topNotes: ["Bergamot", "Lemon"],
            heartNotes: ["Olive Blossom", "Star Anise", "Guaiac Wood"],
            baseNotes: ["Tonka Bean", "Leather", "Tobacco"],
            moodTags: [.sensual, .mysterious, .sophisticated],
            colorAssociations: ColorPreset.dark(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "armani_code",
            shortDescription: "Dark, seductive olive blossom and tonka signature.",
            bottleColor: "#1C1C1C",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_armani_stronger_with_you",
            name: "Stronger With You",
            house: "Giorgio Armani",
            accords: [.oriental, .gourmand, .spicy],
            topNotes: ["Cardamom", "Pink Pepper", "Violet Leaves"],
            heartNotes: ["Sage", "Chestnut"],
            baseNotes: ["Vanilla", "Amber", "Cedar", "Sugar"],
            moodTags: [.warm, .cozy, .romantic],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "armani_stronger",
            shortDescription: "Sweet chestnut-vanilla comfort scent.",
            bottleColor: "#CD853F",
            bottleShape: .tall
        ),

        // ─────────────────────────────────────────────
        // MARK: - Lancôme
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_lancome_la_vie_est_belle",
            name: "La Vie Est Belle",
            house: "Lancôme",
            accords: [.gourmand, .floral, .oriental],
            topNotes: ["Black Currant", "Pear"],
            heartNotes: ["Iris", "Jasmine", "Orange Blossom"],
            baseNotes: ["Praline", "Vanilla", "Patchouli", "Tonka Bean"],
            moodTags: [.elegant, .romantic, .warm],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.fall, .winter, .spring],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "lancome_lveb",
            shortDescription: "Iris-gourmand in a smile-shaped bottle, a massive DACH hit.",
            bottleColor: "#D4A76A",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_lancome_idole",
            name: "Idôle",
            house: "Lancôme",
            accords: [.floral, .musky, .fresh],
            topNotes: ["Bergamot", "Pear", "Pink Pepper"],
            heartNotes: ["Rose", "Jasmine", "White Musk"],
            baseNotes: ["Cedar", "Vanilla", "Cashmeran", "Sandalwood"],
            moodTags: [.elegant, .confident, .fresh],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "lancome_idole",
            shortDescription: "Ultra-slim bottle, modern rose for the new generation.",
            bottleColor: "#E8C4C4",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_lancome_tresor",
            name: "Trésor",
            house: "Lancôme",
            accords: [.oriental, .floral, .powdery],
            topNotes: ["Rose", "Peach", "Apricot Blossom", "Lilac"],
            heartNotes: ["Iris", "Heliotrope", "Rose", "Lily of the Valley"],
            baseNotes: ["Amber", "Sandalwood", "Vanilla", "Musk", "Apricot"],
            moodTags: [.romantic, .vintage, .warm],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "lancome_tresor",
            shortDescription: "Timeless powdery rose-amber, a true classic.",
            bottleColor: "#C19A6B",
            bottleShape: .flacon
        ),

        // ─────────────────────────────────────────────
        // MARK: - Burberry
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_burberry_her",
            name: "Burberry Her",
            house: "Burberry",
            accords: [.fruity, .floral, .gourmand],
            topNotes: ["Dark Fruits", "Blackberry", "Raspberry", "Strawberry", "Black Currant"],
            heartNotes: ["Jasmine", "Violet"],
            baseNotes: ["Musk", "Amber", "Vanilla", "Cashmeran", "Dry Cocoa"],
            moodTags: [.playful, .romantic, .warm],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.fall, .winter, .spring],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "burberry_her",
            shortDescription: "Berry-loaded gourmand with British charm.",
            bottleColor: "#8B1A3A",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_burberry_brit",
            name: "Burberry Brit for Her",
            house: "Burberry",
            accords: [.oriental, .gourmand, .floral],
            topNotes: ["Lime", "Green Almond", "Pear"],
            heartNotes: ["Sugared Almonds", "Peony", "Rose"],
            baseNotes: ["Vanilla", "Amber", "Tonka Bean", "Mahogany"],
            moodTags: [.cozy, .romantic, .elegant],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "burberry_brit",
            shortDescription: "Sugar-almond warmth wrapped in British heritage.",
            bottleColor: "#DEB887",
            bottleShape: .square
        ),

        // ─────────────────────────────────────────────
        // MARK: - Gucci
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_gucci_bloom",
            name: "Bloom",
            house: "Gucci",
            accords: [.floral, .green, .powdery],
            topNotes: ["Rangoon Creeper", "Jasmine Bud"],
            heartNotes: ["Tuberose", "Jasmine"],
            baseNotes: ["Sandalwood", "Orris Root", "Musk"],
            moodTags: [.romantic, .serene, .natural],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "gucci_bloom",
            shortDescription: "A lush white garden in a bottle, pure and joyful.",
            bottleColor: "#F4C2C2",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_gucci_guilty_homme",
            name: "Guilty Pour Homme",
            house: "Gucci",
            accords: [.aromatic, .woody, .citrus],
            topNotes: ["Lavender", "Lemon", "Bergamot", "Orange"],
            heartNotes: ["Orange Blossom", "Neroli", "Pepper"],
            baseNotes: ["Cedar", "Patchouli", "Amber"],
            moodTags: [.bold, .confident, .energetic],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "gucci_guilty_homme",
            shortDescription: "Aromatic lavender-citrus with unapologetic swagger.",
            bottleColor: "#808080",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_gucci_guilty_femme",
            name: "Guilty Pour Femme",
            house: "Gucci",
            accords: [.floral, .oriental, .musky],
            topNotes: ["Mandarin Orange", "Pink Pepper"],
            heartNotes: ["Lilac", "Geranium", "Rose"],
            baseNotes: ["Patchouli", "Amber", "Musk"],
            moodTags: [.bold, .sensual, .confident],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.spring, .fall],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "gucci_guilty_femme",
            shortDescription: "Rebellious floral with heady patchouli base.",
            bottleColor: "#C9B37E",
            bottleShape: .square
        ),

        // ─────────────────────────────────────────────
        // MARK: - Paco Rabanne
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_paco_invictus",
            name: "Invictus",
            house: "Paco Rabanne",
            accords: [.aromatic, .aquatic, .fresh],
            topNotes: ["Grapefruit", "Sea Notes", "Mandarin Orange"],
            heartNotes: ["Bay Leaf", "Jasmine", "Hedione"],
            baseNotes: ["Ambergris", "Oakmoss", "Guaiac Wood", "Patchouli"],
            moodTags: [.energetic, .bold, .confident],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "paco_invictus",
            shortDescription: "Trophy-bottle victory scent, a gym-bag staple.",
            bottleColor: "#C0C0C0",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_paco_1million",
            name: "1 Million",
            house: "Paco Rabanne",
            accords: [.spicy, .leather, .fresh],
            topNotes: ["Grapefruit", "Blood Mandarin", "Peppermint"],
            heartNotes: ["Cinnamon", "Rose", "Spices"],
            baseNotes: ["Leather", "Amber", "Woody Notes", "Patchouli"],
            moodTags: [.bold, .opulent, .confident],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.fall, .winter, .spring],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "paco_1million",
            shortDescription: "Gold-bar bottle, unapologetic spicy-leather magnetism.",
            bottleColor: "#FFD700",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_paco_olympea",
            name: "Olympéa",
            house: "Paco Rabanne",
            accords: [.oriental, .floral, .aquatic],
            topNotes: ["Green Mandarin", "Aquatic Notes", "Pink Pepper"],
            heartNotes: ["Jasmine Sambac", "Lily of the Valley", "Salt"],
            baseNotes: ["Vanilla", "Sandalwood", "Cedar", "Cashmere Wood", "Amber"],
            moodTags: [.sensual, .elegant, .bold],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "paco_olympea",
            shortDescription: "Salty-vanilla goddess scent in a golden Cleopatra bottle.",
            bottleColor: "#D4AF37",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_paco_lady_million",
            name: "Lady Million",
            house: "Paco Rabanne",
            accords: [.floral, .woody, .gourmand],
            topNotes: ["Raspberry", "Bitter Orange", "Amalfi Lemon"],
            heartNotes: ["Orange Blossom", "Jasmine Sambac", "Gardenia"],
            baseNotes: ["Patchouli", "Honey", "Amber"],
            moodTags: [.opulent, .confident, .playful],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.spring, .fall, .winter],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "paco_lady_million",
            shortDescription: "Diamond-shaped luxury with honey-patchouli warmth.",
            bottleColor: "#FFD700",
            bottleShape: .modern
        ),

        // ─────────────────────────────────────────────
        // MARK: - Jean Paul Gaultier
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_jpg_le_male",
            name: "Le Male",
            house: "Jean Paul Gaultier",
            accords: [.oriental, .aromatic, .fresh],
            topNotes: ["Mint", "Lavender", "Bergamot", "Cardamom", "Artemisia"],
            heartNotes: ["Orange Blossom", "Cumin", "Cinnamon"],
            baseNotes: ["Vanilla", "Tonka Bean", "Amber", "Cedar", "Sandalwood"],
            moodTags: [.sensual, .bold, .vintage],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.fall, .winter, .spring],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "jpg_le_male",
            shortDescription: "The torso bottle icon: lavender-vanilla seduction.",
            bottleColor: "#4682B4",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_jpg_scandal",
            name: "Scandal",
            house: "Jean Paul Gaultier",
            accords: [.oriental, .gourmand, .floral],
            topNotes: ["Blood Orange", "Mandarin Orange", "Peach"],
            heartNotes: ["Honey", "Gardenia", "Jasmine"],
            baseNotes: ["Caramel", "Patchouli", "Beeswax", "Sandalwood"],
            moodTags: [.sensual, .bold, .playful],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "jpg_scandal",
            shortDescription: "Honey-caramel legs-up in a provocative bottle.",
            bottleColor: "#CD853F",
            bottleShape: .modern
        ),

        // ─────────────────────────────────────────────
        // MARK: - Valentino
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_valentino_born_in_roma",
            name: "Born in Roma Uomo",
            house: "Valentino",
            accords: [.aromatic, .woody, .spicy],
            topNotes: ["Ginger", "Sage", "Mineral Notes"],
            heartNotes: ["Lavender", "Geranium"],
            baseNotes: ["Vetiver", "Guaiac Wood", "Cashmeran", "Akigalawood"],
            moodTags: [.bold, .confident, .sophisticated],
            colorAssociations: ColorPreset.green(),
            seasonality: [.spring, .fall],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "valentino_born_uomo",
            shortDescription: "Modern Roman sage-vetiver with studded bottle.",
            bottleColor: "#2E8B57",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_valentino_donna_born",
            name: "Donna Born in Roma",
            house: "Valentino",
            accords: [.floral, .gourmand, .oriental],
            topNotes: ["Pink Pepper", "Bergamot"],
            heartNotes: ["Jasmine Grandiflorum", "Rose"],
            baseNotes: ["Bourbon Vanilla", "Cashmeran", "Benzoin"],
            moodTags: [.romantic, .opulent, .warm],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.fall, .winter, .spring],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "valentino_donna",
            shortDescription: "Jasmine-vanilla Roman couture in a studded bottle.",
            bottleColor: "#FF69B4",
            bottleShape: .modern
        ),

        // ─────────────────────────────────────────────
        // MARK: - Givenchy
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_givenchy_linterdit",
            name: "L'Interdit",
            house: "Givenchy",
            accords: [.floral, .woody, .powdery],
            topNotes: ["Pear", "Bergamot"],
            heartNotes: ["Tuberose", "Jasmine", "Orange Blossom"],
            baseNotes: ["Vetiver", "Patchouli", "Ambroxan"],
            moodTags: [.mysterious, .elegant, .bold],
            colorAssociations: ColorPreset.white(),
            seasonality: [.spring, .fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "givenchy_linterdit",
            shortDescription: "Forbidden white floral with dark vetiver twist.",
            bottleColor: "#FFFFFF",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_givenchy_gentleman",
            name: "Gentleman Eau de Parfum",
            house: "Givenchy",
            accords: [.woody, .oriental, .spicy],
            topNotes: ["Pepper", "Cardamom"],
            heartNotes: ["Iris", "Lavender", "Orris"],
            baseNotes: ["Patchouli", "Leather", "Benzoin"],
            moodTags: [.sophisticated, .warm, .elegant],
            colorAssociations: ColorPreset.dark(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "givenchy_gentleman",
            shortDescription: "Iris-patchouli refinement for the modern gentleman.",
            bottleColor: "#2F2F2F",
            bottleShape: .square
        ),

        // ─────────────────────────────────────────────
        // MARK: - Mugler
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_mugler_angel",
            name: "Angel",
            house: "Mugler",
            accords: [.gourmand, .oriental, .woody],
            topNotes: ["Cotton Candy", "Coconut", "Mandarin Orange", "Cassia"],
            heartNotes: ["Honey", "Caramel", "Red Berries", "Apricot"],
            baseNotes: ["Patchouli", "Chocolate", "Vanilla", "Tonka Bean"],
            moodTags: [.opulent, .bold, .sensual],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "mugler_angel",
            shortDescription: "The original gourmand star, patchouli-chocolate brilliance.",
            bottleColor: "#4169E1",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_mugler_alien",
            name: "Alien",
            house: "Mugler",
            accords: [.woody, .oriental, .floral],
            topNotes: ["Jasmine Sambac"],
            heartNotes: ["Cashmeran", "Tiger Eye Accord"],
            baseNotes: ["White Amber", "Woody Notes"],
            moodTags: [.mysterious, .opulent, .bold],
            colorAssociations: ColorPreset.purple(),
            seasonality: [.fall, .winter, .spring],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "mugler_alien",
            shortDescription: "Otherworldly jasmine-amber in a purple talisman.",
            bottleColor: "#7B2D8E",
            bottleShape: .modern
        ),

        // ─────────────────────────────────────────────
        // MARK: - Versace
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_versace_eros",
            name: "Eros",
            house: "Versace",
            accords: [.aromatic, .fresh, .oriental],
            topNotes: ["Mint", "Green Apple", "Lemon"],
            heartNotes: ["Tonka Bean", "Geranium", "Ambroxan"],
            baseNotes: ["Vanilla", "Vetiver", "Oakmoss", "Cedar"],
            moodTags: [.bold, .energetic, .confident],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "versace_eros",
            shortDescription: "Blue god of love: mint-vanilla aphrodisiac.",
            bottleColor: "#00BFFF",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_versace_crystal_noir",
            name: "Crystal Noir",
            house: "Versace",
            accords: [.oriental, .floral, .spicy],
            topNotes: ["Ginger", "Cardamom", "Pepper"],
            heartNotes: ["Gardenia", "Coconut", "Orange Blossom", "Peony"],
            baseNotes: ["Sandalwood", "Musk", "Amber", "Cashmere Wood"],
            moodTags: [.mysterious, .sensual, .opulent],
            colorAssociations: ColorPreset.dark(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "versace_crystal_noir",
            shortDescription: "Dark coconut-gardenia with oriental spice.",
            bottleColor: "#1C1C1C",
            bottleShape: .round
        ),

        Fragrance(
            id: "de_versace_bright_crystal",
            name: "Bright Crystal",
            house: "Versace",
            accords: [.floral, .fruity, .musky],
            topNotes: ["Pomegranate", "Yuzu", "Frost"],
            heartNotes: ["Magnolia", "Peony", "Lotus"],
            baseNotes: ["Amber", "Musk", "Mahogany"],
            moodTags: [.fresh, .romantic, .playful],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "versace_bright_crystal",
            shortDescription: "Sparkling peony-pomegranate freshness.",
            bottleColor: "#FFB6C1",
            bottleShape: .round
        ),

        Fragrance(
            id: "de_versace_dylan_blue",
            name: "Dylan Blue",
            house: "Versace",
            accords: [.aromatic, .woody, .fresh],
            topNotes: ["Calabrian Bergamot", "Grapefruit", "Fig Leaf", "Water Notes"],
            heartNotes: ["Violet Leaf", "Black Pepper", "Papyrus", "Patchouli", "Ambroxan"],
            baseNotes: ["Incense", "Musk", "Tonka Bean", "Saffron"],
            moodTags: [.confident, .bold, .cool],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "versace_dylan_blue",
            shortDescription: "Mediterranean blue freshness with incense depth.",
            bottleColor: "#1E3A6D",
            bottleShape: .round
        ),

        // ─────────────────────────────────────────────
        // MARK: - Calvin Klein
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_ck_one",
            name: "CK One",
            house: "Calvin Klein",
            accords: [.citrus, .fresh, .green],
            topNotes: ["Pineapple", "Green Notes", "Mandarin Orange", "Papaya", "Bergamot", "Cardamom", "Lemon"],
            heartNotes: ["Nutmeg", "Violet", "Orris Root", "Jasmine", "Lily of the Valley", "Rose"],
            baseNotes: ["Musk", "Cedar", "Sandalwood", "Amber", "Oakmoss"],
            moodTags: [.fresh, .minimal, .energetic],
            colorAssociations: ColorPreset.neutral(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .budget,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "ck_one",
            shortDescription: "The original 90s unisex icon, still fresh.",
            bottleColor: "#E0E0E0",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_ck_eternity",
            name: "Eternity for Men",
            house: "Calvin Klein",
            accords: [.aromatic, .fresh, .green],
            topNotes: ["Lavender", "Mandarin Orange", "Green Notes"],
            heartNotes: ["Jasmine", "Basil", "Sage", "Geranium"],
            baseNotes: ["Sandalwood", "Amber", "Rosewood", "Cedar"],
            moodTags: [.serene, .elegant, .fresh],
            colorAssociations: ColorPreset.green(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .budget,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "ck_eternity",
            shortDescription: "Clean lavender-sage, a timeless gentleman's choice.",
            bottleColor: "#90EE90",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_ck_obsession",
            name: "Obsession for Men",
            house: "Calvin Klein",
            accords: [.oriental, .spicy, .woody],
            topNotes: ["Mandarin Orange", "Bergamot", "Lime", "Lavender"],
            heartNotes: ["Nutmeg", "Coriander", "Red Berries", "Cinnamon"],
            baseNotes: ["Sandalwood", "Amber", "Vanilla", "Musk", "Patchouli"],
            moodTags: [.sensual, .warm, .vintage],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .budget,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "ck_obsession",
            shortDescription: "Rich 80s amber-spice, a cult classic.",
            bottleColor: "#8B4513",
            bottleShape: .square
        ),

        // ─────────────────────────────────────────────
        // MARK: - Ralph Lauren
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_rl_polo_blue",
            name: "Polo Blue",
            house: "Ralph Lauren",
            accords: [.aromatic, .aquatic, .fresh],
            topNotes: ["Melon", "Cucumber", "Mandarin Orange"],
            heartNotes: ["Sage", "Basil", "Geranium"],
            baseNotes: ["Suede", "Woodsy Notes", "Patchouli", "Musk"],
            moodTags: [.fresh, .confident, .serene],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "rl_polo_blue",
            shortDescription: "Aquatic melon-sage, breezy American style.",
            bottleColor: "#4169E1",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_rl_polo_red",
            name: "Polo Red",
            house: "Ralph Lauren",
            accords: [.spicy, .woody, .aromatic],
            topNotes: ["Red Grapefruit", "Italian Lemon", "Cranberry"],
            heartNotes: ["Red Saffron", "Red Sage"],
            baseNotes: ["Red Cedar", "Amber Wood", "Coffee"],
            moodTags: [.bold, .energetic, .confident],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "rl_polo_red",
            shortDescription: "Adrenaline-charged grapefruit-saffron-coffee.",
            bottleColor: "#B22222",
            bottleShape: .tall
        ),

        // ─────────────────────────────────────────────
        // MARK: - Davidoff
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_davidoff_cool_water",
            name: "Cool Water",
            house: "Davidoff",
            accords: [.aquatic, .aromatic, .fresh],
            topNotes: ["Sea Notes", "Lavender", "Mint", "Green Notes", "Calone", "Rosemary"],
            heartNotes: ["Geranium", "Neroli", "Jasmine", "Sandalwood"],
            baseNotes: ["Musk", "Cedar", "Amber", "Tobacco", "Oakmoss"],
            moodTags: [.fresh, .cool, .energetic],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .budget,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "davidoff_cool_water",
            shortDescription: "The original 90s aquatic, an eternal summer classic.",
            bottleColor: "#0077BE",
            bottleShape: .tall
        ),

        // ─────────────────────────────────────────────
        // MARK: - Montblanc
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_montblanc_explorer",
            name: "Explorer",
            house: "Montblanc",
            accords: [.woody, .aromatic, .fresh],
            topNotes: ["Bergamot", "Pink Pepper", "Clary Sage"],
            heartNotes: ["Leather", "Vetiver"],
            baseNotes: ["Indonesian Patchouli", "Oakmoss", "Cacao", "Akigalawood"],
            moodTags: [.bold, .confident, .natural],
            colorAssociations: ColorPreset.dark(),
            seasonality: [.spring, .fall, .winter],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "montblanc_explorer",
            shortDescription: "Adventurous leather-vetiver inspired by globe-trotting.",
            bottleColor: "#2C3E50",
            bottleShape: .round
        ),

        Fragrance(
            id: "de_montblanc_legend",
            name: "Legend",
            house: "Montblanc",
            accords: [.aromatic, .woody, .fresh],
            topNotes: ["Lavender", "Bergamot", "Pineapple Leaf"],
            heartNotes: ["Rose", "Geranium", "Coumarin", "Apple"],
            baseNotes: ["Tonka Bean", "Sandalwood", "Evernyl", "Dry Wood"],
            moodTags: [.elegant, .fresh, .sophisticated],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "montblanc_legend",
            shortDescription: "Fougère freshness named for the iconic pen brand.",
            bottleColor: "#1C1C1C",
            bottleShape: .round
        ),

        // ─────────────────────────────────────────────
        // MARK: - Dolce & Gabbana
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_dg_the_one",
            name: "The One",
            house: "Dolce & Gabbana",
            accords: [.oriental, .spicy, .woody],
            topNotes: ["Grapefruit", "Coriander", "Basil"],
            heartNotes: ["Ginger", "Cardamom", "Orange Blossom", "Cedar"],
            baseNotes: ["Tobacco", "Amber", "Labdanum", "Musk"],
            moodTags: [.sophisticated, .warm, .sensual],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "dg_the_one",
            shortDescription: "Warm tobacco-amber sophistication from Italy.",
            bottleColor: "#B8860B",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_dg_light_blue",
            name: "Light Blue",
            house: "Dolce & Gabbana",
            accords: [.citrus, .fresh, .fruity],
            topNotes: ["Sicilian Lemon", "Apple", "Cedar", "Bluebells"],
            heartNotes: ["Bamboo", "Jasmine", "White Rose"],
            baseNotes: ["Cedar", "Musk", "Amber"],
            moodTags: [.fresh, .playful, .energetic],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "dg_light_blue",
            shortDescription: "Mediterranean summer in a bottle, lemon-apple freshness.",
            bottleColor: "#87CEEB",
            bottleShape: .square
        ),

        // ─────────────────────────────────────────────
        // MARK: - Tom Ford
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_tomford_tobacco_vanille",
            name: "Tobacco Vanille",
            house: "Tom Ford",
            accords: [.oriental, .gourmand, .spicy],
            topNotes: ["Tobacco Leaf", "Spicy Notes"],
            heartNotes: ["Tonka Bean", "Tobacco Blossom", "Vanilla", "Cacao"],
            baseNotes: ["Dried Fruits", "Woody Notes"],
            moodTags: [.opulent, .warm, .cozy],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "tf_tobacco_vanille",
            shortDescription: "Decadent tobacco-vanilla, the ultimate winter luxury.",
            bottleColor: "#4A2C2A",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_tomford_oud_wood",
            name: "Oud Wood",
            house: "Tom Ford",
            accords: [.woody, .oriental, .spicy],
            topNotes: ["Oud", "Rosewood", "Cardamom"],
            heartNotes: ["Sandalwood", "Vetiver", "Siam Benzoin"],
            baseNotes: ["Tonka Bean", "Amber"],
            moodTags: [.sophisticated, .mysterious, .opulent],
            colorAssociations: ColorPreset.earthy(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "tf_oud_wood",
            shortDescription: "Smoky, creamy oud with sandalwood refinement.",
            bottleColor: "#3B2F2F",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_tomford_lost_cherry",
            name: "Lost Cherry",
            house: "Tom Ford",
            accords: [.fruity, .gourmand, .oriental],
            topNotes: ["Black Cherry", "Cherry Liqueur", "Bitter Almond"],
            heartNotes: ["Turkish Rose", "Jasmine Sambac"],
            baseNotes: ["Peru Balsam", "Roasted Tonka", "Sandalwood", "Vetiver", "Cedar"],
            moodTags: [.sensual, .opulent, .playful],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "tf_lost_cherry",
            shortDescription: "Boozy black cherry decadence, a Flaconi favorite.",
            bottleColor: "#8B0000",
            bottleShape: .square
        ),

        // ─────────────────────────────────────────────
        // MARK: - Hermès
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_hermes_terre",
            name: "Terre d'Hermès",
            house: "Hermès",
            accords: [.woody, .citrus, .spicy],
            topNotes: ["Orange", "Grapefruit", "Flint"],
            heartNotes: ["Pepper", "Pelargonium", "Rose"],
            baseNotes: ["Vetiver", "Cedar", "Benzoin", "Patchouli"],
            moodTags: [.sophisticated, .natural, .elegant],
            colorAssociations: ColorPreset.earthy(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "hermes_terre",
            shortDescription: "Earthy orange-vetiver, the thinking man's fragrance.",
            bottleColor: "#CC5500",
            bottleShape: .square
        ),

        // ─────────────────────────────────────────────
        // MARK: - Carolina Herrera
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_ch_good_girl",
            name: "Good Girl",
            house: "Carolina Herrera",
            accords: [.oriental, .floral, .gourmand],
            topNotes: ["Almond", "Coffee"],
            heartNotes: ["Tuberose", "Jasmine Sambac", "Orange Blossom"],
            baseNotes: ["Cacao", "Tonka Bean", "Cashmere Wood", "Sandalwood", "Vanilla"],
            moodTags: [.sensual, .bold, .opulent],
            colorAssociations: ColorPreset.dark(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "ch_good_girl",
            shortDescription: "Coffee-tuberose in a stiletto heel bottle.",
            bottleColor: "#1C1C3B",
            bottleShape: .modern
        ),

        // ─────────────────────────────────────────────
        // MARK: - Marc Jacobs
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_mj_daisy",
            name: "Daisy",
            house: "Marc Jacobs",
            accords: [.floral, .fruity, .fresh],
            topNotes: ["Strawberry", "Violet Leaves", "Blood Grapefruit"],
            heartNotes: ["Gardenia", "Violet", "Jasmine"],
            baseNotes: ["Musk", "Vanilla", "White Woods"],
            moodTags: [.playful, .fresh, .romantic],
            colorAssociations: ColorPreset.white(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "mj_daisy",
            shortDescription: "Daisy-capped charm with strawberry-violet freshness.",
            bottleColor: "#FFFACD",
            bottleShape: .round
        ),

        // ─────────────────────────────────────────────
        // MARK: - Viktor & Rolf
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_vr_flowerbomb",
            name: "Flowerbomb",
            house: "Viktor & Rolf",
            accords: [.floral, .oriental, .gourmand],
            topNotes: ["Tea", "Bergamot", "Osmanthus"],
            heartNotes: ["Jasmine", "Orange Blossom", "Freesia", "Rose", "Orchid"],
            baseNotes: ["Musk", "Patchouli", "Vanilla"],
            moodTags: [.romantic, .opulent, .warm],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.fall, .winter, .spring],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "vr_flowerbomb",
            shortDescription: "Grenade-shaped floral explosion, endlessly popular.",
            bottleColor: "#FF69B4",
            bottleShape: .round
        ),

        // ─────────────────────────────────────────────
        // MARK: - Narciso Rodriguez
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_narciso_for_her",
            name: "For Her",
            house: "Narciso Rodriguez",
            accords: [.musky, .floral, .woody],
            topNotes: ["Rose", "Peach", "Bergamot"],
            heartNotes: ["Musc", "Amber", "Osmanthus"],
            baseNotes: ["Patchouli", "Sandalwood", "Vetiver", "Vanilla"],
            moodTags: [.sensual, .elegant, .minimal],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.spring, .fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "narciso_for_her",
            shortDescription: "Musk perfection, an understated skin scent.",
            bottleColor: "#FFB6C1",
            bottleShape: .tall
        ),

        // ─────────────────────────────────────────────
        // MARK: - Diesel
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_diesel_only_brave",
            name: "Only The Brave",
            house: "Diesel",
            accords: [.woody, .aromatic, .leather],
            topNotes: ["Mandarin Orange", "Lemon", "Virginia Cedar", "Amalfi Lemon"],
            heartNotes: ["Coriandum", "Violet", "Rose", "Styrax"],
            baseNotes: ["Leather", "Amber", "Labdanum", "Cedar", "Benzoin"],
            moodTags: [.bold, .rebellious, .confident],
            colorAssociations: ColorPreset.earthy(),
            seasonality: [.spring, .fall],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "diesel_brave",
            shortDescription: "Fist-shaped bottle, brave leather-amber punch.",
            bottleColor: "#808080",
            bottleShape: .modern
        ),

        // ─────────────────────────────────────────────
        // MARK: - Lacoste
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_lacoste_blanc",
            name: "Eau de Lacoste L.12.12 Blanc",
            house: "Lacoste",
            accords: [.fresh, .citrus, .woody],
            topNotes: ["Grapefruit", "Rosemary", "Cardamom"],
            heartNotes: ["Tuberose", "Ylang-Ylang", "Suede"],
            baseNotes: ["Cedar", "Superwood", "Leather"],
            moodTags: [.fresh, .minimal, .serene],
            colorAssociations: ColorPreset.white(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .budget,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "lacoste_blanc",
            shortDescription: "Clean, polo-shirt fresh in a tennis-inspired bottle.",
            bottleColor: "#FFFFFF",
            bottleShape: .square
        ),

        // ─────────────────────────────────────────────
        // MARK: - Issey Miyake
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_issey_leau_homme",
            name: "L'Eau d'Issey Pour Homme",
            house: "Issey Miyake",
            accords: [.aquatic, .citrus, .woody],
            topNotes: ["Yuzu", "Bergamot", "Lemon", "Mandarin Orange", "Calone"],
            heartNotes: ["Lily of the Valley", "Cinnamon", "Saffron", "Nutmeg", "Geranium"],
            baseNotes: ["Vetiver", "Amber", "Musk", "Sandalwood", "Cedar", "Tobacco"],
            moodTags: [.serene, .fresh, .elegant],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "issey_leau_homme",
            shortDescription: "Iconic aquatic-yuzu in a conical bottle.",
            bottleColor: "#E0E0E0",
            bottleShape: .tall
        ),

        // ─────────────────────────────────────────────
        // MARK: - Acqua di Parma
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_adp_colonia",
            name: "Colonia",
            house: "Acqua di Parma",
            accords: [.citrus, .aromatic, .fresh],
            topNotes: ["Lemon", "Calabrian Bergamot", "Orange"],
            heartNotes: ["Lavender", "Rosemary", "Verbena", "Rose"],
            baseNotes: ["Vetiver", "Sandalwood", "Patchouli", "Musk"],
            moodTags: [.elegant, .fresh, .vintage],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .luxury,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "adp_colonia",
            shortDescription: "Italian citrus refinement since 1916, a barbershop classic.",
            bottleColor: "#F0C75E",
            bottleShape: .round
        ),

        // ─────────────────────────────────────────────
        // MARK: - Maison Margiela Replica
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_replica_fireplace",
            name: "Replica By the Fireplace",
            house: "Maison Margiela",
            accords: [.woody, .spicy, .gourmand],
            topNotes: ["Clove Oil", "Pink Pepper", "Orange Blossom"],
            heartNotes: ["Chestnut", "Guaiac Wood", "Juniper"],
            baseNotes: ["Vanilla", "Peru Balsam", "Cashmeran"],
            moodTags: [.cozy, .warm, .sophisticated],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "replica_fireplace",
            shortDescription: "A crackling fireplace in a bottle, pure winter hygge.",
            bottleColor: "#B22222",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_replica_jazz_club",
            name: "Replica Jazz Club",
            house: "Maison Margiela",
            accords: [.aromatic, .woody, .leather],
            topNotes: ["Pink Pepper", "Lemon", "Neroli"],
            heartNotes: ["Clary Sage", "Rum Absolute", "Java Vetiver"],
            baseNotes: ["Tobacco Leaf", "Vanilla Bean", "Styrax"],
            moodTags: [.warm, .vintage, .sophisticated],
            colorAssociations: ColorPreset.earthy(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "replica_jazz",
            shortDescription: "Smoky rum-tobacco evening in a Brooklyn jazz club.",
            bottleColor: "#5C4033",
            bottleShape: .square
        ),

        // ─────────────────────────────────────────────
        // MARK: - Byredo
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_byredo_gypsy_water",
            name: "Gypsy Water",
            house: "Byredo",
            accords: [.woody, .aromatic, .fresh],
            topNotes: ["Bergamot", "Lemon", "Pepper"],
            heartNotes: ["Incense", "Pine Needle", "Orris"],
            baseNotes: ["Sandalwood", "Vanilla", "Amber"],
            moodTags: [.natural, .serene, .sophisticated],
            colorAssociations: ColorPreset.neutral(),
            seasonality: [.spring, .fall],
            region: .german,
            priceTier: .luxury,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "byredo_gypsy",
            shortDescription: "Nomadic pine-sandalwood poetry from Stockholm.",
            bottleColor: "#F5F5F5",
            bottleShape: .tall
        ),

        // ─────────────────────────────────────────────
        // MARK: - Creed
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_creed_aventus",
            name: "Aventus",
            house: "Creed",
            accords: [.fruity, .woody, .fresh],
            topNotes: ["Pineapple", "Bergamot", "Black Currant", "Apple"],
            heartNotes: ["Birch", "Patchouli", "Moroccan Jasmine", "Rose"],
            baseNotes: ["Musk", "Oakmoss", "Ambergris", "Vanilla"],
            moodTags: [.confident, .bold, .opulent],
            colorAssociations: ColorPreset.dark(),
            seasonality: [.spring, .summer, .fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "creed_aventus",
            shortDescription: "Legendary pineapple-birch, the king of niche.",
            bottleColor: "#2F4F4F",
            bottleShape: .flacon
        ),

        // ─────────────────────────────────────────────
        // MARK: - Giorgio Beverly Hills
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_giorgio_bh",
            name: "Giorgio Beverly Hills",
            house: "Giorgio Beverly Hills",
            accords: [.floral, .oriental, .fruity],
            topNotes: ["Orange Blossom", "Peach", "Bergamot"],
            heartNotes: ["Gardenia", "Jasmine", "Rose", "Tuberose", "Narcissus"],
            baseNotes: ["Sandalwood", "Patchouli", "Amber", "Vanilla", "Cedar"],
            moodTags: [.opulent, .vintage, .bold],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .budget,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "giorgio_bh",
            shortDescription: "80s powerhouse floral, still a German drugstore staple.",
            bottleColor: "#FFD700",
            bottleShape: .tall
        ),

        // ─────────────────────────────────────────────
        // MARK: - Chloé
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_chloe_edp",
            name: "Chloé Eau de Parfum",
            house: "Chloé",
            accords: [.floral, .powdery, .fresh],
            topNotes: ["Peony", "Lychee", "Freesia"],
            heartNotes: ["Rose", "Lily of the Valley", "Magnolia"],
            baseNotes: ["Amber", "Cedar", "Musk"],
            moodTags: [.romantic, .elegant, .fresh],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "chloe_edp",
            shortDescription: "Powdery rose-peony wrapped in a ribbon bow.",
            bottleColor: "#FADADD",
            bottleShape: .flacon
        ),

        // ─────────────────────────────────────────────
        // MARK: - Penhaligon's
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_penhaligons_halfeti",
            name: "Halfeti",
            house: "Penhaligon's",
            accords: [.oriental, .woody, .spicy],
            topNotes: ["Bergamot", "Grapefruit", "Cardamom"],
            heartNotes: ["Rose", "Jasmine", "Saffron", "Nutmeg"],
            baseNotes: ["Oud", "Sandalwood", "Amber", "Leather", "Tonka Bean"],
            moodTags: [.opulent, .mysterious, .sophisticated],
            colorAssociations: ColorPreset.dark(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "penhaligons_halfeti",
            shortDescription: "Black-rose oud from the British heritage house.",
            bottleColor: "#1A1A2E",
            bottleShape: .flacon
        ),

        // ─────────────────────────────────────────────
        // MARK: - Jo Malone
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_jomalone_wood_sage",
            name: "Wood Sage & Sea Salt",
            house: "Jo Malone London",
            accords: [.aromatic, .woody, .aquatic],
            topNotes: ["Ambrette Seeds", "Sea Salt"],
            heartNotes: ["Sea Kale", "Sage"],
            baseNotes: ["Driftwood", "Grapefruit"],
            moodTags: [.natural, .serene, .fresh],
            colorAssociations: ColorPreset.neutral(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .luxury,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "jomalone_sage",
            shortDescription: "Windswept coastal sage, effortlessly British.",
            bottleColor: "#F5F0E8",
            bottleShape: .tall
        ),

        // ─────────────────────────────────────────────
        // MARK: - Mancera
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_mancera_cedrat_boise",
            name: "Cedrat Boisé",
            house: "Mancera",
            accords: [.woody, .citrus, .spicy],
            topNotes: ["Sicilian Lemon", "Black Currant", "Bergamot", "Spices"],
            heartNotes: ["Patchouli", "Birch", "Jasmine", "Rose"],
            baseNotes: ["Sandalwood", "Vanilla", "Leather", "White Musk"],
            moodTags: [.bold, .confident, .sophisticated],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .luxury,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "mancera_cedrat",
            shortDescription: "Lemon-birch powerhouse from the Parisian niche house.",
            bottleColor: "#DAA520",
            bottleShape: .tall
        ),

        // ─────────────────────────────────────────────
        // MARK: - Initio
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_initio_side_effect",
            name: "Side Effect",
            house: "Initio Parfums Privés",
            accords: [.oriental, .gourmand, .spicy],
            topNotes: ["Rum", "Cinnamon", "Saffron"],
            heartNotes: ["Tobacco", "Hedione", "Cannabis Accord"],
            baseNotes: ["Vanilla", "Benzoin", "Musk"],
            moodTags: [.sensual, .warm, .opulent],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "initio_side_effect",
            shortDescription: "Intoxicating rum-tobacco-vanilla, a Flaconi cult favorite.",
            bottleColor: "#4A0E0E",
            bottleShape: .modern
        ),

        // ─────────────────────────────────────────────
        // MARK: - Parfums de Marly
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_pdm_layton",
            name: "Layton",
            house: "Parfums de Marly",
            accords: [.oriental, .spicy, .woody],
            topNotes: ["Apple", "Bergamot", "Mandarin Orange"],
            heartNotes: ["Jasmine", "Violet", "Iris"],
            baseNotes: ["Vanilla", "Guaiac Wood", "Cardamom", "Sandalwood", "Pepper"],
            moodTags: [.opulent, .warm, .sophisticated],
            colorAssociations: ColorPreset.earthy(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "pdm_layton",
            shortDescription: "Apple-vanilla regality in an equestrian bottle.",
            bottleColor: "#1C2841",
            bottleShape: .flacon
        ),

        Fragrance(
            id: "de_pdm_delina",
            name: "Delina",
            house: "Parfums de Marly",
            accords: [.floral, .fruity, .musky],
            topNotes: ["Lychee", "Rhubarb", "Bergamot", "Nutmeg"],
            heartNotes: ["Turkish Rose", "Peony", "Lily of the Valley", "Vanilla"],
            baseNotes: ["Cashmeran", "Musk", "Cedar", "Vetiver", "Incense"],
            moodTags: [.romantic, .elegant, .opulent],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.spring, .fall],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "pdm_delina",
            shortDescription: "Lychee-rose masterpiece, a Douglas niche bestseller.",
            bottleColor: "#FF69B4",
            bottleShape: .flacon
        ),

        // ─────────────────────────────────────────────
        // MARK: - Maison Francis Kurkdjian
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_mfk_baccarat_rouge",
            name: "Baccarat Rouge 540",
            house: "Maison Francis Kurkdjian",
            accords: [.oriental, .woody, .floral],
            topNotes: ["Jasmine", "Saffron"],
            heartNotes: ["Amberwood", "Maison Francis Kurkdjian Accord"],
            baseNotes: ["Fir Resin", "Cedar"],
            moodTags: [.opulent, .mysterious, .warm],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.fall, .winter, .spring],
            region: .german,
            priceTier: .luxury,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "mfk_br540",
            shortDescription: "Crystal-bottle saffron-amber, the ultimate luxury scent.",
            bottleColor: "#C0392B",
            bottleShape: .square
        ),

        // ─────────────────────────────────────────────
        // MARK: - Additional DACH favorites
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_jimmy_choo_man",
            name: "Jimmy Choo Man",
            house: "Jimmy Choo",
            accords: [.aromatic, .woody, .fruity],
            topNotes: ["Lavender", "Mandarin Orange", "Honeydew Melon"],
            heartNotes: ["Pink Pepper", "Geranium", "Patchouli"],
            baseNotes: ["Suede", "Amber", "Sandalwood"],
            moodTags: [.confident, .sophisticated, .warm],
            colorAssociations: ColorPreset.earthy(),
            seasonality: [.spring, .fall],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "jimmy_choo_man",
            shortDescription: "Suede-patchouli sophistication with melon freshness.",
            bottleColor: "#696969",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_azzaro_wanted",
            name: "Wanted",
            house: "Azzaro",
            accords: [.spicy, .woody, .fresh],
            topNotes: ["Ginger", "Lemon", "Cardamom"],
            heartNotes: ["Juniper Berries", "Apple", "Cinnamon"],
            baseNotes: ["Tonka Bean", "Vetiver", "Driftwood"],
            moodTags: [.bold, .energetic, .confident],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "azzaro_wanted",
            shortDescription: "Barrel-shaped spice-wood for wanted men.",
            bottleColor: "#DAA520",
            bottleShape: .round
        ),

        Fragrance(
            id: "de_ysl_black_opium",
            name: "Black Opium",
            house: "Yves Saint Laurent",
            accords: [.oriental, .gourmand, .floral],
            topNotes: ["Pink Pepper", "Orange Blossom", "Pear"],
            heartNotes: ["Coffee", "Jasmine", "Bitter Almond", "Licorice"],
            baseNotes: ["Vanilla", "Patchouli", "Cedar", "Cashmere Wood"],
            moodTags: [.sensual, .bold, .opulent],
            colorAssociations: ColorPreset.dark(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "ysl_black_opium",
            shortDescription: "Glittering coffee-vanilla addiction, a Douglas icon.",
            bottleColor: "#1A1A1A",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_kenzo_flower",
            name: "Flower by Kenzo",
            house: "Kenzo",
            accords: [.floral, .powdery, .fresh],
            topNotes: ["Bulgarian Rose", "Hawthorne"],
            heartNotes: ["Parma Violet", "Cassia"],
            baseNotes: ["White Musk", "Vanilla", "Opoponax"],
            moodTags: [.romantic, .serene, .elegant],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "kenzo_flower",
            shortDescription: "Single poppy bottle, gentle rose-powdery poetry.",
            bottleColor: "#FF4500",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_roberto_cavalli_edp",
            name: "Roberto Cavalli Eau de Parfum",
            house: "Roberto Cavalli",
            accords: [.oriental, .floral, .woody],
            topNotes: ["Pink Pepper", "Orange Blossom"],
            heartNotes: ["Jasmine", "Rose", "Heliotrope"],
            baseNotes: ["Tonka Bean", "Benzoin", "Sandalwood", "Musk"],
            moodTags: [.sensual, .bold, .warm],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "cavalli_edp",
            shortDescription: "Snakeskin-wrapped orange blossom seduction.",
            bottleColor: "#C19A6B",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_boss_ma_vie",
            name: "Ma Vie Pour Femme",
            house: "Hugo Boss",
            accords: [.floral, .green, .fresh],
            topNotes: ["Cactus Flower", "Pink Freesia"],
            heartNotes: ["Rose", "Jasmine Bud"],
            baseNotes: ["Cedar", "Musk", "Amber"],
            moodTags: [.elegant, .fresh, .serene],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "boss_ma_vie",
            shortDescription: "Cactus blossom freshness for the modern woman.",
            bottleColor: "#FFB6C1",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_davidoff_cool_water_woman",
            name: "Cool Water Woman",
            house: "Davidoff",
            accords: [.aquatic, .floral, .fresh],
            topNotes: ["Quince", "Cassis", "Pineapple", "Citrus"],
            heartNotes: ["Water Lily", "Jasmine", "Lotus", "Rose"],
            baseNotes: ["Peach", "Sandalwood", "Musk", "Orris Root"],
            moodTags: [.fresh, .serene, .cool],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .budget,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "davidoff_cool_water_w",
            shortDescription: "Aquatic freshness for her, a summer perennial.",
            bottleColor: "#00CED1",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_abercrombie_fierce",
            name: "Fierce",
            house: "Abercrombie & Fitch",
            accords: [.aromatic, .woody, .musky],
            topNotes: ["Petitgrain", "Cardamom", "Lemon", "Orange", "Fir"],
            heartNotes: ["Jasmine", "Rosemary", "Lily of the Valley", "Rose"],
            baseNotes: ["Musk", "Oakmoss", "Vetiver", "Woodsy Notes"],
            moodTags: [.confident, .bold, .energetic],
            colorAssociations: ColorPreset.neutral(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "af_fierce",
            shortDescription: "The store-scent legend, still selling strong in Germany.",
            bottleColor: "#C0C0C0",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_thierry_mugler_amen",
            name: "A*Men",
            house: "Mugler",
            accords: [.oriental, .gourmand, .woody],
            topNotes: ["Lavender", "Mint", "Bergamot"],
            heartNotes: ["Coffee", "Caramel"],
            baseNotes: ["Tar", "Patchouli", "Vanilla", "Tonka Bean", "Musk"],
            moodTags: [.bold, .mysterious, .warm],
            colorAssociations: ColorPreset.dark(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "mugler_amen",
            shortDescription: "Coffee-tar-patchouli in a rubber-star bottle.",
            bottleColor: "#2C3E50",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_chloe_nomade",
            name: "Nomade",
            house: "Chloé",
            accords: [.floral, .woody, .fresh],
            topNotes: ["Mirabelle Plum", "Bergamot", "Lemon"],
            heartNotes: ["Freesia", "Rose", "Jasmine Absolute"],
            baseNotes: ["Oakmoss", "White Musk", "Amberwood"],
            moodTags: [.natural, .elegant, .fresh],
            colorAssociations: ColorPreset.earthy(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "chloe_nomade",
            shortDescription: "Free-spirited oakmoss-rose for the wandering soul.",
            bottleColor: "#C8AD7F",
            bottleShape: .flacon
        ),

        Fragrance(
            id: "de_guerlain_shalimar",
            name: "Shalimar",
            house: "Guerlain",
            accords: [.oriental, .powdery, .citrus],
            topNotes: ["Bergamot", "Lemon", "Mandarin Orange"],
            heartNotes: ["Jasmine", "Rose", "May Rose", "Iris", "Opoponax"],
            baseNotes: ["Vanilla", "Tonka Bean", "Incense", "Benzoin", "Sandalwood"],
            moodTags: [.opulent, .vintage, .sensual],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "guerlain_shalimar",
            shortDescription: "A 1925 masterpiece, the ultimate oriental classic.",
            bottleColor: "#D4AF37",
            bottleShape: .flacon
        ),

        // ─────────────────────────────────────────────
        // MARK: - Additional German Market Favorites
        // ─────────────────────────────────────────────

        Fragrance(
            id: "de_boss_bottled_elixir",
            name: "Boss Bottled Elixir",
            house: "Hugo Boss",
            accords: [.woody, .aromatic, .oriental],
            topNotes: ["Cardamom", "Apple", "Juniper Berries"],
            heartNotes: ["Sage", "Olibanum", "Iris"],
            baseNotes: ["Vetiver", "Virginia Cedar", "Patchouli"],
            moodTags: [.sophisticated, .warm, .bold],
            colorAssociations: ColorPreset.earthy(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "boss_bottled_elixir",
            shortDescription: "Incense-rich evolution of the Bottled dynasty.",
            bottleColor: "#3E2723",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_jil_sander_sun",
            name: "Sun",
            house: "Jil Sander",
            accords: [.floral, .oriental, .fruity],
            topNotes: ["Mandarin Orange", "Bergamot", "Peach"],
            heartNotes: ["Jasmine", "Rose", "Lily of the Valley", "Heliotrope"],
            baseNotes: ["Sandalwood", "Vanilla", "Amber", "Musk", "Benzoin"],
            moodTags: [.warm, .romantic, .serene],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .budget,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "jil_sander_sun",
            shortDescription: "Sunny amber-vanilla warmth from the Hamburg fashion house.",
            bottleColor: "#FFD700",
            bottleShape: .round
        ),

        Fragrance(
            id: "de_jil_sander_evergreen",
            name: "Evergreen",
            house: "Jil Sander",
            accords: [.fresh, .green, .citrus],
            topNotes: ["Mandarin Orange", "Green Tea", "Pear"],
            heartNotes: ["Magnolia", "Lily of the Valley", "Green Notes"],
            baseNotes: ["Cedar", "Musk", "Vetiver"],
            moodTags: [.fresh, .natural, .serene],
            colorAssociations: ColorPreset.green(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .budget,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "jil_sander_evergreen",
            shortDescription: "Crisp green-tea freshness for everyday wear.",
            bottleColor: "#228B22",
            bottleShape: .round
        ),

        Fragrance(
            id: "de_s_oliver_soul",
            name: "Soul Male",
            house: "s.Oliver",
            accords: [.aromatic, .woody, .fresh],
            topNotes: ["Grapefruit", "Mandarin Orange", "Cardamom"],
            heartNotes: ["Lavender", "Geranium", "Pepper"],
            baseNotes: ["Tonka Bean", "Patchouli", "Musk"],
            moodTags: [.fresh, .confident, .minimal],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .budget,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "s_oliver_soul",
            shortDescription: "Affordable German fashion house aromatic.",
            bottleColor: "#4682B4",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_bruno_banani_man",
            name: "Bruno Banani Man",
            house: "Bruno Banani",
            accords: [.aromatic, .spicy, .woody],
            topNotes: ["Bergamot", "Orange", "Cinnamon"],
            heartNotes: ["Cardamom", "Lavender", "Geranium"],
            baseNotes: ["Musk", "Cedar", "Sandalwood"],
            moodTags: [.bold, .energetic, .warm],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.fall, .winter, .spring],
            region: .german,
            priceTier: .budget,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "bruno_banani_man",
            shortDescription: "Accessible spicy-woody from the German fashion label.",
            bottleColor: "#800080",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_mexx_man",
            name: "Mexx Man",
            house: "Mexx",
            accords: [.aromatic, .fresh, .woody],
            topNotes: ["Basil", "Lemon", "Coriander"],
            heartNotes: ["Nutmeg", "Sage", "Geranium"],
            baseNotes: ["Sandalwood", "Cedar", "Musk"],
            moodTags: [.fresh, .minimal, .confident],
            colorAssociations: ColorPreset.green(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .budget,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "mexx_man",
            shortDescription: "Everyday Dutch-German herbal freshness.",
            bottleColor: "#556B2F",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_cerruti_1881",
            name: "1881 Pour Homme",
            house: "Cerruti",
            accords: [.woody, .aromatic, .fresh],
            topNotes: ["Bergamot", "Lavender", "Cypress"],
            heartNotes: ["Juniper Berries", "Lily of the Valley", "Carnation"],
            baseNotes: ["Sandalwood", "Cedarwood", "Amber", "Musk", "Patchouli"],
            moodTags: [.elegant, .serene, .vintage],
            colorAssociations: ColorPreset.green(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .budget,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "cerruti_1881",
            shortDescription: "Mediterranean cypress-lavender classic from the 90s.",
            bottleColor: "#6B8E23",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_prada_candy",
            name: "Candy",
            house: "Prada",
            accords: [.gourmand, .oriental, .musky],
            topNotes: ["Caramel"],
            heartNotes: ["Musks", "Powdery Notes"],
            baseNotes: ["Benzoin", "Vanilla", "Honey"],
            moodTags: [.playful, .sensual, .warm],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "prada_candy",
            shortDescription: "Pure caramel-benzoin indulgence in a candy-wrapper bottle.",
            bottleColor: "#FF6B6B",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_dior_homme",
            name: "Dior Homme",
            house: "Dior",
            accords: [.woody, .floral, .spicy],
            topNotes: ["Bergamot", "Pear", "Sage"],
            heartNotes: ["Iris", "Lavender", "Cardamom"],
            baseNotes: ["Vetiver", "Cedar", "Patchouli", "Leather"],
            moodTags: [.elegant, .sophisticated, .warm],
            colorAssociations: ColorPreset.neutral(),
            seasonality: [.spring, .fall],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "dior_homme",
            shortDescription: "Iris-forward masculinity, refined Parisian tailoring.",
            bottleColor: "#A9A9A9",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_versace_pour_homme",
            name: "Pour Homme",
            house: "Versace",
            accords: [.citrus, .aromatic, .fresh],
            topNotes: ["Lemon", "Neroli", "Bergamot", "Citruses", "Rose de Mai"],
            heartNotes: ["Hyacinth", "Cedar", "Clary Sage", "Blue Geranium"],
            baseNotes: ["Amber", "Musk", "Siam Benzoin"],
            moodTags: [.fresh, .elegant, .serene],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "versace_pour_homme",
            shortDescription: "Mediterranean citrus in a Grecian column bottle.",
            bottleColor: "#87CEEB",
            bottleShape: .round
        ),

        Fragrance(
            id: "de_lancome_miracle",
            name: "Miracle",
            house: "Lancôme",
            accords: [.floral, .spicy, .fresh],
            topNotes: ["Freesia", "Lychee", "Mandarin Orange"],
            heartNotes: ["Magnolia", "Jasmine", "Ginger", "Pepper"],
            baseNotes: ["Amber", "Musk", "Cashmere Wood"],
            moodTags: [.romantic, .elegant, .warm],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.spring, .fall],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "lancome_miracle",
            shortDescription: "Lychee-ginger optimism in a coral bottle.",
            bottleColor: "#FF7F50",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_mb_individuel",
            name: "Individuel",
            house: "Montblanc",
            accords: [.aromatic, .woody, .floral],
            topNotes: ["Lavender", "Cinnamon", "Juniper Berries"],
            heartNotes: ["Violet", "Coriander", "Jasmine"],
            baseNotes: ["Musk", "Raspberry", "Tonka Bean", "Chocolate"],
            moodTags: [.romantic, .sophisticated, .warm],
            colorAssociations: ColorPreset.purple(),
            seasonality: [.fall, .winter, .spring],
            region: .german,
            priceTier: .budget,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "mb_individuel",
            shortDescription: "Hidden gem violet-raspberry at a budget price.",
            bottleColor: "#4B0082",
            bottleShape: .round
        ),

        Fragrance(
            id: "de_bvlgari_man_wood",
            name: "Man Wood Essence",
            house: "Bvlgari",
            accords: [.woody, .aromatic, .citrus],
            topNotes: ["Coriander", "Cypress", "Citrus"],
            heartNotes: ["Cedar", "Vetiver"],
            baseNotes: ["Benzoin", "Ambroxan", "Organic Beeswax"],
            moodTags: [.natural, .sophisticated, .fresh],
            colorAssociations: ColorPreset.green(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "bvlgari_wood",
            shortDescription: "Sustainably crafted cedar-cypress from the Italian jeweler.",
            bottleColor: "#2E8B57",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_guerlain_aqua_allegoria",
            name: "Aqua Allegoria Mandarine Basilic",
            house: "Guerlain",
            accords: [.citrus, .green, .fresh],
            topNotes: ["Mandarin Orange", "Caraway"],
            heartNotes: ["Basil", "Green Tea", "Tarragon"],
            baseNotes: ["Musk", "Woody Notes"],
            moodTags: [.fresh, .playful, .natural],
            colorAssociations: ColorPreset.bright(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .luxury,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "guerlain_mandarine",
            shortDescription: "Zesty mandarin-basil from the Paris grande maison.",
            bottleColor: "#FF8C00",
            bottleShape: .flacon
        ),

        Fragrance(
            id: "de_armani_acqua_di_gio",
            name: "Acqua di Giò",
            house: "Giorgio Armani",
            accords: [.aquatic, .citrus, .aromatic],
            topNotes: ["Lime", "Lemon", "Bergamot", "Mandarin Orange", "Neroli", "Jasmine"],
            heartNotes: ["Calone", "Peach", "Freesia", "Cyclamen", "Rose", "Rosemary", "Nutmeg"],
            baseNotes: ["Cedar", "Musk", "Oakmoss", "Amber", "Patchouli"],
            moodTags: [.fresh, .serene, .cool],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "armani_adg",
            shortDescription: "The aquatic legend -- eternal Mediterranean freshness.",
            bottleColor: "#ADD8E6",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_carolina_herrera_212",
            name: "212 VIP Men",
            house: "Carolina Herrera",
            accords: [.aromatic, .woody, .spicy],
            topNotes: ["Caviar Lime", "Passion Fruit", "Ginger"],
            heartNotes: ["Vodka", "Mint", "King Wood"],
            baseNotes: ["Amber", "Tonka Bean", "Leather"],
            moodTags: [.bold, .energetic, .rebellious],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.spring, .fall],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "ch_212_vip",
            shortDescription: "Gold-can nightlife energy with vodka-ginger kick.",
            bottleColor: "#DAA520",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_dolce_the_one_femme",
            name: "The One for Her",
            house: "Dolce & Gabbana",
            accords: [.oriental, .floral, .gourmand],
            topNotes: ["Mandarin Orange", "Peach", "Lychee"],
            heartNotes: ["Jasmine", "Lily", "Plum"],
            baseNotes: ["Vanilla", "Vetiver", "Amber", "Musk"],
            moodTags: [.elegant, .warm, .sensual],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "dg_the_one_her",
            shortDescription: "Peachy-vanilla warmth with Italian elegance.",
            bottleColor: "#C19A6B",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_coach_floral",
            name: "Coach Floral",
            house: "Coach",
            accords: [.floral, .fruity, .fresh],
            topNotes: ["Pineapple", "Pink Pepper", "Mandarin Orange"],
            heartNotes: ["Rose", "Gardenia", "Jasmine"],
            baseNotes: ["Suede", "Musk", "Sandalwood"],
            moodTags: [.playful, .romantic, .fresh],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "coach_floral",
            shortDescription: "American rose-gardenia with a suede twist.",
            bottleColor: "#FFB6C1",
            bottleShape: .round
        ),

        Fragrance(
            id: "de_ysl_y_edp",
            name: "Y Eau de Parfum",
            house: "Yves Saint Laurent",
            accords: [.aromatic, .woody, .fresh],
            topNotes: ["Apple", "Ginger", "Bergamot"],
            heartNotes: ["Sage", "Juniper Berries", "Geranium"],
            baseNotes: ["Amberwood", "Tonka Bean", "Cedar", "Vetiver", "Olibanum"],
            moodTags: [.bold, .confident, .sophisticated],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "ysl_y",
            shortDescription: "Apple-sage freshness in a sleek Y-engraved bottle.",
            bottleColor: "#1C1C2E",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_bvlgari_omnia_crystalline",
            name: "Omnia Crystalline",
            house: "Bvlgari",
            accords: [.floral, .aquatic, .musky],
            topNotes: ["Nashi Pear", "Bamboo"],
            heartNotes: ["Lotus Blossom", "Balsa Wood", "Guava"],
            baseNotes: ["Musk", "Cashmere Wood"],
            moodTags: [.serene, .minimal, .fresh],
            colorAssociations: ColorPreset.white(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "bvlgari_omnia",
            shortDescription: "Crystal-clear lotus-bamboo serenity.",
            bottleColor: "#F0F0F0",
            bottleShape: .round
        ),

        Fragrance(
            id: "de_paco_phantom",
            name: "Phantom",
            house: "Paco Rabanne",
            accords: [.aromatic, .woody, .citrus],
            topNotes: ["Lemon", "Lavender", "Amalfi Lemon"],
            heartNotes: ["Smoke", "Lavender", "Apple"],
            baseNotes: ["Vanilla", "Cashmere Wood", "Styrax"],
            moodTags: [.energetic, .bold, .cool],
            colorAssociations: ColorPreset.cool(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "paco_phantom",
            shortDescription: "Robot-bottle futuristic lavender-vanilla.",
            bottleColor: "#C0C0C0",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_guerlain_lhomme_ideal",
            name: "L'Homme Idéal",
            house: "Guerlain",
            accords: [.oriental, .woody, .aromatic],
            topNotes: ["Almond", "Bergamot", "Rosemary"],
            heartNotes: ["Lavender", "Orange Blossom", "Bulgarian Rose"],
            baseNotes: ["Tonka Bean", "Vanilla", "Sandalwood", "Leather"],
            moodTags: [.warm, .sophisticated, .sensual],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "guerlain_lhomme_ideal",
            shortDescription: "Almond-vanilla-leather in an art deco bottle.",
            bottleColor: "#B8860B",
            bottleShape: .flacon
        ),

        Fragrance(
            id: "de_hermes_twilly",
            name: "Twilly d'Hermès",
            house: "Hermès",
            accords: [.floral, .spicy, .oriental],
            topNotes: ["Ginger"],
            heartNotes: ["Tuberose"],
            baseNotes: ["Sandalwood", "Vanilla"],
            moodTags: [.playful, .bold, .elegant],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.spring, .fall],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "hermes_twilly",
            shortDescription: "Ginger-tuberose surprise in a silk-wrapped bottle.",
            bottleColor: "#FF6347",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_jpg_le_male_le_parfum",
            name: "Le Male Le Parfum",
            house: "Jean Paul Gaultier",
            accords: [.oriental, .aromatic, .gourmand],
            topNotes: ["Cardamom", "Lavender", "Iris"],
            heartNotes: ["Lavandin", "Iris Absolute"],
            baseNotes: ["Vanilla", "Woody Notes", "Amber"],
            moodTags: [.sensual, .warm, .opulent],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .mid,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "jpg_le_male_parfum",
            shortDescription: "Richer, sweeter Le Male with iris-vanilla depth.",
            bottleColor: "#1A237E",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_givenchy_irresistible",
            name: "Irrésistible",
            house: "Givenchy",
            accords: [.floral, .fruity, .fresh],
            topNotes: ["Pear", "Ambrette"],
            heartNotes: ["Rose", "Iris", "Blond Wood"],
            baseNotes: ["Musk", "Cedar", "Amber"],
            moodTags: [.playful, .romantic, .elegant],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "givenchy_irresistible",
            shortDescription: "Swirling rose-pear dance in a twisted-glass bottle.",
            bottleColor: "#FFB6C1",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_tom_ford_noir",
            name: "Noir Extreme",
            house: "Tom Ford",
            accords: [.oriental, .spicy, .gourmand],
            topNotes: ["Mandarin Orange", "Neroli", "Cardamom", "Nutmeg", "Saffron"],
            heartNotes: ["Rose", "Jasmine", "Orange Blossom", "Ylang-Ylang", "Kulfi"],
            baseNotes: ["Sandalwood", "Vanilla", "Amber", "Woody Notes"],
            moodTags: [.opulent, .sensual, .warm],
            colorAssociations: ColorPreset.dark(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .masculine,
            amazonASIN: nil,
            iconName: "tf_noir_extreme",
            shortDescription: "Kulfi-spiced amber luxury for cold winter nights.",
            bottleColor: "#1A1A1A",
            bottleShape: .square
        ),

        Fragrance(
            id: "de_chanel_no5",
            name: "N°5",
            house: "Chanel",
            accords: [.floral, .powdery, .oriental],
            topNotes: ["Aldehydes", "Bergamot", "Lemon", "Neroli", "Ylang-Ylang"],
            heartNotes: ["Jasmine", "Rose", "Lily of the Valley", "Iris"],
            baseNotes: ["Sandalwood", "Vanilla", "Vetiver", "Musk", "Amber", "Patchouli", "Oakmoss"],
            moodTags: [.elegant, .vintage, .sophisticated],
            colorAssociations: ColorPreset.gold(),
            seasonality: [.fall, .winter, .spring],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "chanel_no5",
            shortDescription: "The world's most famous fragrance since 1921.",
            bottleColor: "#F5DEB3",
            bottleShape: .tall
        ),

        Fragrance(
            id: "de_marc_jacobs_perfect",
            name: "Perfect",
            house: "Marc Jacobs",
            accords: [.floral, .gourmand, .woody],
            topNotes: ["Rhubarb", "Daffodil"],
            heartNotes: ["Almond Milk", "Jasmine", "Iris"],
            baseNotes: ["Cedar", "Cashmeran", "Musk"],
            moodTags: [.playful, .serene, .minimal],
            colorAssociations: ColorPreset.white(),
            seasonality: [.spring, .summer],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "mj_perfect",
            shortDescription: "Almond-milk softness with charm-bracelet cap.",
            bottleColor: "#FAFAD2",
            bottleShape: .round
        ),

        Fragrance(
            id: "de_dior_poison_girl",
            name: "Poison Girl",
            house: "Dior",
            accords: [.oriental, .gourmand, .floral],
            topNotes: ["Bitter Orange", "Lemon"],
            heartNotes: ["Damascena Rose", "Grasse Rose"],
            baseNotes: ["Tonka Bean", "Vanilla", "Sandalwood", "Almond"],
            moodTags: [.sensual, .bold, .playful],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .luxury,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "dior_poison_girl",
            shortDescription: "Bitter orange-vanilla seduction, a modern Poison.",
            bottleColor: "#CC3366",
            bottleShape: .round
        ),

        Fragrance(
            id: "de_versace_eros_femme",
            name: "Eros Pour Femme",
            house: "Versace",
            accords: [.floral, .oriental, .woody],
            topNotes: ["Sicilian Lemon", "Calabrian Bergamot", "Pomegranate"],
            heartNotes: ["Lemon Blossom", "Jasmine Sambac", "Peony"],
            baseNotes: ["Sandalwood", "Ambrofix", "Musk", "Precious Woods"],
            moodTags: [.bold, .sensual, .confident],
            colorAssociations: ColorPreset.pink(),
            seasonality: [.spring, .fall],
            region: .german,
            priceTier: .mid,
            gender: .feminine,
            amazonASIN: nil,
            iconName: "versace_eros_femme",
            shortDescription: "Pink goddess counterpart to the blue Eros.",
            bottleColor: "#FF69B4",
            bottleShape: .modern
        ),

        Fragrance(
            id: "de_nishane_hacivat",
            name: "Hacivat",
            house: "Nishane",
            accords: [.fruity, .woody, .fresh],
            topNotes: ["Pineapple", "Bergamot", "Grapefruit"],
            heartNotes: ["Jasmine", "Rose", "Patchouli"],
            baseNotes: ["Oakmoss", "Cedarwood", "Sandalwood", "Musk"],
            moodTags: [.bold, .confident, .energetic],
            colorAssociations: ColorPreset.green(),
            seasonality: [.spring, .summer, .fall],
            region: .german,
            priceTier: .luxury,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "nishane_hacivat",
            shortDescription: "Turkish niche pineapple-oakmoss, an Aventus rival.",
            bottleColor: "#2E8B57",
            bottleShape: .flacon
        ),

        Fragrance(
            id: "de_lattafa_raghba",
            name: "Raghba",
            house: "Lattafa",
            accords: [.oriental, .gourmand, .woody],
            topNotes: ["Saffron", "Cinnamon"],
            heartNotes: ["Oud", "Rose"],
            baseNotes: ["Vanilla", "Musk", "Amber", "Sandalwood"],
            moodTags: [.warm, .opulent, .cozy],
            colorAssociations: ColorPreset.warm(),
            seasonality: [.fall, .winter],
            region: .german,
            priceTier: .budget,
            gender: .unisex,
            amazonASIN: nil,
            iconName: "lattafa_raghba",
            shortDescription: "Budget oud-vanilla from the Arabian house, a TikTok DACH hit.",
            bottleColor: "#8B4513",
            bottleShape: .flacon
        ),

    ]
}
