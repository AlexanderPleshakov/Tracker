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
        tabBar.isTranslucent = false
        tabBar.addTopBorder(color: Resources.Colors.searchTextGray, thickness: 0.5)
        
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

extension UITabBar {
    func addTopBorder(color: UIColor?, thickness: CGFloat) {
        let subview = UIView()
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.backgroundColor = color
        self.addSubview(subview)
        
        NSLayoutConstraint.activate([
            subview.leftAnchor.constraint(equalTo: self.leftAnchor),
            subview.rightAnchor.constraint(equalTo: self.rightAnchor),
            subview.heightAnchor.constraint(equalToConstant: thickness),
            subview.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
}
