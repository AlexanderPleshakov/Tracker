//
//  HabitAndEventTableViewHelper.swift
//  Tracker
//
//  Created by Александр Плешаков on 10.05.2024.
//

import UIKit

final class HabitAndEventTableViewHelper: NSObject {
    private let numbersOfRows: [Int]
    private var warningView: UILabel?
    weak var delegateController: HabitAndEventTableViewDelegate!
    
    private var category: String? = nil
    private var days: String? = nil
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.textColor = Resources.Colors.red
        label.text = NSLocalizedString("characterLimit", comment: "Character input limit")
        label.textAlignment = .center
        
        return label
    }()
    
    init(type: TrackerType, delegate: HabitAndEventTableViewDelegate) {
        self.numbersOfRows = type == TrackerType.habit ? [1, 2] : [1, 1]
        self.delegateController = delegate
    }
    
    func addWarning() {
        warningView = warningLabel
        delegateController.reloadTable(isAdding: true)
    }
    
    func removeWarning() {
        warningView = nil
        delegateController.reloadTable(isAdding: false)
    }
    
    func textChanged(newText: String?) {
        delegateController.changeTrackerTitle(text: newText)
    }
    
    func changeCategory(category: String?) {
        self.category = category
    }
    
    func changeDays(days: String?) {
        self.days = days
    }
    
    func changeCategoryDetail(text: String) {
        let indexPath = IndexPath(row: 0, section: 1)
        guard let cell = delegateController.getCell(at: indexPath) as? DisclosureTableViewCell else {
            print("cell is nil")
            return
        }
        cell.changeCategorySubtitle(subtitle: text)
    }
    
    func changeDaysDetail(days: String) {
        let indexPath = IndexPath(row: 1, section: 1)
        guard let cell = delegateController.getCell(at: indexPath) as? DisclosureTableViewCell else {
            print("cell is nil")
            return
        }
        cell.changeTimetableSubtitle(days: days)
    }
}

// MARK: UITableViewDelegate

extension HabitAndEventTableViewHelper: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return warningView
        }
        return nil
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return warningView != nil ? 38 : .leastNonzeroMagnitude
        }
        return .leastNonzeroMagnitude
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                delegateController.presentCategories()
            case 1:
                delegateController.presentTimetable()
            default:
                break
            }
        }
    }
}

// MARK: UITableViewDataSource

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
            
            cell.delegate = self
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DisclosureTableViewCell.reuseIdentifier, for: indexPath)
            
            guard let cell = cell as? DisclosureTableViewCell else { 
                print("def")
                return UITableViewCell()
                
            }
            let cellText: String
            let detailText: String
            
            if indexPath.row == 0 {
                cellText = NSLocalizedString("category", comment: "Category cell")
                detailText = category ?? ""
            } else {
                cellText = NSLocalizedString("schedule", comment: "Category cell")
                detailText = days ?? ""
            }
            
            cell.textLabel?.text = cellText
            cell.detailTextLabel?.text = detailText
            
            return cell
        }
    }
}
