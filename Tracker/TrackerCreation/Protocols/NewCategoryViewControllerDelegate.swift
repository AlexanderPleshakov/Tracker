//
//  NewCategoryViewControllerDelegate.swift
//  Tracker
//
//  Created by Александр Плешаков on 12.05.2024.
//

import Foundation

protocol NewCategoryViewControllerDelegate: NSObject {
    var categories: [TrackerCategory] { get set }
    
    func removeStubAndShowCategories()
}