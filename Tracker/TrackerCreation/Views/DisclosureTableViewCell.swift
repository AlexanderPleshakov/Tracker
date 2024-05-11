//
//  DisclosureTableViewCell.swift
//  Tracker
//
//  Created by Александр Плешаков on 11.05.2024.
//

import UIKit

final class DisclosureTableViewCell: UITableViewCell {
    static let reuseIdentifier = "DisclosureTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Resources.Colors.cellBackground
        accessoryType = .disclosureIndicator
        textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        detailTextLabel?.textColor = Resources.Colors.searchTextGray
        
        NotificationCenter.default.addObserver(forName: TimetableViewController.buttonTappedNotification, object: nil, queue: .main) { [weak self] notification in
            if let days = notification.userInfo?["days"] as? [Day] {
                self?.changeSubtitle(days: days)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func changeSubtitle(days: [Day]) {
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
}
