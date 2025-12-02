import UIKit

final class EmojiColorHeader: UICollectionReusableView {
    
    // MARK: - Properties
    static let reuseIdentifier = "EmojiColorHeader"
    
    // MARK: - UI Elements
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupConstraints() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28)
        ])
    }
    
    // MARK: - Configuration Methods
    func configureHeader(with text: String) {
        headerLabel.text = text
    }
}
