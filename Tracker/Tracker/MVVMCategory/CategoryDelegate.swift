protocol CategoryListViewControllerDelegate: AnyObject {
    func didSelectCategory(_ categoryTitle: String)
}

protocol CreateNewCategoryViewControllerDelegate: AnyObject {
    func didCreateCategory()
}
