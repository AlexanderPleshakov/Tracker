//
//  TimetableDelegate.swift
//  Tracker
//
//  Created by Александр Плешаков on 11.05.2024.
//

import Foundation

protocol TimetableDelegate: NSObject {
    func changeSelectedDays(new days: [Day])
}
