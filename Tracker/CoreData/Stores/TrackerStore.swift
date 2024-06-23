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
    private let categoryStore = CategoryStore()
    
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
        
        guard let category = categoryStore.fetchCategoryCoreData(by: category.title) else {
            return
        }
        
        trackerCoreData.trackerId = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = Int32(tracker.color ?? 0x000000)
        trackerCoreData.emoji = String(tracker.emoji ?? "⚙️")
        trackerCoreData.creationDate = tracker.creationDate
        
        trackerCoreData.category = category
        trackerCoreData.schedule = convertToDaysCoreData(from: tracker.timetable)
        
        save()
    }
    
    func update(tracker: Tracker, category: TrackerCategory) {
        guard let trackerCoreData = fetchTrackerCoreData(by: tracker.id),
              let category = categoryStore.fetchCategoryCoreData(by: category.title)
        else {
            return
        }
        
        trackerCoreData.category = category
        trackerCoreData.name = tracker.name
        trackerCoreData.color = Int32(tracker.color ?? 0x000000)
        trackerCoreData.emoji = String(tracker.emoji ?? "⚙️")
        trackerCoreData.schedule = convertToDaysCoreData(from: tracker.timetable)
        
        save()
    }
    
    func deleteTracker(by id: UUID) {
        guard let trackerCoreData = fetchTrackerCoreData(by: id) else {
            return
        }
        
        context.delete(trackerCoreData)
        
        save()
    }
    
    private func convertToDaysCoreData(from daysArray: [Day]?) -> NSSet {
        let schedule = daysArray?.map {
            Day.shortName(by: $0.rawValue)
        }
        
        let daysRequest = NSFetchRequest<DayCoreData>(entityName: "DayCoreData")
        
        guard var days = try? context.fetch(daysRequest) else {
            print("Days is empty in DB")
            return NSSet()
        }
        
        days = days.filter { day in
            schedule?.contains(where: { str in
                day.day == str
            }) ?? false
        }
        
        return NSSet(array: days)
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
