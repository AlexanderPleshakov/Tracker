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
    
    private lazy var fetchedResultsController: NSFetchedResultsController<CategoryCoreData> = {
        
        let fetchRequest = NSFetchRequest<CategoryCoreData>(entityName: "CategoryCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    // MARK: Init
    
    init(categoryStore: CategoryStore, delegate: NewCategoryStoreManagerDelegate) {
        self.categoryStore = categoryStore
        self.delegate = delegate
    }
    
    // MARK: Methods
    
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
        delegate?.removeStubAndShowCategories(indexPath: insertedIndex)
        self.insertedIndex = nil
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
              let trackersCoreData = category.trackers?.allObjects as? [TrackerCoreData]
        else {
            return nil
        }
        
        let trackers = trackersCoreData.map {
            Tracker(coreDataTracker: $0)
//            guard let id = $0.id,
//                  let name = $0.name,
//                  let emoji = $0.emoji?.first,
//                  let creationDate = $0.creationDate
//            else {
//                fatalError("Some property is nil in Tracker")
//            }
//            
//            let schedule = $0.timetable?.map {
//                Day(rawValue: $0) ?? .monday
//            }
//            
//            return Tracker(id: id,
//                           name: name,
//                           color: Int($0.color),
//                           emoji: emoji,
//                           timetable: schedule,
//                           creationDate: creationDate)
        }
        
        return TrackerCategory(title: title, trackers: trackers)
    }
}