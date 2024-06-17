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
        delegateController.navigationController?.navigationBar.shadowImage = UIImage()
        delegateController.navigationController?.navigationBar.backgroundColor = Resources.Colors.background
        delegateController.navigationController?.navigationBar.isTranslucent = false
        
        delegateController.navigationItem.hidesSearchBarWhenScrolling = false
        delegateController.navigationItem.largeTitleDisplayMode = .always
        
        setTitle()
        setAddButton()
        setDatePicker()
        setSearchBar()
    }
    
    private func setTitle() {
        delegateController.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: Resources.Colors.foreground]
        delegateController.navigationController?.navigationBar.prefersLargeTitles = true
        
        delegateController.navigationItem.title = NSLocalizedString("trackers", comment: "Trackers title")
    }
    
    private func setAddButton() {
        delegateController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: Resources.Images.addButton,
                                                                              style: .plain,
                                                                              target: self,
                                                                              action: #selector(addButtonTapped))
        delegateController.navigationItem.leftBarButtonItem?.tintColor = Resources.Colors.foreground
    }
    
    private func setDatePicker() {
        let datePicker = UIDatePicker()
        
        datePicker.locale = Locale.current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        datePicker.tintColor = Resources.Colors.blue
        
        datePicker.backgroundColor = Resources.Colors.datePicker
        datePicker.layer.cornerRadius = 8
        datePicker.layer.masksToBounds = true
        
        datePicker.overrideUserInterfaceStyle = .light
        
        delegateController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = NSLocalizedString("search", comment: "Search bar placeholder")
        search.searchBar.setValue(NSLocalizedString("cancel", comment: "Cancel search button"), forKey: "cancelButtonText")
        search.searchResultsUpdater = delegateController
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.searchTextField.backgroundColor = Resources.Colors.searchBackgroundGray
        search.searchBar.searchTextField.attributedPlaceholder =  NSAttributedString.init(
            string: NSLocalizedString("search", comment: "Search bar placeholder"),
            attributes: [NSAttributedString.Key.foregroundColor:Resources.Colors.searchText])
        search.searchBar.searchTextField.leftView?.tintColor = Resources.Colors.searchText
        
        delegateController.navigationItem.searchController = search
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        delegateController.dateWasChanged(date: sender.date)
    }
    
    @objc func addButtonTapped() {
        delegateController.addButtonTapped()
    }
}
