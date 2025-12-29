import UIKit

final class AppNavigationService {

    static let shared = AppNavigationService()

    private let userDefaultsService = UserDefaultsService.shared
    private weak var window: UIWindow?

    private let onboardingKey = UserDefaultsKeys.onboardingCompleted

    private init() {}

    func start(window: UIWindow) -> UIViewController {
        self.window = window

        if userDefaultsService.hasSeenOnboarding {
            return TapBarViewController()
        }

        let onboarding = OnboardingPageController()

        onboarding.onFinish = { [weak self] in
            self?.finishOnboarding()
        }

        return onboarding
    }

    private func finishOnboarding() {
        userDefaultsService.hasSeenOnboarding = true

        window?.rootViewController = TapBarViewController()
        window?.makeKeyAndVisible()
    }
}


