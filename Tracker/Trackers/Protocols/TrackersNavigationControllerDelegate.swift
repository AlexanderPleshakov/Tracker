//
//  TrackersNavigationControllerDelegate.swift
//  Tracker
//
//  Created by Александр Плешаков on 09.05.2024.
//

import UIKit

protocol TrackersNavigationControllerDelegate: UIViewController, UISearchResultsUpdating {
    func dateWasChanged(date: Date)
    func addButtonTapped()
}
