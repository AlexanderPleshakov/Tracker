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
    let count: Int
    
    static func == (lhs: TrackerRecord, rhs: TrackerRecord) -> Bool {
        let isSameDate = Calendar.current.isDate(lhs.date, inSameDayAs: rhs.date)
        if lhs.id == rhs.id && isSameDate {
            return true
        }
        return false
    }
    
    init(id: UUID, date: Date, count: Int) {
        self.id = id
        self.date = date
        self.count = count
    }
    
    init(_ trackerRecordCoreData: TrackerRecordCoreData) {
        guard let id = trackerRecordCoreData.trackerID,
              let date = trackerRecordCoreData.date
        else {
            fatalError("Tracker record data is nil")
        }
        
        self.id = id
        self.date = date
        self.count = Int(trackerRecordCoreData.count)
    }
}
