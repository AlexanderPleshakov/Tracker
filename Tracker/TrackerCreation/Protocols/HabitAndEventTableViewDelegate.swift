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
    func reloadTable(isAdding: Bool)
    func changeCategoryTitle(text: String?)
}
