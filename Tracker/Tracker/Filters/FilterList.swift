import Foundation

enum FilterList: String, CaseIterable, Equatable {
    
    case all
    case today
    case completed
    case uncompleted
    
    var title: String {
        switch self {
        case .all: NSLocalizedString("all", comment: "All trackers")
        case .today: NSLocalizedString("today", comment: "Trackers for today")
        case .completed: NSLocalizedString("completed", comment: "Completed")
        case .uncompleted: NSLocalizedString("uncompleted", comment: "Not completed")
        }
    }
    
    var shouldShowCheckmark: Bool {
        switch self {
        case .completed, .uncompleted:
            return true
        case .all, .today:
            return false
        }
    }
}
