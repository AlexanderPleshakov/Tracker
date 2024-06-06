//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Александр Плешаков on 06.06.2024.
//

import UIKit
import CoreData

final class TrackerCategoryStore {
    // MARK: Properties
    
    private var context: NSManagedObjectContext
    
    // MARK: Init
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        let context = DataManager.shared.persistentContainer.viewContext
        self.init(context: context)
    }
    
    // MARK: Methods
    
    private func fetchCoreDataCategory(with title: String) -> TrackerCategoryCoreData? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCoreData.title),
            title
        )
        
        let coreDataCategories = try? context.fetch(request)
        
        return coreDataCategories?.first
    }
    
    func add(_ category: TrackerCategory) {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        
        categoryCoreData.title = category.title
        categoryCoreData.trackers = category.trackers as NSObject
        
        DataManager.shared.saveContext()
    }
    
    func fetchAll() -> [TrackerCategory] {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        let coreDataCategories = try? context.fetch(request)
        
        let categories = coreDataCategories?.map {
            guard let title = $0.title,
                  let trackers = $0.trackers as? [Tracker]
            else {
                fatalError("Title of category is nil")
            }
            
            return TrackerCategory(title: title,
                                   trackers: trackers)
        }
        
        return categories ?? []
    }
    
    func update(_ newCategory: TrackerCategory) {
        guard let coreDataCategory = fetchCoreDataCategory(with: newCategory.title) else {
            assertionFailure("func update - CoreDataCategory is nil ")
            return
        }
        
        coreDataCategory.title = newCategory.title
        coreDataCategory.trackers = newCategory.trackers as NSObject
        
        DataManager.shared.saveContext()
    }
    
    func deleteCategory(with title: String) {
        guard let coreDataCategory = fetchCoreDataCategory(with: title) else {
            assertionFailure("func update - CoreDataCategory is nil ")
            return
        }
        
        context.delete(coreDataCategory)
        
        DataManager.shared.saveContext()
    }
    
    func categoryIsExist(with title: String) -> Bool {
        fetchCoreDataCategory(with: title) != nil ? true : false
    }
}
