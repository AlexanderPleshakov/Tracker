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
    let timetableViewModel: TimetableViewModel
    var categoriesViewModel: CategoriesViewModel
    
    let creationDate: Date?
    let type: TrackerType
    let isEditing: Bool
    let navTitle: String
    var days: String {
        let trackerRecordStore = TrackerRecordStore()
        let count = trackerRecordStore.fetchCount(by: tracker.id)
        
        return String.localizedStringWithFormat(NSLocalizedString("daysCount", comment: ""), count)
    }
    
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
        self.isEditing = false
        self.categoriesViewModel = CategoriesViewModel()
        self.timetableViewModel = TimetableViewModel()
        self.navTitle = (type == .habit) ?
        NSLocalizedString("creation.title.habit", comment: "") :
        NSLocalizedString("creation.title.event", comment: "")
    }
    
    private(set) var oldTitle: String? = nil
    private(set) var oldSelectedColor: Int? = nil
    private(set) var oldSelectedEmoji: Character? = nil
    
    
    init(trackerStore: TrackerStore,
         categoryStore: CategoryStore,
         tracker: Tracker,
         category: TrackerCategory
    ) {
        self.manager = TrackerStoreManager(trackerStore: trackerStore, categoryStore: categoryStore)
        
        self.tracker = tracker
        let isEvent = (tracker.timetable == nil || tracker.timetable == [])
        self.type = isEvent ? .event : .habit
        self.creationDate = tracker.creationDate
        self.isEditing = true
        self.navTitle = (type == .habit) ?
        NSLocalizedString("edit.title.habit", comment: "") :
        NSLocalizedString("edit.title.event", comment: "")
        
        self.oldTitle = tracker.name
        self.oldSelectedColor = tracker.color
        self.oldSelectedEmoji = tracker.emoji
        self.selectedDays = tracker.timetable ?? []

        self.timetableViewModel = TimetableViewModel(selectedDays: tracker.timetable ?? [])
        self.categoriesViewModel = CategoriesViewModel()
        
        initCategory(category: category)
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
    
    private func initCategory(category: TrackerCategory) {
        if manager?.isPinnedTracker(with: tracker.id) ?? false {
            let category = manager?.fetchRealCategory(by: tracker.id)
            self.selectedCategory = category
        } else {
            self.selectedCategory = category
        }
        self.categoriesViewModel = CategoriesViewModel(selectedCategory: selectedCategory)
    }
    
    func addTracker() {
        guard let category = newCategory else {
            return
        }
        manager?.create(tracker: tracker, category: category)
    }
    
    func updateTracker() {
        guard let selectedCategory else { return }
        manager?.update(tracker: tracker, category: selectedCategory)
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
