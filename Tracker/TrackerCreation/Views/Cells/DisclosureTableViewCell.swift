//
//  DisclosureTableViewCell.swift
//  Tracker
//
//  Created by Александр Плешаков on 11.05.2024.
//

import UIKit

final class DisclosureTableViewCell: UITableViewCell {
    static let reuseIdentifier = "DisclosureTableViewCell"
    
    static let buttonTappedNotification = NSNotification.Name("ViewControllerDismiss")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Resources.Colors.cellBackground
        accessoryType = .disclosureIndicator
        textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        detailTextLabel?.textColor = Resources.Colors.searchTextGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeTimetableSubtitle(days: String?) {
        if textLabel?.text == "Расписание" {
            detailTextLabel?.text = days
        }
    }
    
    func changeCategorySubtitle(subtitle: String) {
        if textLabel?.text == "Категория" {
            detailTextLabel?.text = subtitle
        }
    }
}
