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
    let color: Int?
    let emoji: String?
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
}
