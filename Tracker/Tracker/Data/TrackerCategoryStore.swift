import CoreData
import UIKit

final class TrackerCategoryStore: NSObject {
    
    // MARK: - Properties
    
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore.shared
    
    // MARK: - FetchedResultsController
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)]
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
    
    func addCategory(_ category: TrackerCategory) {
        let trackerCategory = TrackerCategoryCoreData(context: context)
        trackerCategory.title = category.title
        trackerCategory.trackers = []
        TrackerDataService.shared.saveContext()
    }
    func addTrackerToCategory(_ tracker: Tracker, category title: String) {
        let newTracker = trackerStore.addTracker(tracker)
        try? fetchedResultsController.performFetch()
        
        let category = fetchedResultsController.fetchedObjects?
            .first { $0.title == title }
        
        category?.addToTrackers(newTracker)
        TrackerDataService.shared.saveContext()
        
        print("CategoryStore: добавлен трекер '\(tracker.name)' в категорию '\(title)'")
        print("Трекеров в ктаегории:", category?.trackers?.count ?? 0)
    }
    
    func fetchCategories() -> [TrackerCategory] {
        guard let objects = fetchedResultsController.fetchedObjects else { return [] }
        
        return objects.map { cdCategory in
            let title = cdCategory.title ?? ""
            let trackerObjects = (cdCategory.trackers as? Set<TrackerCoreData>) ?? []
            let trackers: [Tracker] = trackerObjects.compactMap {
                do {
                    let decoded = try trackerStore.decode($0)
                    return decoded
                } catch {
                    print("❌ Decode error:", error)
                    return nil
                }
            }
            return TrackerCategory(title: title,trackers: trackers)
        }
    }
}
