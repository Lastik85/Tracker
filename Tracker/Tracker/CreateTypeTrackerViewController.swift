//
//  CreateTypeTrackerViewController.swift
//  Tracker
//
//  Created by Андрей Пермяков on 18.11.2025.
//
import UIKit

final class CreateTypeTrackerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        navSetup()
    }
    
    private lazy var habbitButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .ypBlackDay
        button.setTitle("Привычка", for: .normal)
        button.layer.cornerRadius = 16
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(didTapHabbitButton), for: .touchUpInside)
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
        let stackView = UIStackView(arrangedSubviews: [habbitButton, anIrregularEventButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habbitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func navSetup() {
        navigationItem.title = "Создать трекер"
    }
    
    private func setupViews() {
        view.addSubview(stackView)
    }
    
    @objc func didTapHabbitButton() {
        let createNewHabbitVC = CreateNewHabbitViewController()
        let newNavController = UINavigationController(rootViewController: createNewHabbitVC)
        navigationController?.present(newNavController, animated: true)
    }
    
    @objc func didTapAnIrregularEventButton() {
        let createNewEventVC = CreateNewEventViewController()
        let newNavController = UINavigationController(rootViewController: createNewEventVC)
        navigationController?.present(newNavController, animated: true)
        
    }
    
}

