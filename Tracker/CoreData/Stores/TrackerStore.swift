//
//  TrackerStore.swift
//  Tracker
//
//  Created by Александр Плешаков on 07.06.2024.
//

import UIKit
import CoreData

final class TrackerStore {
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
    
    func create(tracker: Tracker, for category: TrackerCategory) {
        let trackerCoreData = TrackerCoreData(context: context)
        
        let request = NSFetchRequest<CategoryCoreData>(entityName: "CategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(CategoryCoreData.title), category.title)
        
        guard let categoriesCoreData = try? context.fetch(request) else {
            print("Categories core data is nil in create(tracker:)")
            return
        }
        
        let schedule = tracker.timetable?.map {
            $0.rawValue
        }
        
        
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = Int32(0x2FD058)
        trackerCoreData.emoji = String(tracker.emoji ?? "⚙️")
        trackerCoreData.timetable = schedule
        trackerCoreData.creationDate = tracker.creationDate
        
        trackerCoreData.category = categoriesCoreData.first
        
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
