import UIKit

final class EmojiCell: UICollectionViewCell {
    
    static let reuseIdentifier = "EmojiCell"
    
    // MARK: - UI Elements
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emojiBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupViews(){
        contentView.addSubview(emojiBackgroundView)
        emojiBackgroundView.addSubview(emojiLabel)
    }
    
    private func setupConstraints(){
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiBackgroundView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: 52),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: 52),
            
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor)
        ])
    }
    
    // MARK: - Configuration Methods
    func emojiConfigure(with emoji: String){
        emojiLabel.text = emoji
    }

    func selectEmoji(){
        UIView.animate(withDuration: 0.2) {
            self.emojiBackgroundView.layer.cornerRadius = 16
            self.emojiBackgroundView.backgroundColor = .ypLightGray
            self.emojiBackgroundView.layer.borderColor = UIColor.clear.cgColor
        }
    }

    func deselectEmoji(){
        UIView.animate(withDuration: 0.2) {
            self.emojiBackgroundView.layer.cornerRadius = 8
            self.emojiBackgroundView.backgroundColor = .clear
            self.emojiBackgroundView.layer.borderColor = UIColor.ypGray.cgColor
        }
    }
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        emojiLabel.text = nil
        deselectEmoji()
    }
    

}
