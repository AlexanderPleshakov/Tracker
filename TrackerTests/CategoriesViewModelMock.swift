//
//  CategoriesViewModelStub.swift
//  TrackerTests
//
//  Created by Александр Плешаков on 17.06.2024.
//

@testable import Tracker
import Foundation

final class CategoriesViewModelMock: NewCategoryStoreManagerDelegate, CategoriesViewModelProtocol {
    
    private let manager: CategoryStoreManager
    private(set) var selectedCategory: TrackerCategory? = nil {
        didSet {
            selectedCategoryBinding?(selectedCategory)
        }
    }
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            categoriesBinding?(categories)
        }
    }
    
    var categoriesBinding: Binding<[TrackerCategory]>?
    var selectedCategoryBinding: Binding<TrackerCategory?>?
    
    // MARK: Init
    
    init(categoryStore: CategoryStore) {
        
        let manager = CategoryStoreManager(categoryStore: categoryStore)
        
        self.manager = manager
        manager.delegate = self
        self.categories = fetchCategories()
    }
    
    convenience init() {
        self.init(categoryStore: CategoryStore())
    }
    
    // MARK: Methods
    private func fetchCategories() -> [TrackerCategory] {
        [
            TrackerCategory(title: "Category 1", trackers: []),
            TrackerCategory(title: "Category 2", trackers: []),
        ]
    }
    
    func addCategory(category: TrackerCategory) {
        manager.create(category: category)
    }
    
    func didSelect(_ category: TrackerCategory) {
        selectedCategory = category
    }
    
    func didDeselect() {
        selectedCategory = nil
    }
    
    func insert(_ category: TrackerCategory, at indexPath: IndexPath) {
        categories.insert(category, at: indexPath.row)
    }
}

