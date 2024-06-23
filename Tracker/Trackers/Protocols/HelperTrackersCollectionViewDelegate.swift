//
//  HelperTrackersCollectionViewDelegate.swift
//  Tracker
//
//  Created by Александр Плешаков on 22.06.2024.
//

import UIKit

protocol HelperTrackersCollectionViewDelegate: AnyObject, UIViewController {
    func showEditController(for tracker: Tracker, with category: TrackerCategory)
}
