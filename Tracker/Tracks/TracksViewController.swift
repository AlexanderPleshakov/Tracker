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
    
    private func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: Date())
    }
}

extension TracksViewController {
    private func configure() {
        view.backgroundColor = Resources.Colors.white
        
        navBarConfig()
    }
    
    private func navBarConfig() {
        navigationItem.titleView?.tintColor = Resources.Colors.black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Трекеры"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Resources.Images.addButton,
                                                           style: .plain,
                                                           target: self, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = Resources.Colors.black
        
        let datePickerView = DatePickerView(date: getDate())
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePickerView)
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 34)
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
    
    @objc private func datePickerTapped() {
        print("Date picker tapped")
    }
}

