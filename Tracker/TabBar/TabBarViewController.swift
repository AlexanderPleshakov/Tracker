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
        
        configure()
    }
    
    private func configure() {
        view.backgroundColor = Resources.Colors.white
        tabBar.barTintColor = Resources.Colors.white
        tabBar.isTranslucent = false
        
        addTabs()
    }
    
    private func addTabs() {
        let tracks = createTab(title: "Трекеры",
                               image: Resources.Images.tracksTab,
                               for: TracksViewController())
        let statistic = createTab(title: "Статистика",
                               image: Resources.Images.statisticTab,
                               for: StatisticViewController())
        self.viewControllers  = [tracks, statistic]
    }
    
    private func createTab(title: String, image: UIImage, for viewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        
        viewController.tabBarItem = UITabBarItem(
            title: title,
            image: image,
            selectedImage: nil
        )
        
        return nav
    }
}
