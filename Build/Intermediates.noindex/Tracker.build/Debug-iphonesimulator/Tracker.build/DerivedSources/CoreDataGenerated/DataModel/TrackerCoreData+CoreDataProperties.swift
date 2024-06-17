//
//  TrackerCoreData+CoreDataProperties.swift
//  
//
//  Created by Александр Плешаков on 17.06.2024.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension TrackerCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerCoreData> {
        return NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
    }

    @NSManaged public var color: Int32
    @NSManaged public var creationDate: Date?
    @NSManaged public var emoji: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var category: CategoryCoreData?
    @NSManaged public var schedule: NSSet?

}

// MARK: Generated accessors for schedule
extension TrackerCoreData {

    @objc(addScheduleObject:)
    @NSManaged public func addToSchedule(_ value: DayCoreData)

    @objc(removeScheduleObject:)
    @NSManaged public func removeFromSchedule(_ value: DayCoreData)

    @objc(addSchedule:)
    @NSManaged public func addToSchedule(_ values: NSSet)

    @objc(removeSchedule:)
    @NSManaged public func removeFromSchedule(_ values: NSSet)

}

extension TrackerCoreData : Identifiable {

}
