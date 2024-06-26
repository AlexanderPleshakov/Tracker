//
//  TrackerStoreManagerDelegate.swift
//  Tracker
//
//  Created by Александр Плешаков on 08.06.2024.
//

import Foundation

protocol TrackerStoreManagerDelegate: AnyObject {
    func addTracker(at indexPath: IndexPath)
    func updateTracker(at indexPath: IndexPath)
    func deleteTracker(at indexPath: IndexPath)
    func forceReload()
}
