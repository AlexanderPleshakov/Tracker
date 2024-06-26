//
//  DaysStore.swift
//  Tracker
//
//  Created by Александр Плешаков on 07.06.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore {
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
    
    func fetchAll() -> [TrackerRecord] {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        guard let trackersCoreData = try? context.fetch(request) as [TrackerRecordCoreData] else {
            return []
        }
        
        let trackers = trackersCoreData.map {
            TrackerRecord($0)
        }
        
        return trackers
    }
    
    func fetchCount(by id: UUID) -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerID), id as CVarArg)
        
        request.predicate = idPredicate
        
        guard let count = try? context.count(for: request) else {
            return 0
        }
        
        return count
    }
    
    func fetch(by id: UUID, and date: Date) -> TrackerRecord? {
        guard let trackerCoreData = fetchTrackerRecord(by: id, and: date) else {
            return nil
        }
        
        return TrackerRecord(trackerCoreData)
    }
    
    func add(trackerRecord: TrackerRecord) {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        
        trackerRecordCoreData.trackerID = trackerRecord.id
        trackerRecordCoreData.date = trackerRecord.date
        save()
        
        completeTracker(id: trackerRecord.id, date: trackerRecord.date)
    }
    
    func delete(id: UUID, date: Date) {
        guard let trackerCoreData = fetchTrackerRecord(by: id, and: date) else {
            return
        }
        
        context.delete(trackerCoreData)
        save()
        
        incompleteTracker(id: id, date: date)
    }
    
    func trackerIsCompleted(id: UUID?) -> Bool {
        return true
    }
    
    func completeTracker(id: UUID, date: Date) {
        guard let tracker = fetchTrackerCoreData(by: id) else {
            return
        }
        let completedDate = CompletedDate(context: context)
        completedDate.date = date
        let completed = tracker.completedDates?.adding(completedDate)
        
        tracker.completedDates = NSSet(set: completed ?? [completedDate])
        
        save()
    }
    
    func incompleteTracker(id: UUID, date: Date) {
        guard let tracker = fetchTrackerCoreData(by: id) else {
            return
        }
        guard let strippedTargetDate = stripTime(from: date) else { return }
        
        let datePredicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            strippedTargetDate as CVarArg,
            Calendar.current.date(byAdding: .day, value: 1, to: strippedTargetDate)! as CVarArg
        )
        
        guard
            let completedDates = tracker.completedDates?.filtered(using: datePredicate),
            let completedDate = completedDates.first as? CompletedDate
        else { return }
        
        context.delete(completedDate)
        
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
    
    private func fetchTrackerRecord(by id: UUID, and date: Date) -> TrackerRecordCoreData? {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerID), id as CVarArg)
        let strippedTargetDate = stripTime(from: date) ?? Date()
        let datePredicate = NSPredicate(format: "date >= %@ AND date < %@",
                                        strippedTargetDate as CVarArg,
                                        Calendar.current.date(
                                            byAdding: .day,
                                            value: 1,
                                            to: strippedTargetDate)! as CVarArg)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate, datePredicate])
        
        request.predicate = compoundPredicate
        
        guard let trackersCoreData = try? context.fetch(request) as [TrackerRecordCoreData],
              let trackerCoreData = trackersCoreData.first
        else {
            return nil
        }
        
        return trackerCoreData
    }
    
    private func stripTime(from date: Date) -> Date? {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: date))
    }
    
    private func save() {
        dataManager.saveContext()
    }
}
