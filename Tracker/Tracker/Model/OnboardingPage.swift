import UIKit

enum OnboardingPage: CaseIterable {
    case first
    case second
    
    var title: String {
        switch self {
        case .first:
            return NSLocalizedString("first", comment: "text for first onboarding page")
        case .second:
            return NSLocalizedString("second", comment: "text for second onboarding page")
        }
    }
    
    var image: UIImage {
        switch self {
        case .first:
            return UIImage(resource: .onboardingBackground1)
        case .second:
            return UIImage(resource: .onboardingBackground2)
        }
    }
}

