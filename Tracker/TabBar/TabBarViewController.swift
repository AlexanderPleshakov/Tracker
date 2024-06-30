//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 04.05.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: Methods
    
    private func configure() {
        view.backgroundColor = Resources.Colors.background
        tabBar.backgroundColor = Resources.Colors.background
        tabBar.isTranslucent = false
        tabBar.addTopBorder(color: UIColor.black.withAlphaComponent(0.3), thickness: 0.5)
        
        addTabs()
    }
    
    private func addTabs() {
        let trackers = TrackersViewController()
        let trackersNav = TrackersNavigationController(rootViewController: trackers)
        trackersNav.tabBarItem = UITabBarItem(
            title: NSLocalizedString("trackers", comment: "Trackers tab"),
            image: Resources.Images.tracksTab,
            selectedImage: nil
        )
        
        let statistic = StatisticViewController()
        let statisticNav = UINavigationController(rootViewController: statistic)
        statisticNav.tabBarItem = UITabBarItem(
            title: NSLocalizedString("statistic", comment: "Trackers tab"),
            image: Resources.Images.statisticTab,
            selectedImage: nil
        )
        
        self.viewControllers  = [trackersNav, statisticNav]
    }
}
