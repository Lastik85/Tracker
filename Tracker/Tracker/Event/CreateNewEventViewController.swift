//
//  CreateNewEventViewController.swift
//  Tracker
//
//  Created by Андрей Пермяков on 18.11.2025.
//
import UIKit

final class CreateNewEventViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        navTitle()
        addSubviews()
        setupConstraint()
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
        button.addTarget(self, action: #selector(tapCreate), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Задание со звездочкой, позже сделаю"
        return label
    }()
    
    private func addSubviews(){
        view.addSubview(stackView)
        view.addSubview(emptyLabel)
    }
    
    private func setupConstraint(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -34),
            stackView.heightAnchor.constraint(equalToConstant: 60),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func navTitle(){
        navigationItem.title = "Новое нерегулярное событие"
    }
    
    @objc private func tapCancell(){
         if presentingViewController != nil {
             dismiss(animated: true)
         } else {
             navigationController?.popViewController(animated: true)
         }
    }
    
    @objc private func tapCreate(){
         if presentingViewController != nil {
             dismiss(animated: true)
         } else {
             navigationController?.popViewController(animated: true)
         }
    }
}

