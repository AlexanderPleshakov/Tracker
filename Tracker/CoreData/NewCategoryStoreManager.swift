//
//  NewCategoryStoreManager.swift
//  Tracker
//
//  Created by Александр Плешаков on 06.06.2024.
//

import UIKit
import CoreData

final class NewCategoryStoreManager: NSObject, NSFetchedResultsControllerDelegate {
    weak var delegate: NewCategoryStoreManagerDelegate?
    private let trackerCategoryStore: TrackerCategoryStore
    
    private var insertedIndex: IndexPath? = nil
    
    private let context = DataManager.shared.persistentContainer.viewContext
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {

        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    init(delegate: CategoriesViewController, trackerCategoryStore: TrackerCategoryStore) {
        self.delegate = delegate
        self.trackerCategoryStore = trackerCategoryStore
    }
    
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> TrackerCategory? {
        let category = fetchedResultsController.object(at: indexPath)
        guard let title = category.title,
              let trackers = category.trackers as? [Tracker]
        else {
            return nil
        }
        return TrackerCategory(title: title, trackers: trackers)
    }
    
    func add(category: TrackerCategory) {
        trackerCategoryStore.add(category)
    }
    
    func fetchAll() -> [TrackerCategory] {
        trackerCategoryStore.fetchAll()
    }
    
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
        delegate?.removeStubAndShowCategories(indexPath: insertedIndex)
        self.insertedIndex = nil
    }
}
