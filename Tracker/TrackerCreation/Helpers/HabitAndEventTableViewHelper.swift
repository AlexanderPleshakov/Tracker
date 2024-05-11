//
//  HabitAndEventTableViewHelper.swift
//  Tracker
//
//  Created by Александр Плешаков on 10.05.2024.
//

import UIKit

final class HabitAndEventTableViewHelper: NSObject {
    let numbersOfRows: [Int]
    weak var delegateController: HabitAndEventTableViewDelegate!
    
    init(type: TrackerType, delegate: HabitAndEventTableViewDelegate) {
        self.numbersOfRows = type == TrackerType.habit ? [1, 2] : [1, 1]
        self.delegateController = delegate
    }
}


extension HabitAndEventTableViewHelper: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            delegateController.presentTimetable()
        }
    }
}

extension HabitAndEventTableViewHelper: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? numbersOfRows[0] : numbersOfRows[1]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: InputFieldTableViewCell.reuseIdentifier, for: indexPath)
            
            guard let cell = cell as? InputFieldTableViewCell else {
                return UITableViewCell()
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DisclosureTableViewCell.reuseIdentifier, for: indexPath)
            
            guard let cell = cell as? DisclosureTableViewCell else { 
                print("def")
                return UITableViewCell()
                
            }
            
            let cellText = indexPath.row == 0 ? "Категория" : "Расписание"
            
            cell.textLabel?.text = cellText
            cell.detailTextLabel?.text = ""
            
            return cell
        }
    }
}
