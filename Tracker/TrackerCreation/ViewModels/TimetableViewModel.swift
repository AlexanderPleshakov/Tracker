//
//  TimetableViewModel.swift
//  Tracker
//
//  Created by Александр Плешаков on 14.06.2024.
//

import Foundation

final class TimetableViewModel {
    // MARK: Properties
    
    let allDays: [Day] = Resources.Mocks.weekdays
    let days = Resources.Mocks.weekdaysStrings
    private(set) var selectedDays: Set<Day> = [] {
        didSet {
            selectedDaysBinding?(selectedDaysString)
        }
    }
    var selectedDaysArray: [Day] {
        get {
            return getArraySelectedDays()
        }
    }
    
    var selectedDaysString: String {
        get {
            getDaysString(days: selectedDaysArray)
        }
    }
    
    var selectedDaysBinding: Binding<String>?
    
    // MARK: Init
    
    init(selectedDays: [Day] = []) {
        self.selectedDays = Set(selectedDays)
    }
    
    // MARK: Methods
    
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
    
    private func getDaysString(days: [Day]) -> String {
        var text: String
        if days.count == 7 {
            text = NSLocalizedString("everyDay", comment: "")
            return text
        }
        
        let values = days.map { Day.shortName(by: $0.rawValue) }
        
        text = values.joined(separator: ", ")
        return text
    }
}
