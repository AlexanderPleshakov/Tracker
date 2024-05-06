//
//  TracksViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 03.05.2024.
//

import UIKit

final class TracksViewController: UIViewController {
    
    // MARK: Init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: Methods
    
    private func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: Date())
    }
    
    @objc private func datePickerTapped() {
        print("Date picker tapped")
    }
}

// MARK: UI configuration

extension TracksViewController {
    private func configure() {
        view.backgroundColor = Resources.Colors.white
        
        navBarConfig()
    }
    
    private func navBarConfig() {
        setTitle()
        setAddButton()
        setDatePicker()
    }
    
    private func setTitle() {
        navigationItem.titleView?.tintColor = Resources.Colors.black
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Трекеры"
        let attributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 34)
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
    
    private func setAddButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Resources.Images.addButton,
                                                           style: .plain,
                                                           target: self, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = Resources.Colors.black
    }
    
    private func setDatePicker() {
        let datePickerView = DatePickerView(date: getDate())
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePickerView)
    }
}
