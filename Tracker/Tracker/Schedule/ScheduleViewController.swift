import UIKit

final class ScheduleViewController: UIViewController {
    
    private let week: [Week] = Week.allCases
    var selectedDays: Set<Week> = []
    weak var delegate: ScheduleViewControllerDelegate?
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlackDay
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .ypBackgroundDay
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.rowHeight = 75
        tableView.separatorStyle = .none
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        navigationItem.hidesBackButton = true
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews(){
        navigationItem.title = "Расписание"
        [tableView, doneButton].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16), 
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
    private func toggleDay(_ day: Week) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
    }
    
    private func isDaySelected(_ day: Week) -> Bool {
        return selectedDays.contains(day)
    }
    
    @objc private func doneButtonTapped() {
        delegate?.didSelectSchedule(selectedDays)
        navigationController?.popViewController(animated: true)
    }
    
    
    private func addSeparator(to cell: UITableViewCell) {
        let separator = UIView()
        separator.backgroundColor = .ypGray
        cell.contentView.addSubview(separator)
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            separator.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return week.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.reuseIdentifier, for: indexPath) as? ScheduleTableViewCell else {
            return UITableViewCell()
        }
        
        let day = week[indexPath.row]
        let isSelected = isDaySelected(day)
        
        cell.configure(with: day.rawValue, isSelected: isSelected)
        
        cell.onSwitchChanged = { [weak self] isOn in
            self?.toggleDay(day)
        }
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
         if indexPath.row < week.count - 1 {
             addSeparator(to: cell)
         }
        
        return cell
    }
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
