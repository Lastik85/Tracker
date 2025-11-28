import UIKit

final class CreateNewEventViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: AddNewTrackerDelegate?
    
    private let cellName: [String] = ["Категория"]
    private var selectedCategory: String?
    private var trackerName: String = ""
    
    // MARK: - UI Elements
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.addTarget(self, action: #selector(tapCancell), for: .touchUpInside)
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
        textField.placeholder = "Введите название события"
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
        tableView.backgroundColor = .ypBackgroundDay
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = 75
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = false
        tableView.register(SettingsTrackerTableViewCell.self, forCellReuseIdentifier: SettingsTrackerTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        addSubviews()
        setupConstraints()
        enableCreateButton()
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        navigationItem.title = "Новое нерегулярное событие"
        [stackTextField, buttonStackView, tableView].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        [stackTextField, buttonStackView, tableView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            stackTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stackTextField.heightAnchor.constraint(equalToConstant: 75),
            
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            buttonStackView.heightAnchor.constraint(equalToConstant: 60),
            
            tableView.leadingAnchor.constraint(equalTo: stackTextField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: stackTextField.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: stackTextField.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func setSelectedCategory(_ category: String) {
        selectedCategory = category
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        enableCreateButton()
    }
    
    private func enableCreateButton() {
        guard let text = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty,
              text.count <= 38,
              let category = selectedCategory,
              !category.isEmpty else {
            createButton.isEnabled = false
            createButton.backgroundColor = .ypGray
            return
        }
        createButton.isEnabled = true
        createButton.backgroundColor = .ypBlackDay
    }
    
    // MARK: - Actions
    
    @objc private func tapCancell() {
        dismiss(animated: true)
    }
    
    @objc private func tapCreate() {
        print("создали нерегулярное событие")
        dismiss(animated: true)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        trackerName = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        enableCreateButton()
    }
}

// MARK: - UITableViewDataSource

extension CreateNewEventViewController: UITableViewDataSource {
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
        let subtitle: String? = selectedCategory
        
        cell.configure(with: title, subtitle: subtitle)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CreateNewEventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let categoryVC = CategoryViewController()
            categoryVC.delegate = self
            categoryVC.selectedCategory = selectedCategory
            navigationController?.pushViewController(categoryVC, animated: true)
        default:
            break
        }
    }
}

// MARK: - UITextFieldDelegate

extension CreateNewEventViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if newText.count > 38 {
            cautionLabel.isHidden = false
            return false
        } else {
            cautionLabel.isHidden = true
            return true
        }
    }
}

// MARK: - CategoryViewControllerDelegate

extension CreateNewEventViewController: CategoryViewControllerDelegate {
    func didSelectCategory(_ category: String) {
        setSelectedCategory(category)
    }
}
