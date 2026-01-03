import UIKit

enum OnboardingPage: CaseIterable {
    case first
    case second
    
    var title: String {
        switch self {
        case .first:
            return "Отслеживайте только то, что хотите"
        case .second:
            return "Даже если это не литры воды и йога"
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

