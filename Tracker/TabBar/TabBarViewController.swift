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
        view.backgroundColor = Resources.Colors.white
        tabBar.isTranslucent = false
        tabBar.addTopBorder(color: Resources.Colors.searchTextGray, thickness: 0.5)
        
        addTabs()
    }
    
    private func addTabs() {
        let trackers = TrackersViewController()
        let trackersNav = TrackersNavigationController(rootViewController: trackers)
        trackersNav.tabBarItem = UITabBarItem(
            title: Resources.Titles.trackersTitle,
            image: Resources.Images.tracksTab,
            selectedImage: nil
        )
        
        let statistic = StatisticViewController()
        let statisticNav = UINavigationController(rootViewController: statistic)
        statisticNav.tabBarItem = UITabBarItem(
            title: Resources.Titles.statisticTitle,
            image: Resources.Images.statisticTab,
            selectedImage: nil
        )
        
        self.viewControllers  = [trackersNav, statisticNav]
    }
}
