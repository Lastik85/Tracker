import UIKit

final class StatisticViewController: UIViewController {
    
    // MARK: - Properties
    private var completedTrackersCount: Int {
        StatisticService.shared.completedTrackersCount()
    }
    
    private let trackerCompletedTitle = NSLocalizedString("CompletedTitle", comment: "Completed")
    
    // MARK: - UI Elements
    private lazy var emptyStatImage: UIImageView = {
        let image = UIImage(resource: .emptyState)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var emptyStatLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("StatisticEmpty", comment: "NoStat")
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emptyStatStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emptyStatImage, emptyStatLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(StatisticCell.self, forCellReuseIdentifier: StatisticCell.reuseIdentifier)
        tableView.rowHeight = 90
        return tableView
    } ()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateUI()
    }
    
    // MARK: - Private Methods
    private func addSubviews() {
        view.backgroundColor = .ypWhiteDay
        [tableView, emptyStatStackView].forEach {view.addSubview($0)}
    }
    
    private func setupConstraints() {
        emptyStatStackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 77),
            tableView.heightAnchor.constraint(equalToConstant: 90),
            
            emptyStatStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStatStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateUI() {
        if completedTrackersCount > 0 {
            tableView.isHidden = false
            emptyStatStackView.isHidden = true
        } else {
            tableView.isHidden = true
            emptyStatStackView.isHidden = false
        }
    }
}

// MARK: - UITableViewDataSource
extension StatisticViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticCell.reuseIdentifier, for: indexPath) as? StatisticCell else {
            return UITableViewCell()
        }

        let completedCount = StatisticService.shared.completedTrackersCount()
        cell.configureCell(completedDays: completedCount, description: trackerCompletedTitle)
        return cell
    }
}
