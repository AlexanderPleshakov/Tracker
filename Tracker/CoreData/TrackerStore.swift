//
//  TrackerStore.swift
//  Tracker
//
//  Created by Александр Плешаков on 05.06.2024.
//

import UIKit
import CoreData

final class TrackerStore {
    // MARK: Properties
    
    private var trackerCoreData: TrackerCoreData
    private var context: NSManagedObjectContext
    
    // MARK: Init
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.trackerCoreData = TrackerCoreData(context: context)
    }
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        self.init(context: context)
    }
    
    // MARK: Methods
    
    func addTracker(_ tracker: Tracker) {
        let id = tracker.id
        let timetable = tracker.timetable
        guard let name = tracker.name,
              let color = tracker.color,
              let emoji = tracker.emoji,
              let creationDate = tracker.creationDate
        else {
            fatalError("Tracker is nil in addTracker")
        }
        
        let timetableString = timetable?.map {
            $0.rawValue
        }
        
        trackerCoreData.id = id
        trackerCoreData.name = name
        trackerCoreData.color = Int32(color)
        trackerCoreData.emoji = emoji
        trackerCoreData.creationDate = creationDate
        trackerCoreData.timetable = timetableString
    }
    
    func fetchTrackers() -> [Tracker] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let coreDataTrackers = try? context.fetch(request)
        
        let trackers = coreDataTrackers?.map {
            guard let id = $0.id else { fatalError("Id of the tracker is nil") }
            
            let timetable = $0.timetable?.map {
                guard let day = Day(rawValue: $0) else {
                    fatalError("RawValue of Day incorrect")
                }
                return day
            }
            
            return Tracker(id: id,
                    name: $0.name,
                    color: Int($0.color),
                    emoji: $0.emoji,
                    timetable: timetable,
                    creationDate: $0.creationDate)
        }
        
        
        return trackers ?? []
    }
}
