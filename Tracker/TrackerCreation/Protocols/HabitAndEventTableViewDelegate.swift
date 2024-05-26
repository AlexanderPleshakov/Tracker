//
//  HabitAndEventTableViewDelegate.swift
//  Tracker
//
//  Created by Александр Плешаков on 10.05.2024.
//

import UIKit

protocol HabitAndEventTableViewDelegate: NSObject {
    func presentTimetable()
    func presentCategories()
    func reloadTable()
    func changeCategoryTitle(text: String?)
    
    var warningLabel: UILabel { get }
    
}
