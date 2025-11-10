import UIKit

final class TapBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad( )
        setupViewControllers()
    }
    private func setupViewControllers() {
        
        
        let trackerViewController = TrackerViewController()
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(resource: .tracker),
            selectedImage: nil
        )
        
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(resource: .rabbit),
            selectedImage: nil
        )
        let navigationTracker = UINavigationController(rootViewController: trackerViewController)
        let navigationStatistics = UINavigationController(rootViewController: statisticViewController)
        viewControllers = [navigationTracker, navigationStatistics]
    }
    
    
}
