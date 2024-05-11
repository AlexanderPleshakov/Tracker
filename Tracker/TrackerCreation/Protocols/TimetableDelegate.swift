//
//  TimetableDelegate.swift
//  Tracker
//
//  Created by Александр Плешаков on 11.05.2024.
//

import Foundation

protocol TimetableDelegate: NSObject {
    var selectedDays: [Day] { get set }
    
    func changeSubtitle()
}
