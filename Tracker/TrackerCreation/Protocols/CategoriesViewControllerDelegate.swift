//
//  CategoriesViewControllerDelegate.swift
//  Tracker
//
//  Created by Александр Плешаков on 12.05.2024.
//

import Foundation

protocol CategoriesViewControllerDelegate: NSObject {
    var selectedCategory: TrackerCategory? { get set }
}
