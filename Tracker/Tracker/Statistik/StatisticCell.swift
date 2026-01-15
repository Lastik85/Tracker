import UIKit

final class StatisticCell: UITableViewCell {

    static let reuseIdentifier = "StatisticCell"

    // MARK: - UI
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhiteDay
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlackDay
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
        return label
    }()

    // MARK: - Gradient

    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.colorSelection1.cgColor,
            UIColor.colorSelection9.cgColor,
            UIColor.colorSelection3.cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        return layer
    }()

    private lazy var borderMask: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 1
        layer.strokeColor = UIColor.black.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = contentView.bounds

        borderMask.path = UIBezierPath(
            roundedRect: contentView.bounds.insetBy(dx: 0.5, dy: 0.5),
            cornerRadius: 16
        ).cgPath
    }

    // MARK: - Public
    func configureCell(completedDays: Int, description: String) {
        dayLabel.text = "\(completedDays)"
        descriptionLabel.text = description
    }

    // MARK: - Setup
    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(containerView)
        containerView.addSubview(dayLabel)
        containerView.addSubview(descriptionLabel)

        gradientLayer.mask = borderMask
        contentView.layer.insertSublayer(gradientLayer, at: 0)

        [containerView, dayLabel, descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),

            dayLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            dayLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),

            descriptionLabel.leadingAnchor.constraint(equalTo: dayLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 7),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -12)
        ])
    }
}

