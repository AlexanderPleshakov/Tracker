//
//  CategoryStore.swift
//  Tracker
//
//  Created by Александр Плешаков on 07.06.2024.
//

import UIKit
import CoreData

final class CategoryStore {
    // MARK: Properties
    
    private let context: NSManagedObjectContext
    private let dataManager = CoreDataManager.shared
    
    // MARK: Init
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        self.init(context: context)
    }
    
    // MARK: Methods
    
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
            
            let trackersCoreData = $0.trackers?.allObjects as? [TrackerCoreData]
            let trackers = trackersCoreData?.map { Tracker(coreDataTracker: $0) }
            
            return TrackerCategory(title: title, trackers: trackers ?? [])
        }
        
        return categories
    }
}
