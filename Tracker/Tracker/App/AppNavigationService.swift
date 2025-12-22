import UIKit

final class AppNavigationService {

    static let shared = AppNavigationService()

    private let defaults = UserDefaults.standard
    private weak var window: UIWindow?

    private let onboardingKey = "OnboardingCompleted"

    private init() {}

    func start(window: UIWindow) -> UIViewController {
        self.window = window

        if defaults.bool(forKey: onboardingKey) {
            return TapBarViewController()
        }

        let onboarding = OnboardingPageController()

        onboarding.onFinish = { [weak self] in
            self?.finishOnboarding()
        }

        return onboarding
    }

    private func finishOnboarding() {
        defaults.set(true, forKey: onboardingKey)

        window?.rootViewController = TapBarViewController()
        window?.makeKeyAndVisible()
    }
}


