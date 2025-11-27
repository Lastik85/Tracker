import UIKit

final class TrackerCell: UICollectionViewCell {

    static let reuseIdentifier = "TrackerCell"

    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var emojiBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.3)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()

    private lazy var daysCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
        return label
    }()

    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [daysCountLabel, completeButton])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 16, right: 12)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = .white
        return stackView
    }()

    private var tracker: Tracker?
    private var completedDays: Int = 0
    private var isCompletedToday: Bool = false

    var onComplete: ((Tracker, Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(cardView)
        contentView.addSubview(bottomStackView)
        cardView.addSubview(emojiBackground)
        emojiBackground.addSubview(emojiLabel)
        cardView.addSubview(titleLabel)
    }

    private func setupConstraints() {
        [cardView, bottomStackView, emojiBackground, emojiLabel, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),

            bottomStackView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            bottomStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            emojiBackground.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiBackground.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiBackground.widthAnchor.constraint(equalToConstant: 24),
            emojiBackground.heightAnchor.constraint(equalToConstant: 24),

            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackground.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackground.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
    }

    @objc private func completeButtonTapped() {
        guard let tracker = tracker else { return }

        isCompletedToday.toggle()
        updateCompleteButton()

        onComplete?(tracker, isCompletedToday)
    }

    func configure(with tracker: Tracker, completedDays: Int, isCompletedToday: Bool) {
        self.tracker = tracker
        self.completedDays = completedDays
        self.isCompletedToday = isCompletedToday

        cardView.backgroundColor = tracker.color
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.name
        daysCountLabel.text = getDayString(completedDays)

        updateCompleteButton()
    }

        private func updateCompleteButton() {
            let imageName = isCompletedToday ? UIImage(resource: .done) : UIImage(resource: .plus)
            let buttonAlpha: CGFloat = isCompletedToday ? 0.3 : 1.0
    
            completeButton.setImage(imageName, for: .normal)
            completeButton.alpha = buttonAlpha
        }

    private func getDayString(_ value: Int) -> String {
        let mod10 = value % 10
        let mod100 = value % 100

        switch (mod100, mod10) {
        case (11...14, _):
            return "\(value) дней"
        case (_, 1):
            return "\(value) день"
        case (_, 2...4):
            return "\(value) дня"
        default:
            return "\(value) дней"
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        tracker = nil
        isCompletedToday = false
        completedDays = 0
        onComplete = nil
    }
}
