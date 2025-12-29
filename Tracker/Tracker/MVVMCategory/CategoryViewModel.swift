import UIKit

typealias Binding<T> = (T) -> ()

final class CategoryViewModel {
    
    // MARK: - Services
    
    private let trackerService = TrackerService.shared
    
    // MARK: - Bindings
    
    var categoriesBinding: Binding<[TrackerCategory]>?
    
    // MARK: - Properties
    
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            categoriesBinding?(categories)
        }
    }
    
    // MARK: - Public Methods
    
    func addCategory(_ category: TrackerCategory) {
        trackerService.addCategory(category)
    }
    
    func fetchCategories() {
        categories = trackerService.fetchCategories()
    }

    func categoryTitle(at index: Int) -> String {
        categories[index].title
    }
}
