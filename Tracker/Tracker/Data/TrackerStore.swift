import CoreData
import UIKit

final class TrackerStore: NSObject {
    
    // MARK: - Properties
    
    static let shared = TrackerStore()
    
    private enum TrackerStoreError: Error {
        case decodingError
    }
    
    private let context: NSManagedObjectContext
    private let colorMarshalling = UIColorMarshalling()
    
    // MARK: - FetchedResultsController
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        try? controller.performFetch()
        return controller
    }()
    
    // MARK: - Initializers
    
    convenience override init() {
        self.init(context: TrackerDataService.shared.context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    // MARK: - Public Methods
    
    func addTracker(_ tracker: Tracker) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = colorMarshalling.hexString(from: tracker.color)
        
        let encodedSchedule = Week.encode(tracker.schedule)
        trackerCoreData.schedule = encodedSchedule
        
        TrackerDataService.shared.saveContext()
        print("Saved tracker:", tracker.name, "id:", tracker.id, "schedule:", encodedSchedule, "scheduleSet:", tracker.schedule.map { $0.rawValue })
        
        return trackerCoreData
    }
    
    
    func fetchTrackers() -> [Tracker] {
        guard let trackerCoreDataObjects = fetchedResultsController.fetchedObjects else {
            print("FetchedResultsController returned nil")
            return []
        }
        return trackerCoreDataObjects.compactMap { trackerCoreData in
            do {
                let tracker = try decode(trackerCoreData)
                return tracker
            } catch {
                print("Decode error for object:", trackerCoreData, error)
                return nil
            }
        }
    }
    
    // MARK: - Decoding
    
    func decode(_ data: TrackerCoreData) throws -> Tracker {
        guard let id = data.id,
              let name = data.name,
              let emoji = data.emoji,
              let hex = data.color
        else {
            throw TrackerStoreError.decodingError
        }
        let schedule = Week.decode(from: data.schedule)
        
        return Tracker(
            id: id,
            name: name,
            color: colorMarshalling.color(from: hex),
            emoji: emoji,
            schedule: schedule
        )
    }
    
}
