import UIKit

final class TrackerService {
    
    // MARK: - Properties
    
    static let shared = TrackerService()
    weak var delegate: TrackerServiceDelegate?
    
    private let trackerCore = TrackerStore.shared
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerRecordStore = TrackerRecordStore()
    private let calendar = Calendar.current
    
    // MARK: - Tracker Management
    
    func addCategory(_ category: TrackerCategory) {
        trackerCategoryStore.addCategory(category)
    }
    
    func fetchCategories() -> [TrackerCategory] {
        trackerCategoryStore.fetchCategories()
    }
    
    
    func createTracker(_ tracker: Tracker, inCategory categoryTitle: String) {
        let categories = trackerCategoryStore.fetchCategories()
        let categoryExists = categories.contains { $0.title == categoryTitle }
        if !categoryExists {
            let newCategory = TrackerCategory(title: categoryTitle, trackers: [])
            trackerCategoryStore.addCategory(newCategory)
            print("TrackerService: created category '\(categoryTitle)'")
        }
        trackerCategoryStore.addTrackerToCategory(tracker, category: categoryTitle)

        delegate?.trackersDidUpdate()
    }
//получение по выбранной дате
    func fetchTrackerForDate(for date: Date) -> [TrackerCategory] {
        guard let selectedWeekDay = weekday(from: date) else {
            return []
        }

        let categories = trackerCategoryStore.fetchCategories()

        return categories.compactMap { category in
            let trackersForDay = category.trackers.filter {
                $0.schedule.contains(selectedWeekDay)
            }

            guard !trackersForDay.isEmpty else { return nil }
            return TrackerCategory(title: category.title, trackers: trackersForDay)
        }
    }
    // фильтрация по выбранному фильтру
    
    func filterTrackers(_ categories: [TrackerCategory], by filter: FilterList, date: Date) -> [TrackerCategory] {
        switch filter {
        case .all, .today:
            return categories
        case .completed:
            return categories.compactMap { category in
                let filtered = category.trackers.filter { isTrackerCompleted($0, on: date) }
                return filtered.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filtered)
            }
        case .uncompleted:
            return categories.compactMap { category in
                let filtered = category.trackers.filter { !isTrackerCompleted($0, on: date) }
                return filtered.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filtered)
            }
        }
    }
    
    // MARK: - Tracker Completion

    func toggleCompletion(for tracker: Tracker, on date: Date) {
        guard canCompletedTracker(on: date) else {
            return
        }
        if isTrackerCompleted(tracker, on: date) {
            trackerRecordStore.deleteRecord(TrackerRecord(trackerId: tracker.id, date: date))
        } else {
            trackerRecordStore.addRecord(TrackerRecord(trackerId: tracker.id, date: date))
        }
        delegate?.trackersDidUpdate()
    }
    
    func canCompletedTracker(on date: Date) -> Bool{
        date <= Date()
    }
    
    func isTrackerCompleted(_ tracker: Tracker, on date: Date) -> Bool{
        let records = trackerRecordStore.fetchRecords()
        
        return records.contains { record in
            record.trackerId == tracker.id && calendar.isDate(record.date, inSameDayAs: date)
        }
    }
    
    func getCompletedDaysCount(for tracker: Tracker) -> Int {
        let records = trackerRecordStore.fetchRecords()
        return records.filter { $0.trackerId == tracker.id }.count
    }
    
    private func weekday(from date: Date) -> Week? {
        let weekdayIndex = calendar.component(.weekday, from: date)

        return Week.allCases.first {
            $0.calendarDay == weekdayIndex
        }
    }
}
