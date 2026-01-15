import UIKit

final class FiltersCell: UITableViewCell {
    
    static let reuseIdentifier = "FiltersCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlackDay
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
          view.backgroundColor = .ypGray
        view.isHidden = true
          return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with filter: FilterList, isSelected: Bool, showSeparator: Bool) {
        titleLabel.text = filter.title
        separatorView.isHidden = !showSeparator
        
        if isSelected && filter.shouldShowCheckmark {
            accessoryType = .checkmark
            tintColor = .ypBlue
        } else {
            accessoryType = .none
        }
    }
    
    
    private func setupCell() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(separatorView)
        backgroundColor = .ypBackgroundDay
        selectionStyle = .none

    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        separatorView.isHidden = true
        titleLabel.text = nil
        accessoryType = .none
    }

}
