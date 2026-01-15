import UIKit

final class TapBarViewController: UITabBarController {
    
    let trackersTitle = NSLocalizedString("trackersTitle", comment: "Text displayed on tracker title")
    let statisticsTitle = NSLocalizedString("statisticsTitle", comment: "Text displayed on statistics title")
    
    override func viewDidLoad() {
        super.viewDidLoad( )
        setupViewControllers()
        setupTabBarAppearance()
    }
    
    private func setupViewControllers() {
        
        let trackerViewController = TrackerViewController()
        trackerViewController.tabBarItem = UITabBarItem(
            title: trackersTitle,
            image: UIImage(resource: .trackers),
            selectedImage: nil
        )
        
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(
            title: statisticsTitle,
            image: UIImage(resource: .rabbit),
            selectedImage: nil
        )
        let navigationTracker = UINavigationController(rootViewController: trackerViewController)
        trackerViewController.title = trackersTitle
        navigationTracker.navigationBar.prefersLargeTitles = true
        let navigationStatistics = UINavigationController(rootViewController: statisticViewController)
        statisticViewController.title = statisticsTitle
        navigationStatistics.navigationBar.prefersLargeTitles = true
        viewControllers = [navigationTracker, navigationStatistics]
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .ypWhiteDay
        appearance.shadowColor = .ypGray
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
}
