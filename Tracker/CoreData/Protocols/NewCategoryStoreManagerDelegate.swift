//
//  NewCategoryStoreManagerDelegate.swift
//  Tracker
//
//  Created by Александр Плешаков on 07.06.2024.
//

import Foundation

protocol NewCategoryStoreManagerDelegate: AnyObject {
    func insert(_ category: TrackerCategory, at indexPath: IndexPath)
}
