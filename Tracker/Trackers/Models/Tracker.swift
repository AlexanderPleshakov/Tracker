//
//  Tracker.swift
//  Tracker
//
//  Created by Александр Плешаков on 08.05.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: Character
    let timetable: [Days]
}

enum Days {
    case everyday, weekends
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}
