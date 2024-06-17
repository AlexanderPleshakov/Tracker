//
//  TrackerRecordCoreData+CoreDataProperties.swift
//  
//
//  Created by Александр Плешаков on 17.06.2024.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension TrackerRecordCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerRecordCoreData> {
        return NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var trackerID: UUID?

}

extension TrackerRecordCoreData : Identifiable {

}
