//
//  Untitled.swift
//  Tracker
//
//  Created by Андрей Пермяков on 18.11.2025.
//
import UIKit

final class CreateNewHabbitViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        addSubviews()
        setupConstraints()
    }
    
    private let cellName:[String] = ["Категория","Расписание"]
    private var selectedCategory: String? {
        didSet {
            updateCategoryCell()
        }
    }
    
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
    
    private func addSubviews(){
        navigationItem.title = "Новая Привычка"
        [stackTextField,buttonStackView,tableView].forEach {view.addSubview($0)}
    }
    
    private func setupConstraints(){
        stackTextField.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
            tableView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    @objc private func tapCancell(){
        if presentingViewController != nil {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func updateCategoryCell() {
        if let categoryCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
            categoryCell.detailTextLabel?.text = selectedCategory
        }
    }
}

extension CreateNewHabbitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "NewTracker")
        cell.backgroundColor = .ypBackgroundDay
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = 75
        cell.textLabel?.text = cellName[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        cell.detailTextLabel?.textColor = .ypGray
        if indexPath.row == 0 {
            cell.detailTextLabel?.text = selectedCategory
        } else {
            cell.detailTextLabel?.text = nil
        }
        return cell
    }
    
}

extension CreateNewHabbitViewController: UITableViewDelegate {
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
            navigationController?.pushViewController(scheduleVC, animated: true)
        default:
            break
        }
    }
}

extension CreateNewHabbitViewController: UITextFieldDelegate {
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

extension CreateNewHabbitViewController: CategoryViewControllerDelegate {
    func didSelectCategory(_ category: String) {
        selectedCategory = category
    }
}

