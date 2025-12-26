import UIKit

typealias Binding<T> = (T) -> ()

final class CategoryViewModel {
    
    private let trackerService = TrackerService.shared
    
    var categoriesBinding: Binding<[TrackerCategory]>?
    
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            categoriesBinding?(categories)
        }
    }

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
