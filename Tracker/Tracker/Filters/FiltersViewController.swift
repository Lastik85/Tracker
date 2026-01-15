import UIKit

final class FiltersViewController: UIViewController {
    
    weak var delegate: FiltersViewControllerDelegate?
    private let filters = FilterList.allCases
    var selectedFilter: FilterList = .all
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register( FiltersCell.self, forCellReuseIdentifier: FiltersCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        setupNavigationTitle("Фильтры")
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        [tableView].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        [tableView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
}
extension FiltersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }
    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FiltersCell.reuseIdentifier, for: indexPath) as? FiltersCell else {
            return UITableViewCell()
        }
        let filter = filters[indexPath.row]
        let isSelected = filter == selectedFilter && filter.shouldShowCheckmark
        let isLast = indexPath.row == filters.count - 1
        
        cell.configure(with: filter, isSelected: isSelected, showSeparator: !isLast)
        return cell
    }
    
}



extension FiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = filters[indexPath.row]
        selectedFilter = filter
        tableView.reloadData()
        delegate?.filtersViewController(self, didSelectFilter: filter)
        dismiss(animated: true)
    }
}


