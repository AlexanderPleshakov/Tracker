//
//  NewCategoryStoreManagerDelegate.swift
//  Tracker
//
//  Created by Александр Плешаков on 07.06.2024.
//

import Foundation

protocol NewCategoryStoreManagerDelegate: AnyObject {
    func removeStubAndShowCategories(indexPath: IndexPath)
    func startUpdate()
}
