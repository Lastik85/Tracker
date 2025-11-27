import UIKit

final class TrackerFilterService {
    
    func filterVisibleCategories(
        categories: [TrackerCategory],
        selectedWeekday: Int
    ) -> [TrackerCategory] {
        return categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                let matchesSchedule = tracker.schedule.map { $0.CalendarDay }.contains(selectedWeekday)
                return matchesSchedule
            }
            
            return filteredTrackers.isEmpty ? nil : TrackerCategory(
                title: category.title,
                trackers: filteredTrackers
            )
        }
    }
    
    func getCompletedDaysCount(for tracker: Tracker, completedTrackers: [TrackerRecord]) -> Int {
        return completedTrackers.filter { $0.trackerId == tracker.id }.count
    }
    
    func isTrackerCompletedToday(_ tracker: Tracker, completedTrackers: [TrackerRecord], currentDate: Date) -> Bool {
        let calendar = Calendar.current
        return completedTrackers.contains {
            $0.trackerId == tracker.id && calendar.isDate($0.date, inSameDayAs: currentDate)
        }
    }
    
    func canCompleteTracker(on date: Date) -> Bool {
        return date <= Date()
    }
}
