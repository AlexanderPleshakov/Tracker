//
//  TracksViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 03.05.2024.
//

import UIKit

final class TracksViewController: UIViewController {
    // MARK: Properties
    
    private let searchField: UISearchTextField = {
        let field = UISearchTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        
        field.backgroundColor = Resources.Colors.searchBackgroundGray
        field.textColor = Resources.Colors.black
        field.tintColor = Resources.Colors.blue
        field.leftView?.tintColor = Resources.Colors.searchTextGray
        
        let placeholderAttributes = [NSAttributedString.Key.foregroundColor : Resources.Colors.searchTextGray]
        let attributedPlaceholder = NSAttributedString(string: "Поиск", attributes: placeholderAttributes as [NSAttributedString.Key : Any])
        field.attributedPlaceholder = attributedPlaceholder
        
        field.font = UIFont.systemFont(ofSize: 17)
        
        return field
    }()
    
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
        setSubviews()
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
    
    private func setSubviews() {
        
        view.addSubview(searchField)
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: 36)
            
        ])
    }
}
