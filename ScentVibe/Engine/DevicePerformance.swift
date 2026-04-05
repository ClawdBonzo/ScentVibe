import SwiftUI

// MARK: - Device Performance Tier
// Determines rendering quality tier based on hardware capabilities.
// Used to scale particle counts, frame rates, and visual complexity
// so older devices stay smooth while new devices look stunning.

enum PerformanceTier: Int, Comparable {
    case low = 0    // iPhone 8, SE 2nd gen, older iPads
    case mid = 1    // iPhone 11/12, A13-A14
    case high = 2   // iPhone 13+, A15+, M-series

    static func < (lhs: PerformanceTier, rhs: PerformanceTier) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    /// Particle count multiplier: low=0.4, mid=0.7, high=1.0
    var particleScale: Double {
        switch self {
        case .low:  return 0.4
        case .mid:  return 0.7
        case .high: return 1.0
        }
    }

    /// Target frame interval for TimelineView (seconds)
    var frameInterval: Double {
        switch self {
        case .low:  return 1.0 / 30.0   // 30 fps
        case .mid:  return 1.0 / 45.0   // 45 fps
        case .high: return 1.0 / 60.0   // 60 fps
        }
    }

    /// Max blur radius to apply (blur is expensive on older GPUs)
    var maxBlurRadius: CGFloat {
        switch self {
        case .low:  return 3
        case .mid:  return 5
        case .high: return 8
        }
    }
}

// MARK: - Singleton Resolver

enum DevicePerformance {
    /// Cached performance tier, computed once at launch
    static let current: PerformanceTier = {
        let cores = ProcessInfo.processInfo.activeProcessorCount
        let ram = ProcessInfo.processInfo.physicalMemory

        // A15+ chips have 6 cores and 4+ GB RAM
        if cores >= 6 && ram >= 4_000_000_000 {
            return .high
        }
        // A13-A14 typically 6 cores but less RAM, or 4-core with decent RAM
        if cores >= 4 && ram >= 3_000_000_000 {
            return .mid
        }
        return .low
    }()

    /// Scaled particle count: applies tier multiplier, ensures at least 3
    static func scaledCount(_ baseCount: Int) -> Int {
        max(3, Int(Double(baseCount) * current.particleScale))
    }

    /// Whether heavy effects (Canvas particles, blur layers) should render
    /// Respects both the system accessibility setting and the user's manual override
    static var shouldRenderEffects: Bool {
        !UserDefaults.standard.bool(forKey: "forceReduceEffects")
    }
}
