//
//  ViewController.swift
//  Tracker
//
//  Created by Андрей Пермяков on 18.11.2025.
//
import UIKit

final class TrackerViewController: UIViewController, UISearchControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        setupNavigationBar()
        
    }
    
    private lazy var emptyTrackerImage: UIImageView = {
        let image = UIImage(resource: .star)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var emptyTrackerLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emptyTrackerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emptyTrackerImage, emptyTrackerLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        return datePicker
    }()
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(resource: .plus), style: .plain, target: self, action: #selector(didTapPlusButton))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setupConstraints(){
        emptyTrackerImage.translatesAutoresizingMaskIntoConstraints = false
        emptyTrackerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyTrackerImage.heightAnchor.constraint(equalToConstant: 80),
            emptyTrackerImage.widthAnchor.constraint(equalToConstant: 80),
            emptyTrackerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyTrackerStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            datePicker.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupViews(){
        view.addSubview(emptyTrackerStackView)
    }
    
    @objc private func didTapPlusButton(){
        let createTypeControllerVC = CreateTypeTrackerViewController()
        let newNavigationController = UINavigationController(rootViewController: createTypeControllerVC)
        navigationController?.present(newNavigationController, animated: true)
    }
}


