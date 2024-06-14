//
//  NewTrackerViewModel.swift
//  Tracker
//
//  Created by Александр Плешаков on 14.06.2024.
//

import Foundation

final class NewTrackerViewModel {
    private let manager: TrackerStoreManager?
    
    let creationDate: Date
    let type: TrackerType
    
    private(set) var selectedDays: [Day] = []
    private(set) var selectedCategory: TrackerCategory?
    private(set) var newCategory: TrackerCategory? = nil
    
    private var needUnlock: Bool = false {
        didSet {
            needUnlockBinding?(needUnlock)
        }
    }
    
    var trackerBinding: Binding<Tracker>?
    var needUnlockBinding: Binding<Bool>?
    
    private(set) var tracker: Tracker = Tracker(
        id: UUID(),
        name: nil,
        color: nil,
        emoji: nil,
        timetable: nil,
        creationDate: nil
    ) {
        didSet {
            if !tracker.isEmpty(type: type) && selectedCategory != nil {
                newCategory = TrackerCategory(title: selectedCategory!.title,
                                              trackers: selectedCategory!.trackers + [tracker])
                
                needUnlock = true
            } else {
                needUnlock = false
            }
            
            trackerBinding?(tracker)
        }
    }
    
    init(trackerStore: TrackerStore, categoryStore: CategoryStore, type: TrackerType, date: Date) {
        self.manager = TrackerStoreManager(trackerStore: trackerStore, categoryStore: categoryStore)
        self.type = type
        self.creationDate = date
    }
    
    convenience init(type: TrackerType, date: Date) {
        self.init(trackerStore: TrackerStore(),
                  categoryStore: CategoryStore(),
                  type: type,
                  date: date
        )
    }
    
    func changeCategoryTitle(text: String?) {
        if text?.count ?? 0 <= 38 {
            tracker = Tracker(
                id: tracker.id,
                name: text,
                color: tracker.color,
                emoji: tracker.emoji,
                timetable: tracker.timetable,
                creationDate: creationDate)
        } else {
            needUnlock = false
        }
    }
    
    func changeSelectedDays(new days: [Day]) {
        selectedDays = days
        tracker = Tracker(
            id: tracker.id,
            name: tracker.name,
            color: tracker.color,
            emoji: tracker.emoji,
            timetable: days,
            creationDate: creationDate)
    }
    
    func changeSelectedCategory(new category: TrackerCategory?) {
        selectedCategory = category
        tracker = Tracker(
            id: tracker.id,
            name: tracker.name,
            color: tracker.color,
            emoji: tracker.emoji,
            timetable: tracker.timetable,
            creationDate: creationDate)
    }
    
    func changeSelectedColor(new color: Int?) {
        tracker = Tracker(
            id: tracker.id,
            name: tracker.name,
            color: color,
            emoji: tracker.emoji,
            timetable: tracker.timetable,
            creationDate: creationDate)
    }
    
    func changeSelectedEmoji(new emoji: Character?) {
        tracker = Tracker(
            id: tracker.id,
            name: tracker.name,
            color: tracker.color,
            emoji: emoji,
            timetable: tracker.timetable,
            creationDate: creationDate)
    }
}
