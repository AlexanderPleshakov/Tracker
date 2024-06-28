//
//  DayCoreData+CoreDataProperties.swift
//  
//
//  Created by Александр Плешаков on 28.06.2024.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension DayCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayCoreData> {
        return NSFetchRequest<DayCoreData>(entityName: "DayCoreData")
    }

    @NSManaged public var day: String?
    @NSManaged public var number: Int16
    @NSManaged public var trackers: NSSet?

}

// MARK: Generated accessors for trackers
extension DayCoreData {

    @objc(addTrackersObject:)
    @NSManaged public func addToTrackers(_ value: TrackerCoreData)

    @objc(removeTrackersObject:)
    @NSManaged public func removeFromTrackers(_ value: TrackerCoreData)

    @objc(addTrackers:)
    @NSManaged public func addToTrackers(_ values: NSSet)

    @objc(removeTrackers:)
    @NSManaged public func removeFromTrackers(_ values: NSSet)

}

extension DayCoreData : Identifiable {

}
