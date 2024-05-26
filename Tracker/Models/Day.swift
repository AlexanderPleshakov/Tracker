//
//  Days.swift
//  Tracker
//
//  Created by Александр Плешаков on 11.05.2024.
//

import Foundation

enum Day: String {
    case monday = "Пн"
    case tuesday = "Вт"
    case wednesday = "Ср"
    case thursday = "Чт"
    case friday = "Пт"
    case saturday = "Сб"
    case sunday = "Вс"
    
    static func getDayFromNumber(number: Int) -> Day {
        let days = [Day.sunday, Day.monday, Day.tuesday, Day.wednesday, Day.thursday, Day.friday, Day.saturday]
        
        return days[number - 1]
    }
}
