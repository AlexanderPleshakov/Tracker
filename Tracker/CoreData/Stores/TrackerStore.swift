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
    
    func fetchTracker(by id: UUID) -> Tracker? {
        guard let trackerCoreData = fetchTrackerCoreData(by: id) else {
            return nil
        }
        let tracker = Tracker(coreDataTracker: trackerCoreData)
        
        return tracker
    }
    
    func fetchCategory(by trackerId: UUID) -> TrackerCategory? {
        guard let tracker = fetchTrackerCoreData(by: trackerId),
              let categoryCD = tracker.category,
              let title = categoryCD.title
        else {
            return nil
        }
        
        let trackers = categoryCD.trackers?.allObjects as? [Tracker]
        let category = TrackerCategory(title: title, trackers: trackers ?? [])
        
        return category
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
            Day.shortName(by: $0.rawValue)
        }
        
        let daysRequest = NSFetchRequest<DayCoreData>(entityName: "DayCoreData")
        
        guard var days = try? context.fetch(daysRequest) else {
            print("Days is empty in DB")
            return
        }
        
        days = days.filter { day in
            schedule?.contains(where: { str in
                day.day == str
            }) ?? false
        }
        
        trackerCoreData.trackerId = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = Int32(tracker.color ?? 0x000000)
        trackerCoreData.emoji = String(tracker.emoji ?? "⚙️")
        trackerCoreData.creationDate = tracker.creationDate
        
        trackerCoreData.category = categoriesCoreData.first
        trackerCoreData.schedule = NSSet(array: days)
        
        save()
    }
    
    func update(tracker: Tracker) {
        guard let trackerCoreData = fetchTrackerCoreData(by: tracker.id) else {
            return
        }
        
        trackerCoreData.trackerId = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = Int32(tracker.color ?? 0x000000)
        trackerCoreData.emoji = String(tracker.emoji ?? "⚙️")
        
        save()
    }
    
    func deleteTracker(by id: UUID) {
        guard let trackerCoreData = fetchTrackerCoreData(by: id) else {
            return
        }
        
        context.delete(trackerCoreData)
        
        save()
    }
    
    private func fetchTrackerCoreData(by id: UUID) -> TrackerCoreData? {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.trackerId), id as CVarArg)
        
        guard let trackerCoreData = try? context.fetch(fetchRequest) as [TrackerCoreData] else {
            return nil
        }
        
        return trackerCoreData.first
    }
}
