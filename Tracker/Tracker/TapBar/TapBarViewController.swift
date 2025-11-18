//
//  Untitled.swift
//  Tracker
//
//  Created by Андрей Пермяков on 18.11.2025.
//
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
            image: UIImage(resource: .trackers),
            selectedImage: nil
        )
        
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(resource: .rabbit),
            selectedImage: nil
        )
        let navigationTracker = UINavigationController(rootViewController: trackerViewController)
        trackerViewController.title = "Трекеры"
        navigationTracker.navigationBar.prefersLargeTitles = true
        let navigationStatistics = UINavigationController(rootViewController: statisticViewController)
        statisticViewController.title = "Статистика"
        navigationStatistics.navigationBar.prefersLargeTitles = true
        viewControllers = [navigationTracker, navigationStatistics]
    }
    
    
}
