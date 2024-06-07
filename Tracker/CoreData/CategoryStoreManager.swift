//
//  CategoryStoreManager.swift
//  Tracker
//
//  Created by Александр Плешаков on 07.06.2024.
//

import UIKit
import CoreData

final class CategoryStoreManager: NSObject {
    private let categoryStore: CategoryStore
    
    init(categoryStore: CategoryStore) {
        self.categoryStore = categoryStore
    }
    
    func create(category: TrackerCategory) {
        categoryStore.create(category: category)
    }
    
    func fetchAll() -> [TrackerCategory] {
        categoryStore.fetchAll()
    }
}
