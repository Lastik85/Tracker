import UIKit

final class CreateTypeTrackerViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: AddNewTrackerDelegate?
    
    // MARK: - UI Elements
    
    private lazy var habitButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .ypBlackDay
        button.setTitle("Привычка", for: .normal)
        button.layer.cornerRadius = 16
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(didTapHabitButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var anIrregularEventButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .ypBlackDay
        button.setTitle("Нерегулярное событие", for: .normal)
        button.layer.cornerRadius = 16
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(didTapAnIrregularEventButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [habitButton, anIrregularEventButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Создать трекер"
        view.addSubview(stackView)
        setupConstraints()
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    
    @objc func didTapHabitButton() {
        let createNewHabitVC = CreateNewHabitViewController()
        createNewHabitVC.delegate = delegate
        navigationController?.pushViewController(createNewHabitVC, animated: true)
    }
    
    @objc func didTapAnIrregularEventButton() {
        let createNewEventVC = CreateNewEventViewController()
        createNewEventVC.delegate = delegate
        navigationController?.pushViewController(createNewEventVC, animated: true)
    }
}
