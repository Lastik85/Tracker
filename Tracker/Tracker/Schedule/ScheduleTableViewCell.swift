import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "ScheduleTableViewCell"
    
    // MARK: - Public Properties
    
    var onSwitchChanged: ((Bool) -> Void)?
    
    // MARK: - UI Elements
    
    private lazy var dayNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlackDay
        return label
    }()
    
    private lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = .ypBlue
        switchControl.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return switchControl
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with dayName: String, isSelected: Bool) {
        dayNameLabel.text = dayName
        switchControl.isOn = isSelected
    }
    
    // MARK: - Private Methods
    
    private func setupCell() {
        [dayNameLabel, switchControl].forEach { contentView.addSubview($0) }
        contentView.backgroundColor = .ypBackgroundDay
        selectionStyle = .none
    }
    
    private func setupConstraints() {
        [dayNameLabel, switchControl].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            dayNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        onSwitchChanged?(sender.isOn)
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onSwitchChanged = nil
    }
}
