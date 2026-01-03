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
}

enum UserDefaultsKeys {
    static let onboardingCompleted = "OnboardingCompleted"
    static let hasSeenOnboarding = "hasSeenOnboarding"
}
