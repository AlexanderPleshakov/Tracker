//
//  CategoryStore.swift
//  Tracker
//
//  Created by Александр Плешаков on 07.06.2024.
//

import UIKit
import CoreData

final class CategoryStore {
    private let context: NSManagedObjectContext
    private let dataManager = CoreDataManager.shared
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        self.init(context: context)
    }
    
    private func save() {
        dataManager.saveContext()
    }
    
    func create(category: TrackerCategory) {
        let categoryCoreData = CategoryCoreData(context: context)
        
        categoryCoreData.title = category.title
        categoryCoreData.trackers = []
        
        save()
    }
    
    func fetchAll() -> [TrackerCategory] {
        let request = NSFetchRequest<CategoryCoreData>(entityName: "CategoryCoreData")
        
        guard let categoriesCoreData = try? context.fetch(request) else {
            print("Categories core data is nil in fetchAll()")
            return []
        }
        
        let categories = categoriesCoreData.map {
            guard let title = $0.title else {
                fatalError("ERROR: Title of stored category is nil")
            }
            return TrackerCategory(title: title, trackers: [])
        }
        
        return categories
    }
}
