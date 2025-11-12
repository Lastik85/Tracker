import UIKit

final class StatisticViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private lazy var emptyStatisticLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var emptyStatisticImage: UIImageView = {
        let image = UIImage(resource: .emptyStats)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var emptyStatisticStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emptyStatisticImage, emptyStatisticLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private func setupViews(){
        view.addSubview(emptyStatisticStackView)
    }
    
    private func setupConstraints() {
        emptyStatisticImage.translatesAutoresizingMaskIntoConstraints = false
        emptyStatisticStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStatisticImage.heightAnchor.constraint(equalToConstant: 80),
            emptyStatisticImage.widthAnchor.constraint(equalToConstant: 80),
            emptyStatisticStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStatisticStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
}
