//
//  NewTrackerViewModel.swift
//  Tracker
//
//  Created by Александр Плешаков on 14.06.2024.
//

import Foundation

final class NewTrackerViewModel {
    // MARK: Properties
    
    private let manager: TrackerStoreManager?
    let timetableViewModel = TimetableViewModel()
    let categoriesViewModel = CategoriesViewModel()
    
    let creationDate: Date?
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
    
    // MARK: Init
    
    init(trackerStore: TrackerStore, categoryStore: CategoryStore, type: TrackerType, date: Date) {
        self.manager = TrackerStoreManager(trackerStore: trackerStore, categoryStore: categoryStore)
        self.type = type
        self.creationDate = date
    }
    
    init(trackerStore: TrackerStore,
         categoryStore: CategoryStore,
         tracker: Tracker,
         category: TrackerCategory
    ) {
        self.manager = TrackerStoreManager(trackerStore: trackerStore, categoryStore: categoryStore)
        
        self.type = tracker.timetable == nil ? .editEvent : .editHabit
        self.creationDate = tracker.creationDate
        changeTrackerTitle(text: tracker.name)
        
        if self.type == .editHabit {
            changeSelectedDays(new: tracker.timetable ?? [])
        }
        
        changeSelectedCategory(new: category)
        changeSelectedColor(new: tracker.color)
        changeSelectedEmoji(new: tracker.emoji)
    }
    
    convenience init(tracker: Tracker, category: TrackerCategory) {
        self.init(trackerStore: TrackerStore(),
                  categoryStore: CategoryStore(),
                  tracker: tracker,
                  category: category
        )
    }
    
    convenience init(type: TrackerType, date: Date) {
        self.init(trackerStore: TrackerStore(),
                  categoryStore: CategoryStore(),
                  type: type,
                  date: date
        )
    }
    
    // MARK: Methods
    
    func addTracker() {
        guard let category = newCategory else {
            return
        }
        manager?.create(tracker: tracker, category: category)
    }
    
    func changeTrackerTitle(text: String?) {
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
