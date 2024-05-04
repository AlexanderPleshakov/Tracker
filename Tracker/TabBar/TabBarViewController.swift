//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 04.05.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        
        let tracksViewController = TracksViewController()
        
        let statisticViewController = StatisticViewController()
        
        tracksViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: Constants.Images.tracksTab),
            selectedImage: nil
        )
        
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: Constants.Images.statisticTab),
            selectedImage: nil)
            
        self.viewControllers  = [tracksViewController, statisticViewController]
    }
}
