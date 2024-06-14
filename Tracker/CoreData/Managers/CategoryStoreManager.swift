//
//  CategoryStoreManager.swift
//  Tracker
//
//  Created by Александр Плешаков on 07.06.2024.
//

import UIKit
import CoreData

final class CategoryStoreManager: NSObject {
    // MARK: Properties
    
    weak var delegate: NewCategoryStoreManagerDelegate?
    
    private let categoryStore: CategoryStore
    private let context = CoreDataManager.shared.persistentContainer.viewContext
    private var insertedIndex: IndexPath? = nil
    
    private var fetchedResultsController: NSFetchedResultsController<CategoryCoreData>!
    
    // MARK: Init
    
    init(categoryStore: CategoryStore) {
        self.categoryStore = categoryStore
        super.init()
        
        createFetchedController()
    }
    
    // MARK: Methods
    private func createFetchedController() {
        let fetchRequest = NSFetchRequest<CategoryCoreData>(entityName: "CategoryCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Cannot do performFetch for fetchedResultsController")
        }
    }
    
    func create(category: TrackerCategory) {
        categoryStore.create(category: category)
    }
    
    func fetchAll() -> [TrackerCategory] {
        categoryStore.fetchAll()
    }
}

// MARK: NSFetchedResultsControllerDelegate

extension CategoryStoreManager: NSFetchedResultsControllerDelegate {
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
        
        if let category = object(at: insertedIndex) {
            delegate?.insert(category, at: insertedIndex)
        }
        
        self.insertedIndex = nil
    }
    
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> TrackerCategory? {
        let category = fetchedResultsController.object(at: indexPath)
        guard let title = category.title,
              let trackersCoreData = category.trackers?.allObjects as? [TrackerCoreData]
        else {
            return nil
        }
        
        let trackers = trackersCoreData.map { Tracker(coreDataTracker: $0) }
        
        return TrackerCategory(title: title, trackers: trackers)
    }
}
