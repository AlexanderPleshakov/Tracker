//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 03.05.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    // MARK: Properties
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
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
    
    private let stubView = StubView()
    
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
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy" // Формат даты
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
}

// MARK: UI configuration

extension TrackersViewController {
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
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        datePicker.backgroundColor = Resources.Colors.lightGray
        datePicker.tintColor = Resources.Colors.blue
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setSubviews() {

        view.addSubview(searchField)
        addStubView()
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: 36),
        ])
    }
    
    private func addStubView() {
        view.addSubview(stubView)
        
        NSLayoutConstraint.activate([
            stubView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stubView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stubView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stubView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
}
