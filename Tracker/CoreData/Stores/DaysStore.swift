//
//  DaysStore.swift
//  Tracker
//
//  Created by Александр Плешаков on 07.06.2024.
//

import UIKit
import CoreData

final class DaysStore {
    private let context: NSManagedObjectContext
    private let dataManager = CoreDataManager.shared
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        createDaysIfNeeded()
    }
    
    convenience init() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        self.init(context: context)
    }
    
    private func save() {
        dataManager.saveContext()
    }
    
    private func createDays() {
        let days = Resources.Mocks.weekdays
        days.forEach { day in
            let dayCoreData = DayCoreData(context: context)
            dayCoreData.day = day.rawValue
            
            save()
        }
    }
    
    private func createDaysIfNeeded() {
        let daysRequest = NSFetchRequest<DayCoreData>(entityName: "DayCoreData")
        
        guard let days = try? context.fetch(daysRequest) else {
            createDays()
            return
        }
        
        if days.isEmpty {
            createDays()
        }
    }
    
    func fetchDay(with rawValue: String) -> DayCoreData? {
        let request = NSFetchRequest<DayCoreData>(entityName: "DayCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(DayCoreData.day), rawValue)
        
        guard let days = try? context.fetch(request) else {
            return nil
        }
        
        return days.first
    }
}
