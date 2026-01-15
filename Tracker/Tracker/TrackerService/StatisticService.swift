import Foundation

final class StatisticService {

    // MARK: - Singleton
    static let shared = StatisticService()

    // MARK: - Properties
    private let trackerRecordStore = TrackerRecordStore()

    // MARK: - Init
    private init() {}

    // MARK: - Public Methods
    func completedTrackersCount() -> Int {
        trackerRecordStore.fetchRecords().count
    }
}
