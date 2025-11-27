import UIKit

final class TrackerViewController: UIViewController {

    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var visibleCategories: [TrackerCategory] = []
    private var currentDate = Date()

    private let filterService = TrackerFilterService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupNavigationBar()
        updateVisibleCategories()
        //setupMockData()
    }

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
        return collectionView
    }()
    
    private lazy var emptyTrackerImage: UIImageView = {
        let image = UIImage(resource: .star)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var emptyTrackerLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emptyTrackerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emptyTrackerImage, emptyTrackerLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()

    private func setupUI() {
        view.backgroundColor = .ypWhiteDay
        view.addSubview(collectionView)
        view.addSubview(emptyTrackerStackView)
    }
    
        private func setupNavigationBar() {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(resource: .plus), style: .plain, target: self, action: #selector(addTracker))
            navigationItem.leftBarButtonItem?.tintColor = .black
            navigationController?.navigationBar.prefersLargeTitles = true
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchBar.placeholder = "Поиск"
            navigationItem.searchController = searchController
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        emptyTrackerImage.translatesAutoresizingMaskIntoConstraints = false
        emptyTrackerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyTrackerImage.heightAnchor.constraint(equalToConstant: 80),
            emptyTrackerImage.widthAnchor.constraint(equalToConstant: 80),
            emptyTrackerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyTrackerStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            datePicker.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        updateVisibleCategories()
    }
    
    @objc private func addTracker() {
        let createTypeVC = CreateTypeTrackerViewController()
        let navController = UINavigationController(rootViewController: createTypeVC)
        present(navController, animated: true)
    }

    private func updateVisibleCategories() {
        let calendar = Calendar.current
        let selectedWeekday = calendar.component(.weekday, from: currentDate)
        
        visibleCategories = filterService.filterVisibleCategories(
            categories: categories,
            selectedWeekday: selectedWeekday
        )
        
        emptyTrackerStackView.isHidden = !visibleCategories.isEmpty
        collectionView.reloadData()
    }
    
    private func completeTracker(_ tracker: Tracker, isCompleted: Bool) {
        guard filterService.canCompleteTracker(on: currentDate) else {
            showFutureDateAlert()
            return
        }
        let calendar = Calendar.current
        if isCompleted {
            let record = TrackerRecord(trackerId: tracker.id, date: currentDate)
            if !completedTrackers.contains(where: {
                $0.trackerId == tracker.id && calendar.isDate($0.date, inSameDayAs: currentDate)
            }) {
                completedTrackers.append(record)
            }
        } else {
            completedTrackers.removeAll {
                $0.trackerId == tracker.id && calendar.isDate($0.date, inSameDayAs: currentDate)
            }
        }
        
        collectionView.reloadData()
    }
    
    private func showFutureDateAlert() {
        let alert = UIAlertController(
            title: "Нельзя отмечать будущие даты",
            message: "Вы можете отмечать трекеры только за прошедшие и текущие даты",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
//    private func setupMockData() {
//        let mockTrackers = [
//            Tracker(
//                id: UUID(),
//                name: "Поливать растения",
//              color: .colorSelection5,
//                emoji: "💧",
//                schedule: Set([.monday, .wednesday, .friday, .sunday])
//            ),
//            Tracker(
//                id: UUID(),
//                name: "Читать книгу",
//                color: .colorSelection5,
//                emoji: "📚",
//                schedule: Set([.tuesday, .thursday, .saturday])
//            )
//        ]
//        
//        let mockCategories = [
//            TrackerCategory(title: "Домашний уют", trackers: [mockTrackers[0]]),
//            TrackerCategory(title: "Саморазвитие", trackers: [mockTrackers[1]])
//        ]
//        
//        categories = mockCategories
//        updateVisibleCategories()
//    }
}

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.item]
        let completedDays = filterService.getCompletedDaysCount(for: tracker, completedTrackers: completedTrackers)
        let isCompletedToday = filterService.isTrackerCompletedToday(tracker, completedTrackers: completedTrackers, currentDate: currentDate)
        
        cell.configure(with: tracker, completedDays: completedDays, isCompletedToday: isCompletedToday)
        
        cell.onComplete = { [weak self] tracker, isCompleted in
            self?.completeTracker(tracker, isCompleted: isCompleted)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
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

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
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
}
