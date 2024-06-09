//
//  TrackerStore.swift
//  Tracker
//
//  Created by Александр Плешаков on 07.06.2024.
//

import UIKit
import CoreData

final class TrackerStore {
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
        
        let daysRequest = NSFetchRequest<DayCoreData>(entityName: "DayCoreData")
        
        guard var days = try? context.fetch(daysRequest) else {
            return
        }
        
        days = days.filter { day in
            schedule?.contains(where: { str in
                day.day == str
            }) ?? false
        }
        
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = Int32(tracker.color ?? 0x000000)
        trackerCoreData.emoji = String(tracker.emoji ?? "⚙️")
        trackerCoreData.creationDate = tracker.creationDate
        
        trackerCoreData.category = categoriesCoreData.first
        trackerCoreData.schedule = NSSet(array: days)
        
        save()
    }
}
