import UIKit

final class CategoryListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: CategoryViewModel
    var selectedCategory: String?
    weak var delegate: CategoryListViewControllerDelegate?
    
    // MARK: - UI Elements
    
    private lazy var emptyCategoryImage: UIImageView = {
        let image = UIImage(resource: .star)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var emptyCategoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = """
        Привычки и события можно
        объединить по смыслу
        """
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var emptyCategoryStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emptyCategoryImage, emptyCategoryLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .singleLine
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
    
    // MARK: - Initialization
    
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        addSubviews()
        setupConstraints()
        setupNavigationTitle("Категория")
        navigationItem.hidesBackButton = true
        bindViewModel()
        loadCategories()
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        [emptyCategoryStackView,tableView, createButton].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        [emptyCategoryStackView,tableView, createButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: createButton.topAnchor, constant: -16),
            
            emptyCategoryImage.heightAnchor.constraint(equalToConstant: 80),
            emptyCategoryImage.widthAnchor.constraint(equalToConstant: 80),
            emptyCategoryStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyCategoryStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func bindViewModel(){
        viewModel.categoriesBinding = { [weak self] categories in
            guard let self else { return }
            self.checkEmptyCategory()
            self.tableView.reloadData()
        }
    }
    
    private func loadCategories() {
        viewModel.fetchCategories()
    }
    
    private func checkEmptyCategory() {
        let categoryIsEmpty = viewModel.categories.isEmpty
        emptyCategoryStackView.isHidden = !categoryIsEmpty
        tableView.isHidden = categoryIsEmpty
    }
    
    // MARK: - Actions
    
    @objc private func tapCreateButton() {
        let createCategory = CreateNewCategoryViewController()
        createCategory.delegate = self
        navigationController?.pushViewController(createCategory, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension CategoryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        let category = viewModel.categoryTitle(at: indexPath.row)
        let isSelected = selectedCategory == category
        
        cell.configure(with: category, isSelected: isSelected)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryTitle = viewModel.categoryTitle(at: indexPath.row)
        
        selectedCategory = selectedCategory == categoryTitle ? nil : categoryTitle
        delegate?.didSelectCategory(categoryTitle)
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}

extension CategoryListViewController: CreateNewCategoryViewControllerDelegate {
    
    func didCreateCategory() {
        viewModel.fetchCategories()
    }
}
