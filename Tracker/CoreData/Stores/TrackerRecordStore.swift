//
//  DaysStore.swift
//  Tracker
//
//  Created by Александр Плешаков on 07.06.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore {
    private let context: NSManagedObjectContext
    private let dataManager = CoreDataManager.shared
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        self.init(context: context)
    }
    
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
        trackerRecordCoreData.count = Int32(trackerRecord.count)
        
        save()
    }
    
    func delete(id: UUID, date: Date) {
        guard let trackerCoreData = fetchTrackerRecord(by: id, and: date) else {
            return
        }
        
        context.delete(trackerCoreData)
        
        save()
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
