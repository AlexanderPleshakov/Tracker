//
//  TrackersValueTransformer.swift
//  Tracker
//
//  Created by Александр Плешаков on 05.06.2024.
//

import Foundation

@objc
final class TrackersValueTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass { NSData.self }
    
    override class func allowsReverseTransformation() -> Bool { true }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let trackers = value as? [Tracker] else { return nil }
        return try? JSONEncoder().encode(trackers)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode([Tracker].self, from: data as Data)
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            TrackersValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: TrackersValueTransformer.self))
        )
    }
}
