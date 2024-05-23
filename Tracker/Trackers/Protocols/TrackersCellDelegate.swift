//
//  TrackersCellDelegate.swift
//  Tracker
//
//  Created by Александр Плешаков on 23.05.2024.
//

import Foundation

protocol TrackersCellDelegate: NSObject {
    func completeTracker(id: UUID)
    func incompleteTracker(id: UUID)
}
