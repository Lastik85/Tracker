import UIKit

extension UIViewController {

    func setupNavigationTitle(_ title: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .ypBlackDay
        titleLabel.textAlignment = .center

        let containerView = UIView()
        containerView.addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        navigationItem.titleView = containerView
    }
}
