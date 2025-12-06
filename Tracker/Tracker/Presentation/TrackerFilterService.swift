import UIKit

final class TrackerFilterService {
    
    func filterVisibleCategories(
        categories: [TrackerCategory],
        selectedWeekday: Int
    ) -> [TrackerCategory] {
        categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                tracker.schedule.map(\.сalendarDay).contains(selectedWeekday)
            }
            
            guard !filteredTrackers.isEmpty else { return nil }
            return TrackerCategory(
                title: category.title,
                trackers: filteredTrackers
            )
        }
    }
    
    func getCompletedDaysCount(for tracker: Tracker, completedTrackers: [TrackerRecord]) -> Int {
        completedTrackers.count { $0.trackerId == tracker.id }
    }
    
    func isTrackerCompletedToday(
        _ tracker: Tracker,
        completedTrackers: [TrackerRecord],
        currentDate: Date
    ) -> Bool {
        let calendar = Calendar.current
        return completedTrackers.contains { record in
            record.trackerId == tracker.id &&
            calendar.isDate(record.date, inSameDayAs: currentDate)
        }
    }
    
    func canCompleteTracker(on date: Date) -> Bool {
        date <= Date()
    }
}
