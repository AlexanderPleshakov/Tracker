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
    private let daysStore: DaysStore
    
    private let context = CoreDataManager.shared.persistentContainer.viewContext
    private var index: IndexPath? = nil
    private var actionType: TrackerCellAction? = nil
    
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    
    // MARK: Init
    
    init(trackerStore: TrackerStore, categoryStore: CategoryStore) {
        self.trackerStore = trackerStore
        self.categoryStore = categoryStore
        self.daysStore = DaysStore()
    }
    
    // MARK: Methods
    
    func create(tracker: Tracker, category: TrackerCategory) {
        trackerStore.create(tracker: tracker, for: category)
    }
    
    func fetchAllCategories() -> [TrackerCategory] {
        categoryStore.fetchAll()
    }
    
    func trackersIsEmpty() -> Bool {
        fetchedResultsController.fetchedObjects?.isEmpty ?? true
    }
    
    func deleteTracker(by id: UUID) {
        trackerStore.deleteTracker(by: id)
    }
    
    func fetchTracker(by id: UUID) -> Tracker? {
        trackerStore.fetchTracker(by: id)
    }
    
    func fetchCategory(by trackerId: UUID) -> TrackerCategory? {
        trackerStore.fetchCategory(by: trackerId)
    }
    
    func update(tracker: Tracker, category: TrackerCategory) {
        trackerStore.update(tracker: tracker, category: category)
    }
    
    func setupFetchedResultsController(with day: Day, and text: String?, date: Date) {
        fetchedResultsController = {
            let fetchRequest = createFetchRequest(with: day, and: text, date: date)
            
            let fetchedResultsController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: #keyPath(TrackerCoreData.category.title),
                cacheName: nil
            )
            
            fetchedResultsController.delegate = self

            do {
                try fetchedResultsController.performFetch()
            } catch {
                print("Cannot do performFetch for fetchedResultsController")
            }
            
            return fetchedResultsController
        }()
    }
    
    private func createFetchRequest(with day: Day, and text: String?, date: Date) -> NSFetchRequest<TrackerCoreData> {
        guard let day = daysStore.fetchDay(with: Day.shortName(by: day.rawValue)) else {
            fatalError("Неправильно передан день в setupFetchedResultsController")
        }
        
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(TrackerCoreData.category.title), ascending: false)]
        
        let dayPredicate = NSPredicate(format: "ANY schedule == %@", day)
        let countDaysPredicate = NSPredicate(format: "schedule.@count == 0")
        let strippedTargetDate = stripTime(from: date) ?? Date()
        let datePredicate = NSPredicate(format: "creationDate >= %@ AND creationDate < %@",
                                        strippedTargetDate as CVarArg,
                                        Calendar.current.date(
                                            byAdding: .day,
                                            value: 1,
                                            to: strippedTargetDate)! as CVarArg)
        let compoundEventPredicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [datePredicate, countDaysPredicate]
        )
        
        if text == nil {
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [compoundEventPredicate, dayPredicate])
            fetchRequest.predicate = compoundPredicate
        } else {
            let searchPredicate = NSPredicate(format: "name CONTAINS[c] %@", text ?? "")
            
            let compoundFilterPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [dayPredicate, searchPredicate])
            let compoundSearchEventPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [compoundEventPredicate, searchPredicate])
            
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [compoundSearchEventPredicate, compoundFilterPredicate])
            
            fetchRequest.predicate = compoundPredicate
        }
        
        return fetchRequest
    }
    
    private func stripTime(from date: Date) -> Date? {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: date))
    }
}

// MARK: NSFetchedResultsControllerDelegate

extension TrackerStoreManager: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                index = indexPath
                actionType = .insert
            }
        case .delete:
            if let indexPath = indexPath {
                index = indexPath
                actionType = .delete
            }
        case .update:
            if let indexPath = newIndexPath {
                index = indexPath
            }
            actionType = .update
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        guard let index, let actionType else {
            print("""
                  index or actionType is nil,
                  index = \(String(describing: index)),
                  type = \(String(describing: actionType))
                  """)
            delegate?.forceReload()
            return
        }
        
        switch actionType {
        case .insert:
            delegate?.addTracker(at: index)
        case .update:
            delegate?.updateTracker(at: index)
        case .delete:
            delegate?.deleteTracker(at: index)
        }
        
        self.actionType = nil
        self.index = nil
    }
    
    var numberOfSections: Int {
        return fetchedResultsController.sections?.count ?? 0
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

// MARK: TrackerCellAction

extension TrackerStoreManager {
    enum TrackerCellAction {
        case insert, delete, update
    }
}
