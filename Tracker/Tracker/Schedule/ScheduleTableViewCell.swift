import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    

    var onSwitchChanged: ((Bool) -> Void)?
    static let reuseIdentifier = "ScheduleTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func configure(with dayName: String, isSelected: Bool) {
        dayNameLabel.text = dayName
        switchControl.isOn = isSelected
    }
    
    private func setupCell() {
        contentView.addSubview(dayNameLabel)
        contentView.addSubview(switchControl)
        contentView.backgroundColor = .ypBackgroundDay
        selectionStyle = .none
    }
    
    private func setupConstraints() {
        dayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        onSwitchChanged?(sender.isOn)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onSwitchChanged = nil
    }
}
