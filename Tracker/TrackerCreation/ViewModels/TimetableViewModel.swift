//
//  TimetableViewModel.swift
//  Tracker
//
//  Created by Александр Плешаков on 14.06.2024.
//

import Foundation

final class TimetableViewModel {
    let allDays: [Day] = Resources.Mocks.weekdays
    let days = Resources.Mocks.weekdaysStrings
    private(set) var selectedDays: Set<Day> = [] {
        didSet {
            selectedDaysBinding?(selectedDays)
        }
    }
    var selectedDaysArray: [Day] {
        get {
            getArraySelectedDays()
        }
    }
    
    var selectedDaysBinding: Binding<Set<Day>>?
    
    func add(_ day: Day) {
        selectedDays.insert(day)
    }
    
    func remove(_ day: Day) {
        selectedDays.remove(day)
    }
    
    private func getArraySelectedDays() -> [Day] {
        var daysArray = [Day]()
        for day in allDays {
            if selectedDays.contains(day) {
                daysArray.append(day)
            }
        }
        
        return daysArray
    }
}
