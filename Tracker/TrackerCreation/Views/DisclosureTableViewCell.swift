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
        
        NotificationCenter.default.addObserver(forName: DisclosureTableViewCell.buttonTappedNotification, object: nil, queue: .main) { [weak self] notification in
            if let days = notification.userInfo?["days"] as? [Day] {
                self?.changeTimetableSubtitle(days: days)
            }
            
            if let categoryTitle = notification.userInfo?["category"] as? String {
                self?.changeCategorySubtitle(subtitle: categoryTitle)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func changeTimetableSubtitle(days: [Day]) {
        if textLabel?.text == "Расписание" {
            if days.count == 7 {
                detailTextLabel?.text = "Каждый день"
                return
            }
            var values = [String]()
            
            for day in days {
                values.append(day.rawValue)
            }
            let text = values.joined(separator: ", ")
            
            detailTextLabel?.text = text
        }
    }
    
    private func changeCategorySubtitle(subtitle: String) {
        if textLabel?.text == "Категория" {
            detailTextLabel?.text = subtitle
        }
    }
}
