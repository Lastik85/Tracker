import Foundation

final class UserDefaultsService {

    static let shared = UserDefaultsService()

    private let storage = UserDefaults.standard

    private init() {}

    var hasSeenOnboarding: Bool {
        get {
            storage.bool(forKey: UserDefaultsKeys.hasSeenOnboarding)
        }
        set {
            storage.set(newValue, forKey: UserDefaultsKeys.hasSeenOnboarding)
        }
    }
    
    var currentFilter: FilterList {
        get {
            if let rawValue = storage.string(forKey: UserDefaultsKeys.filter),
               let filter = FilterList(rawValue: rawValue) {
                return filter
            }
            return .all
        }
        set {
            storage.set(newValue.rawValue, forKey: UserDefaultsKeys.filter)
        }
    }
    
    func clearCurrentFilter() {
        storage.removeObject(forKey: UserDefaultsKeys.filter)
    }

    
}

enum UserDefaultsKeys {
    static let onboardingCompleted = "OnboardingCompleted"
    static let hasSeenOnboarding = "hasSeenOnboarding"
    static let filter = "currentFilter"
}
