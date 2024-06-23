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
        
        updatePinnedTitleIfNeeded()
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
        categoryCoreData.isPinned = false
        
        save()
    }
    
    func fetchCategoryCoreData(by title: String) -> CategoryCoreData? {
        let request = NSFetchRequest<CategoryCoreData>(entityName: "CategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(CategoryCoreData.title), title)
        
        guard let categoriesCoreData = try? context.fetch(request) else {
            print("Categories core data is nil in create(tracker:)")
            return nil
        }
        
        return categoriesCoreData.first
    }
    
    func fetchCategory(by title: String) -> TrackerCategory? {
        let request = NSFetchRequest<CategoryCoreData>(entityName: "CategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(CategoryCoreData.title), title)
        
        guard let categoriesCoreData = try? context.fetch(request) else {
            print("Categories core data is nil in create(tracker:)")
            return nil
        }
        
        let trackersCoreData = categoriesCoreData.first?.trackers?.allObjects as? [TrackerCoreData]
        let trackers = trackersCoreData?.map { Tracker(coreDataTracker: $0) }
        
        return TrackerCategory(title: title, trackers: trackers ?? [])
    }
    
    func fetchAll() -> [TrackerCategory] {
        let request = NSFetchRequest<CategoryCoreData>(entityName: "CategoryCoreData")
        let pinnedCategoryName = NSLocalizedString("pinned", comment: "")
        request.predicate = NSPredicate(format: "%K != %@",
                                             #keyPath(CategoryCoreData.title),
                                             pinnedCategoryName)
        
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
    
    private func updatePinnedTitleIfNeeded() {
        let pinnedCategoryName = NSLocalizedString("pinned", comment: "")
        let request = NSFetchRequest<CategoryCoreData>(entityName: "CategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@",
                                        #keyPath(CategoryCoreData.isPinned),
                                        NSNumber(value: true))
        
        guard let categoriesCoreData = try? context.fetch(request),
              let category = categoriesCoreData.first
        else {
            print("Categories core data is nil in fetchAll()")
            return
        }
        
        if category.title != pinnedCategoryName {
            category.title = pinnedCategoryName
            
            save()
        }
    }
}
