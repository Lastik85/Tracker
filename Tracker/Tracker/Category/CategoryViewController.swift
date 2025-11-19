//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Андрей Пермяков on 18.11.2025.
//
import UIKit

final class CategoryViewController: UIViewController {
    
    private let nameCategory = ["Важное"]
    var selectedCategory: String?
    weak var delegate: CategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        addSubviews()
        setupConstraints()
        navigationItem.hidesBackButton = true
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.backgroundColor = .ypBlackDay
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(tapCreateButton), for: .touchUpInside)
        return button
    }()
    
    private func addSubviews(){
        navigationItem.title = "Категория"
        [tableView, createButton].forEach {view.addSubview($0)}
    }
    
    private func setupConstraints(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 75),
            
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func tapCreateButton(){
        if let selectedCategory = selectedCategory {
            delegate?.didSelectCategory(selectedCategory)
            navigationController?.popViewController(animated: true)
        } else {
            print("категория не выбрана")
        }
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "NewTracker")
        cell.backgroundColor = .ypBackgroundDay
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = 75
        cell.textLabel?.text = nameCategory[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.accessoryType = selectedCategory == nameCategory[indexPath.row] ? .checkmark : .none
        
        return cell
    }
    
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryTitle = nameCategory[indexPath.row]
        
        if selectedCategory == categoryTitle {
            selectedCategory = nil
        } else {
            selectedCategory = categoryTitle
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

