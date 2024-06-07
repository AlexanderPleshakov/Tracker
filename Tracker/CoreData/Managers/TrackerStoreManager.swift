//
//  TrackerStoreManager.swift
//  Tracker
//
//  Created by Александр Плешаков on 07.06.2024.
//

import UIKit
import CoreData

final class TrackerStoreManager: NSObject {
    // MARK: Properties
    
    weak var delegate: TrackerStoreManagerDelegate?
    
    private let trackerStore: TrackerStore
    private let categoryStore: CategoryStore
    
    private let context = CoreDataManager.shared.persistentContainer.viewContext
    private var insertedIndex: IndexPath? = nil
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCoreData.category),
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    // MARK: Init
    
    init(trackerStore: TrackerStore, categoryStore: CategoryStore, delegate: TrackerStoreManagerDelegate) {
        self.trackerStore = trackerStore
        self.categoryStore = categoryStore
        self.delegate = delegate
    }
    
    // MARK: Methods
    
    func create(tracker: Tracker, category: TrackerCategory) {
        trackerStore.create(tracker: tracker, for: category)
    }
    
    func fetchAllCategories() -> [TrackerCategory] {
        categoryStore.fetchAll()
    }
}

// MARK: NSFetchedResultsControllerDelegate

extension TrackerStoreManager: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndex = indexPath
            }
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        guard let insertedIndex = insertedIndex else {
            print("insertedIndex is nil")
            return
        }
        delegate?.addTracker(at: insertedIndex)
        self.insertedIndex = nil
    }
    
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> Tracker? {
        let trackerCoreData = fetchedResultsController.object(at: indexPath)

        return Tracker(coreDataTracker: trackerCoreData)
    }
    
    func categoryIsEmpty(in section: Int) -> Bool {
        let trackerCoreData = fetchedResultsController.object(at: IndexPath(row: 0, section: section))
        guard let count = trackerCoreData.category?.trackers?.count else {
            return true
        }
        
        return count == 0 ? true : false
    }
    
    func categoryTitle(in section: Int) -> String {
        let trackerCoreData = fetchedResultsController.object(at: IndexPath(row: 0, section: section))
        guard let title = trackerCoreData.category?.title else {
            return ""
        }
        
        return title
    }
}
