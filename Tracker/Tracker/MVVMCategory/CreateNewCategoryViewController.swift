import UIKit

final class CreateNewCategoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private let trackerService = TrackerService.shared
    weak var delegate: CreateNewCategoryViewControllerDelegate?
    
    // MARK: - UI Elements
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категории"
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
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(tapCreateButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationTitle("Новая категория")
        navigationItem.hidesBackButton = true
        addSubviews()
        enableCreateButton()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    
    private func addSubviews() {
        [nameTextField, createButton].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        [nameTextField, createButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Private Methods
    
    private func enableCreateButton() {
        guard let text = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty
        else {
            createButton.isEnabled = false
            createButton.backgroundColor = .ypGray
            return
        }
        createButton.isEnabled = true
        createButton.backgroundColor = .ypBlackDay
    }
    
    // MARK: - Actions
    
    @objc private func textFieldDidChange() {
        enableCreateButton()
    }
    
    @objc private func tapCreateButton() {
        guard let categoryTitle = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !categoryTitle.isEmpty
        else {
            return
        }
        
        let newCategory = TrackerCategory(title: categoryTitle, trackers: [])
        trackerService.addCategory(newCategory)
        delegate?.didCreateCategory()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension CreateNewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
