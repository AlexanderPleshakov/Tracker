//
//  CategoriesViewControllerDelegate.swift
//  Tracker
//
//  Created by Александр Плешаков on 12.05.2024.
//

import Foundation

protocol CategoriesViewControllerDelegate: NSObject {
    func changeSelectedCategory(new category: TrackerCategory?)
}
