import UIKit

final class OnboardingPageController: UIPageViewController {
    
    var onFinish: (() -> Void)?

    private lazy var pages: [UIViewController] = {
        OnboardingPage.allCases.map { page in
            let controller = OnboardingViewController(page: page)
            controller.onButtonTap = { [weak self] in
                self?.onFinish?()
            }

            return controller
        }
    }()

    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = pages.count
        control.currentPage = 0
        control.currentPageIndicatorTintColor = .ypBlackDay
        control.pageIndicatorTintColor = UIColor.ypBlackDay.withAlphaComponent(0.3)
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        addSubviews()
        setupConstraints()

    }
    
    private func addSubviews() {
        view.addSubview(pageControl)
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: false)
            pageControl.currentPage = 0
        }
        view.bringSubviewToFront(pageControl)
    }

    private func setupConstraints() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134)
        ])
    }
}

extension OnboardingPageController: UIPageViewControllerDataSource {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        return previousIndex >= 0 ? pages[previousIndex] : pages.last
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        return nextIndex < pages.count ? pages[nextIndex] : pages.first
    }
}

extension OnboardingPageController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool ) {
        guard let current = viewControllers?.first,
            let index = pages.firstIndex(of: current)
        else { return }

        pageControl.currentPage = index
    }
}
