//
//  Tracker.swift
//  Tracker
//
//  Created by Александр Плешаков on 08.05.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String?
    let color: UIColor?
    let emoji: Character?
    let timetable: [Day]?
    let creationDate: Date?
    
    func isEmpty(type: TrackerType) -> Bool {
        if self.name != nil && !(self.name == "") && self.color != nil &&
            self.emoji != nil && self.timetable != nil &&
            !(self.timetable?.isEmpty ?? true) && type == .habit {
            
            return false
        } else if self.name != nil && !(self.name == "") &&
                    self.color != nil && self.emoji != nil && type == .event {
            
            return false
        }
        
        return true
    }
    
    init(id: UUID, name: String?, color: UIColor?, emoji: Character?, timetable: [Day]?, creationDate: Date?) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.timetable = timetable
        self.creationDate = creationDate
    }
    
    init(coreDataTracker: TrackerCoreData) {
        guard let id = coreDataTracker.id,
              let name = coreDataTracker.name,
              let emoji = coreDataTracker.emoji?.first,
              let creationDate = coreDataTracker.creationDate
        else {
            fatalError("Some property is nil in Tracker")
        }
        
        let schedule = coreDataTracker.timetable?.map {
            Day(rawValue: $0) ?? .monday
        }
        
        self.id = id
        self.name = name
        self.color = UIColor(rgb: Int(coreDataTracker.color))
        self.emoji = emoji
        self.timetable = schedule
        self.creationDate = creationDate
    }
}
