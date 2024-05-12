//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Александр Плешаков on 08.05.2024.
//

import Foundation

struct TrackerCategory: Equatable {
    let title: String
    let trackers: [Tracker]
    
    static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        lhs.title == rhs.title
    }
}
