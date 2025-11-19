//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Андрей Пермяков on 19.11.2025.
//
import UIKit

final class ScheduleViewController: UIViewController {
    
    private let week: [Week] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        navigationItem.hidesBackButton = true
        addSubviews()
        setupConstraints()
        
    }
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlackDay
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .ypWhiteDay
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private func addSubviews(){
        navigationItem.title = "Расписание"
        [tableView, doneButton].forEach {view.addSubview($0)}
    }
    
    private func setupConstraints(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * week.count)),
            
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            view.trailingAnchor.constraint(equalTo: doneButton.trailingAnchor, constant: 20),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 16),
            doneButton.topAnchor.constraint(greaterThanOrEqualTo: tableView.bottomAnchor, constant: 24)
        ])
        
    }
    
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return week.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    
}
