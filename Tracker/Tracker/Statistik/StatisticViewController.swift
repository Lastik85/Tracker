import UIKit

final class StatisticViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        
    }
    
    private lazy var emptyStatImage: UIImageView = {
        let image = UIImage(resource: .emptyState)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var emptyStatLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
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
    
    private func addSubviews() {
        view.addSubview(emptyStatStackView)
    }
    
    private func setupConstraints() {
        emptyStatStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStatStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStatStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
