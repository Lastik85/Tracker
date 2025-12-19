import CoreData

final class TrackerDataService {
    
    static let shared = TrackerDataService()
    
    // MARK: - Core Data stack
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Load Persistent Store failed: \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Core Data saving support
    
    func saveContext() {
        let context = self.context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
                context.rollback()
            }
        }
    }
    
}
