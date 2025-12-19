import UIKit

final class ColorCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "ColorCell"
    
    // MARK: - UI Elements
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var colorBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupViews() {
        [colorView, colorBackgroundView].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        [colorView, colorBackgroundView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            colorBackgroundView.heightAnchor.constraint(equalToConstant: 52),
            colorBackgroundView.widthAnchor.constraint(equalToConstant: 52),
            
            colorView.centerYAnchor.constraint(equalTo: colorBackgroundView.centerYAnchor),
            colorView.centerXAnchor.constraint(equalTo: colorBackgroundView.centerXAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Configuration Methods
    func configureColor(with color: UIColor) {
        colorView.backgroundColor = color
    }
    
    func selectedColor(with color: UIColor) {
        colorBackgroundView.layer.borderWidth = 3
        colorBackgroundView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
    }
    
    func deselectedColor() {
        colorBackgroundView.layer.borderWidth = 0
        colorBackgroundView.layer.borderColor = .none
    }
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        colorView.backgroundColor = nil
        deselectedColor()
    }
}
