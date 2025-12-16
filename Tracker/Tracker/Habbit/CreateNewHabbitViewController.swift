import UIKit

final class CreateNewHabitViewController: UIViewController {
        
    // MARK: - Properties
    private let trackerService = TrackerService.shared
    private let cellName: [String] = ["Категория", "Расписание"]
    private var emojis: [String] { Constants.emojis }
    private var colors: [UIColor] { Constants.colors }
    private var selectedCategory: String?
    private var selectedSchedule: Set<Week> = []
    private var trackerName: String = ""
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    
    
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
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
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
        enableCreateButton()
    }
    
    // MARK: - Private Methods
    private func addSubviews() {
        navigationItem.title = "Новая Привычка"
        view.addSubview(buttonStackView)
        [stackTextField, tableView, collectionView].forEach { contentView.addSubview($0) }
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
    }
    private func setupConstraints() {
        [buttonStackView, scrollView, contentView, stackTextField, tableView, collectionView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
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
            
            stackTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
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
            let categoryVC = CategoryViewController()
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
extension CreateNewHabitViewController: CategoryViewControllerDelegate {
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
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return emojis.count
        case 1:
            return colors.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "EmojiCell",
                for: indexPath
            ) as? EmojiCell else {
                return UICollectionViewCell()
            }
            
            let emoji = emojis[indexPath.item]
            cell.emojiConfigure(with: emoji)
            
            if let selectedEmoji = selectedEmoji, emoji == selectedEmoji {
                cell.selectEmoji()
            } else {
                cell.deselectEmoji()
            }
            
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ColorCell",
                for: indexPath
            ) as? ColorCell else {
                return UICollectionViewCell()
            }
            let color = colors[indexPath.item]
            cell.configureColor(with: color)
            
            if let selectedColor = selectedColor, color == selectedColor {
                cell.selectedColor(with: color)
            } else {
                cell.deselectedColor()
            }
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "StringEmojiColorHeader",
            for: indexPath
        ) as? EmojiColorHeader else {
            return UICollectionReusableView()
        }
        let title = indexPath.section == 0 ? "Emoji" : "Цвет"
        header.configureHeader(with: title)
        
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
        switch indexPath.section {
        case 0:
            let emoji = emojis[indexPath.item]
            if selectedEmoji == emoji {
                selectedEmoji = nil
            } else {
                selectedEmoji = emoji
            }
            UIView.performWithoutAnimation {
                collectionView.reloadSections(IndexSet(integer: indexPath.section))
            }
        case 1:
            let color = colors[indexPath.item]
            if selectedColor == color {
                selectedColor = nil
            } else {
                selectedColor = color
            }
            UIView.performWithoutAnimation {
                collectionView.reloadSections(IndexSet(integer: indexPath.section))
            }
        default:
            break
        }
        enableCreateButton()
    }
}
