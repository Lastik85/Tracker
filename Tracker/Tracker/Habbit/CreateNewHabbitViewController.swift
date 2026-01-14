import UIKit

final class CreateNewHabitViewController: UIViewController {
    
    // MARK: - Properties
    private let mode: HabitEditorMode
    private let trackerService = TrackerService.shared
    private let cellName: [String] = ["Категория", "Расписание"]
    private var selectedCategory: String?
    private var selectedSchedule: Set<Week> = []
    private var trackerName: String = ""
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    private var stackTextFieldCreate :NSLayoutConstraint?
    private var stackTextFieldEdit :NSLayoutConstraint?
    
    init(mode: HabitEditorMode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(tapCreate), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.textColor = .ypBlackDay
        textField.backgroundColor = UIColor(resource: .ypBackgroundDay)
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var cautionLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textColor = .ypRed
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var stackTextField: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameTextField, cautionLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = 75
        tableView.isScrollEnabled = false
        tableView.register(SettingsTrackerTableViewCell.self, forCellReuseIdentifier: SettingsTrackerTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var daysCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.textColor = .ypBlackDay
        label.isHidden = true
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "EmojiCell")
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
        collectionView.register(EmojiColorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "StringEmojiColorHeader")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = .ypWhiteDay
        scrollView.delaysContentTouches = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        return UIView()
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .ypWhiteDay
        navigationItem.hidesBackButton = true
        addSubviews()
        setupConstraints()
        configureForMode()
        enableCreateButton()
    }
    
    private func configureForMode() {
        switch mode {
        case .create:
            setupNavigationTitle("Новая привычка")            
            createButton.setTitle("Создать", for: .normal)
            
        case .edit(let tracker, let category):
            setupNavigationTitle("Редактирование привычки")
            createButton.setTitle("Сохранить", for: .normal)
            stackTextFieldCreate?.isActive = false
            stackTextFieldEdit?.isActive = true
            
            let days = trackerService.getCompletedDaysCount(for: tracker)
            daysCountLabel.text = String.localizedStringWithFormat(NSLocalizedString("numberOfDays", comment: "Text for number of days"), days)
            daysCountLabel.isHidden = false
            trackerName = tracker.name
            selectedCategory = category
            selectedSchedule = tracker.schedule
            selectedEmoji = tracker.emoji
            selectedColor = tracker.color
            
            nameTextField.text = tracker.name
            tableView.reloadData()
            
            collectionView.reloadSections(IndexSet([
                EmojiColorCollectionSection.emoji.rawValue,
                EmojiColorCollectionSection.color.rawValue
            ]))
        }
    }
    
    
    
    // MARK: - Private Methods
    private func addSubviews() {
        view.addSubview(buttonStackView)
        view.addSubview(scrollView)
        [daysCountLabel, stackTextField, tableView, collectionView].forEach { contentView.addSubview($0) }
        scrollView.addSubview(contentView)
    }
    private func setupConstraints() {
        [daysCountLabel, buttonStackView, scrollView, contentView, stackTextField, tableView, collectionView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            buttonStackView.heightAnchor.constraint(equalToConstant: 60),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -16),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            daysCountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            daysCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            daysCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stackTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackTextField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: stackTextField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: stackTextField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: stackTextField.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 460),
            
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: collectionView.bottomAnchor, constant: 16)
        ])
        stackTextFieldCreate = stackTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24)
        stackTextFieldEdit = stackTextField.topAnchor.constraint(equalTo: daysCountLabel.bottomAnchor, constant: 40)
        stackTextFieldCreate?.isActive = true
        stackTextFieldEdit?.isActive = false
    }
    
    private func setSelectedCategory(_ category: String) {
        selectedCategory = category
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        enableCreateButton()
    }
    
    private func setSelectedSchedule(_ schedule: Set<Week>) {
        selectedSchedule = schedule
        let indexPath = IndexPath(row: 1, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        enableCreateButton()
    }
    
    private func formatScheduleText() -> String {
        guard !selectedSchedule.isEmpty else { return "" }
        let sortedDays = selectedSchedule.sorted()
        if sortedDays.count == 7 {
            return "Каждый день"
        }
        return sortedDays.map { $0.shortName }.joined(separator: ", ")
    }
    
    private func enableCreateButton() {
        guard let text = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty,
              text.count <= Constants.maxNameLength,
              let category = selectedCategory,
              !category.isEmpty,
              !selectedSchedule.isEmpty,
              selectedEmoji != nil,
              selectedColor != nil
        else {
            createButton.isEnabled = false
            createButton.backgroundColor = .ypGray
            return
        }
        createButton.isEnabled = true
        createButton.backgroundColor = .ypBlackDay
    }
    
    // MARK: - Actions
    @objc private func tapCancel() {
        if presentingViewController != nil {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func tapCreate() {
        switch mode {
        case .create:
            createTracker()
            
        case .edit(let oldTracker, let oldCategory):
            updateTracker(oldTracker, oldCategory: oldCategory)
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    private func createTracker () {
        guard let category = selectedCategory,
              !trackerName.isEmpty,
              !selectedSchedule.isEmpty,
              let emoji = selectedEmoji,
              let color = selectedColor
        else { return }
        let newTracker = Tracker(
            id: UUID(),
            name: trackerName,
            color: color,
            emoji: emoji,
            schedule: selectedSchedule
        )
        
        trackerService.createTracker(newTracker, inCategory: category)
        dismiss(animated: true)
    }
    
    private func updateTracker (_ oldTracker: Tracker, oldCategory: String) {
        guard let category = selectedCategory,
              !trackerName.isEmpty,
              !selectedSchedule.isEmpty,
              let emoji = selectedEmoji,
              let color = selectedColor
        else { return }
        let updateTracker = Tracker(
            id: oldTracker.id,
            name: trackerName,
            color: color,
            emoji: emoji,
            schedule: selectedSchedule
        )
        
        trackerService.updateTracker(updateTracker, oldCategory: oldCategory, newCategory: category)
        dismiss(animated: true)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        trackerName = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        cautionLabel.isHidden = trackerName.count <= Constants.maxNameLength
        enableCreateButton()
    }
    
}

// MARK: - UITableViewDataSource
extension CreateNewHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsTrackerTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? SettingsTrackerTableViewCell else {
            return UITableViewCell()
        }
        
        let title = cellName[indexPath.row]
        let subtitle: String?
        
        if indexPath.row == 0 {
            subtitle = selectedCategory
        } else if indexPath.row == 1 {
            subtitle = formatScheduleText()
        } else {
            subtitle = nil
        }
        if indexPath.row == cellName.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        
        cell.configure(with: title, subtitle: subtitle)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CreateNewHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let viewModel = CategoryViewModel()
            let categoryVC = CategoryListViewController(viewModel: viewModel)
            categoryVC.delegate = self
            categoryVC.selectedCategory = selectedCategory
            navigationController?.pushViewController(categoryVC, animated: true)
        case 1:
            let scheduleVC = ScheduleViewController()
            scheduleVC.delegate = self
            scheduleVC.selectedDays = selectedSchedule
            navigationController?.pushViewController(scheduleVC, animated: true)
        default:
            break
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension CreateNewHabitViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        cautionLabel.isHidden = newText.count <= Constants.maxNameLength
        return newText.count <= Constants.maxNameLength
    }
}

// MARK: - CategoryViewControllerDelegate
extension CreateNewHabitViewController: CategoryListViewControllerDelegate {
    func didSelectCategory(_ category: String) {
        setSelectedCategory(category)
    }
}

// MARK: - ScheduleViewControllerDelegate
extension CreateNewHabitViewController: ScheduleViewControllerDelegate {
    func didSelectSchedule(_ selectedDays: Set<Week>) {
        setSelectedSchedule(selectedDays)
    }
}
// MARK: - UICollectionViewDataSource
extension CreateNewHabitViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        EmojiColorCollectionSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        guard let section = EmojiColorCollectionSection(rawValue: section) else {
            return 0
        }
        return section.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let section = EmojiColorCollectionSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch section {
        case .emoji:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "EmojiCell",
                for: indexPath
            ) as! EmojiCell
            
            let emoji = Constants.emojis[indexPath.item]
            cell.emojiConfigure(with: emoji)
            selectedEmoji == emoji ? cell.selectEmoji() : cell.deselectEmoji()
            return cell
            
        case .color:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
            let color = Constants.colors[indexPath.item]
            cell.configureColor(with: color)
            if color.isEqualToColor(selectedColor ?? .clear) {
                cell.selectedColor(with: color)
            } else {
                cell.deselectedColor()
            }
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "StringEmojiColorHeader",
            for: indexPath
        ) as! EmojiColorHeader
        
        let section = EmojiColorCollectionSection(rawValue: indexPath.section)
        header.configureHeader(with: section?.title ?? "")
        return header
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension CreateNewHabitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 5
        let availableWidth = collectionView.bounds.width - 18 * 2 - spacing * 5
        let itemWidth = availableWidth / 6
        return CGSize(width: itemWidth, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
}

// MARK: - UICollectionViewDelegate
extension CreateNewHabitViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let section = EmojiColorCollectionSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .emoji:
            let emoji = Constants.emojis[indexPath.item]
            selectedEmoji = selectedEmoji == emoji ? nil : emoji
            
        case .color:
            let color = Constants.colors[indexPath.item]
            selectedColor = selectedColor?.isEqualToColor(color) == true ? nil : color
            
        }
        
        UIView.performWithoutAnimation {
            collectionView.reloadSections(IndexSet(integer: indexPath.section))
        }
        enableCreateButton()
    }
}

