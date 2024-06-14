//
//  CategoryCoreData+CoreDataProperties.swift
//  
//
//  Created by Александр Плешаков on 14.06.2024.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension CategoryCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryCoreData> {
        return NSFetchRequest<CategoryCoreData>(entityName: "CategoryCoreData")
    }

    @NSManaged public var title: String?
    @NSManaged public var trackers: NSSet?

}

// MARK: Generated accessors for trackers
extension CategoryCoreData {

    @objc(addTrackersObject:)
    @NSManaged public func addToTrackers(_ value: TrackerCoreData)

    @objc(removeTrackersObject:)
    @NSManaged public func removeFromTrackers(_ value: TrackerCoreData)

    @objc(addTrackers:)
    @NSManaged public func addToTrackers(_ values: NSSet)

    @objc(removeTrackers:)
    @NSManaged public func removeFromTrackers(_ values: NSSet)

}

extension CategoryCoreData : Identifiable {

}
