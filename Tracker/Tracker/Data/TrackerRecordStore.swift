import CoreData
import UIKit

final class TrackerRecordStore {
    
    // MARK: - Properties
    
    private let context: NSManagedObjectContext
    
    // MARK: - Initializers
    
    convenience init() {
        self.init(context: TrackerDataService.shared.context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    
    func addRecord(_ record: TrackerRecord) {
        let recordCoreData = TrackerRecordCoreData(context: context)
        recordCoreData.date = record.date
        recordCoreData.trackerId = record.trackerId
        
        TrackerDataService.shared.saveContext()
    }
    
    func deleteRecord(_ record: TrackerRecord) {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()

        let startOfDay = Calendar.current.startOfDay(for: record.date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

        fetchRequest.predicate = NSPredicate(
            format: "trackerId == %@ AND date >= %@ AND date < %@",
            record.trackerId as CVarArg,
            startOfDay as CVarArg,
            endOfDay as CVarArg
        )

        if let foundRecord = try? context.fetch(fetchRequest).first {
            context.delete(foundRecord)
            TrackerDataService.shared.saveContext()
        }
    }

    
    func fetchRecords() -> Set<TrackerRecord> {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        let coreDataRecords = (try? context.fetch(fetchRequest)) ?? []
        
        return Set(coreDataRecords.compactMap { decode($0) })
    }
    
    // MARK: - Decoding
    
    private func decode(_ data: TrackerRecordCoreData) -> TrackerRecord? {
        guard let id = data.trackerId,
              let date = data.date else { return nil }
        return TrackerRecord(trackerId: id, date: date)
    }
}
