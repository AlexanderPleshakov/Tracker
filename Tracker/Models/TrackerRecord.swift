//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Александр Плешаков on 08.05.2024.
//

import Foundation

struct TrackerRecord: Equatable {
    let id: UUID
    let date: Date
    
    static func == (lhs: TrackerRecord, rhs: TrackerRecord) -> Bool {
        let isSameDate = Calendar.current.isDate(lhs.date, inSameDayAs: rhs.date)
        if lhs.id == rhs.id && isSameDate {
            return true
        }
        return false
    }
}
