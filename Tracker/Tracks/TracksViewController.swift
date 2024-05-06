//
//  TracksViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 03.05.2024.
//

import UIKit

class TracksViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        view.backgroundColor = Resources.Colors.white
        
        navBarConfig()
    }
    
    private func navBarConfig() {
        navigationItem.title = "Трекеры"
        navigationItem.titleView?.tintColor = Resources.Colors.black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Resources.Images.addButton,
                                                           style: .plain,
                                                           target: self, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = Resources.Colors.black
        
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 34)
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
}

