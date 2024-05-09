//
//  TrackersNavigationController.swift
//  Tracker
//
//  Created by Александр Плешаков on 09.05.2024.
//

import UIKit

final class TrackersNavigationController: UINavigationController {
    // MARK: Properties
    
    weak var delegateController: TrackersNavigationControllerDelegate!
    
    
    // MARK: Init
    
    init(rootViewController: TrackersNavigationControllerDelegate) {
        super.init(rootViewController: rootViewController)
        
        delegateController = rootViewController
        navBarConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    func navBarConfig() {
        setTitle()
        setAddButton()
        setDatePicker()
        setSearchBar()
    }
    
    private func setTitle() {
        delegateController.navigationItem.titleView?.tintColor = Resources.Colors.black
        delegateController.navigationController?.navigationBar.prefersLargeTitles = true
        
        delegateController.navigationItem.title = "Трекеры"
    }
    
    private func setAddButton() {
        delegateController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: Resources.Images.addButton,
                                                                              style: .plain,
                                                                              target: self,
                                                                              action: #selector(addButtonTapped))
        delegateController.navigationItem.leftBarButtonItem?.tintColor = Resources.Colors.black
    }
    
    private func setDatePicker() {
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        datePicker.backgroundColor = Resources.Colors.lightGray
        datePicker.tintColor = Resources.Colors.blue
        
        delegateController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "Поиск"
        search.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        delegateController.navigationItem.searchController = search
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        delegateController.dateWasChanged(date: sender.date)
    }
    
    @objc func addButtonTapped() {
        delegateController.addButtonTapped()
    }
}
