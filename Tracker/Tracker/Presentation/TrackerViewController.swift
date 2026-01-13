import UIKit

final class TrackerViewController: UIViewController {
    
    // MARK: - Properties
    
    private let trackerService = TrackerService.shared
    
    private var visibleCategories: [TrackerCategory] = []
    private var currentDate = Date()
    private var searchText = ""

    private var selectedFilter: FilterList {
        get { UserDefaultsService.shared.currentFilter }
        set { UserDefaultsService.shared.currentFilter = newValue }
    }
    
    private let editTitle = NSLocalizedString("EditTitle", comment: "Text")
    private let deleteTitle = NSLocalizedString("DeleteTitle", comment: "Text")
    private let cancelTitle = NSLocalizedString("CancelTitle", comment: "Text")
    private let messageAlert = NSLocalizedString("MessageTitle", comment: "Text")
    
    // MARK: - UI Elements
    
    private lazy var addTrackerButton: UIButton = {
        let button = UIButton()
        let image = UIImage(resource: .addTracker).withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .ypBlackDay
        button.addTarget(self, action: #selector(addTracker), for: .touchUpInside)
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.reuseIdentifier)
        collectionView.register(TrackerCategoryHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TrackerCategoryHeader.reuseIdentifier)
        collectionView.backgroundColor = .ypWhiteDay
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    private lazy var emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    private lazy var emptyStateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emptyStateImageView, emptyStateLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        let title = NSLocalizedString("filterButtonTitle", comment: "filterTitle text")
        button.backgroundColor = .ypBlue
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(tapFilter), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupNavigationBar()
        trackerService.delegate = self
        updateVisibleCategories()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .ypWhiteDay
        [collectionView, emptyStateStackView, filterButton].forEach {view.addSubview($0)}
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTrackerButton)
        navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = NSLocalizedString("searchPlaceholderTitle", comment: "search text")
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setupConstraints() {
        [collectionView, emptyStateStackView, datePicker, filterButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 80),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func showEmptyState(_ state: EmptyState?) {
        guard let state = state else {
            emptyStateStackView.isHidden = true
            collectionView.isHidden = false
            filterButton.isHidden = false
            return
        }
        collectionView.isHidden = true
        emptyStateStackView.isHidden = false
        
        switch state {
        case .noTrackers:
            emptyStateImageView.image = UIImage(resource: .star)
            emptyStateLabel.text = NSLocalizedString("EmptyTrackersLabel", comment: "text")
            filterButton.isHidden = true
        case .noResults:
            emptyStateImageView.image = UIImage(resource: .search)
            emptyStateLabel.text = NSLocalizedString(
                "EmptySearchLabel",
                comment: "No search results"
            )
            filterButton.isHidden = false
        }
    }
    
    private func updateVisibleCategories() {

        let categoriesForDate = trackerService.fetchTrackerForDate(for: currentDate)
        let filteredCategories = trackerService.filterTrackers(categoriesForDate, by: selectedFilter, date: currentDate)
        visibleCategories = applySearch(to: filteredCategories)

        if categoriesForDate.isEmpty {
            showEmptyState(.noTrackers)
        } else if visibleCategories.isEmpty {
            showEmptyState(.noResults)
        } else {
            showEmptyState(nil)
        }

        filterButton.setTitleColor((selectedFilter == .all || selectedFilter == .today) ? .ypWhite : .ypRed, for: .normal)

        collectionView.reloadData()
    }


    
    private func applySearch(to categories: [TrackerCategory]) -> [TrackerCategory] {
        
        guard !searchText.isEmpty else { return categories }
        
        return categories.compactMap { category in
            let filteredTrackers = category.trackers.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
            
            return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
    }
    
    private var pendingReloadIndexPath: IndexPath?
    
    private func completeTracker(_ tracker: Tracker, isCompleted: Bool,at indexPath: IndexPath) {
        guard trackerService.canCompletedTracker(on: currentDate) else {
            showFutureDateAlert()
            return
        }
        
        pendingReloadIndexPath = indexPath
        trackerService.toggleCompletion(for: tracker, on: currentDate)
    }

    private func showFutureDateAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("FutureDateAlertTitle", comment: "title text"),
            message: NSLocalizedString("FutureDateAlertMessage", comment: "message text"),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func tapFilter() {
        let filterVC = FiltersViewController()
        filterVC.selectedFilter = selectedFilter
        filterVC.delegate = self
        let navController = UINavigationController(rootViewController: filterVC)
        present(navController, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date

        if selectedFilter == .today {
            selectedFilter = .all
        }

        updateVisibleCategories()
        print("Выбраная дата: \(currentDate)")
    }
    
    @objc private func addTracker() {
        let createTypeVC = CreateTypeTrackerViewController()
        let navController = UINavigationController(rootViewController: createTypeVC)
        present(navController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.reuseIdentifier, for: indexPath ) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.item]
        let completedDays = trackerService.getCompletedDaysCount(for: tracker)
        let isCompletedToday = trackerService.isTrackerCompleted(tracker, on: currentDate)
        
        cell.configure(with: tracker, completedDays: completedDays, isCompletedToday: isCompletedToday)
        cell.onComplete = { [weak self] tracker, isCompleted in
            self?.completeTracker(
                tracker,
                isCompleted: isCompleted,
                at: indexPath
            )
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackerCategoryHeader.reuseIdentifier,
                for: indexPath
              ) as? TrackerCategoryHeader else {
            return UICollectionReusableView()
        }
        
        let category = visibleCategories[indexPath.section]
        header.configure(with: category.title)
        
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - 10
        let width = availableWidth / 2
        return CGSize(width: width, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.item]
        let category = visibleCategories[indexPath.section].title
        
        let editAction = UIAction(title: editTitle) { _ in
            self.editTracker(tracker, category: category)}
        
        let deleteAction = UIAction(title: deleteTitle) { _ in
            self.showDeleteAlert(for: tracker)
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in UIMenu(title: "", children: [editAction, deleteAction])
        }
     
    }
    
private func editTracker(_ tracker: Tracker, category: String) {
    let editTrackerViewController = CreateNewHabitViewController(mode: .edit(tracker: tracker, category: category))
    let navController = UINavigationController(rootViewController: editTrackerViewController)
    present(navController, animated: true)
    }
    
    private func showDeleteAlert(for tracker: Tracker) {
        let alert = UIAlertController(
            title: nil,
            message: messageAlert,
            preferredStyle: .actionSheet
        )

        alert.addAction(UIAlertAction(
            title: cancelTitle,
            style: .cancel
        ))

        alert.addAction(UIAlertAction(
            title: deleteTitle,
            style: .destructive
        ) { [weak self] _ in
            self?.trackerService.deleteTracker(tracker)
        })

        present(alert, animated: true)
    }
    
    
}

extension TrackerViewController: TrackerServiceDelegate {
    func trackersDidUpdate() {
        
        updateVisibleCategories()
    }
    
}

extension TrackerViewController: FiltersViewControllerDelegate {
    func filtersViewController(_ controller: FiltersViewController, didSelectFilter filter: FilterList) {
        selectedFilter = filter
        if filter == .today {
            currentDate = Date()
            datePicker.date = currentDate
        }
        updateVisibleCategories()
    }
}

extension TrackerViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text ?? ""
        updateVisibleCategories()
    }
}
