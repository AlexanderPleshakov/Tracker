//
//  NewTrackerViewModel.swift
//  Tracker
//
//  Created by Александр Плешаков on 14.06.2024.
//

import Foundation

final class NewTrackerViewModel {
    private let manager: TrackerStoreManager?
    
    init(trackerStore: TrackerStore, categoryStore: CategoryStore) {
        self.manager = TrackerStoreManager(trackerStore: trackerStore, categoryStore: categoryStore)
    }
    
    convenience init() {
        self.init(trackerStore: TrackerStore(), categoryStore: CategoryStore())
    }
}
