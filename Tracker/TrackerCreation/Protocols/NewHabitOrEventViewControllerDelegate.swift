//
//  NewHabitOrEventViewControllerDelegate.swift
//  Tracker
//
//  Created by Александр Плешаков on 10.05.2024.
//

import Foundation

protocol NewHabitOrEventViewControllerDelegate: NSObject {
    func closeController()
    func addTracker()
}
