//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 03.05.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    // MARK: Properties
    
    static var currentDate = Date()
    private var completedTrackers: [TrackerRecord] = []
    private var categories: [TrackerCategory]?
    private var visibleCategories: [TrackerCategory] = []
    
    private var trackerStoreManager: TrackerStoreManager?
    private var sectionCount = 0
    
    // MARK: Views
    
    private var collectionHelper: HelperTrackersCollectionView?
    
    private let trackersCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(TrackersCollectionViewCell.self,
                            forCellWithReuseIdentifier: TrackersCollectionViewCell.identifier)
        collection.register(SectionHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: SectionHeaderView.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = Resources.Colors.white
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        
        return collection
    }()
    
    private let stubView = StubView(text: "Что будем отслеживать?")
    
    // MARK: Init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackerStoreManager = TrackerStoreManager(
            trackerStore: TrackerStore(),
            categoryStore: CategoryStore(),
            delegate: self
        )
        
        categories = fetchCategories()
        
        print(categories ?? [])
        
        guard let trackerStoreManager = trackerStoreManager else {
            return
        }
        sectionCount = trackerStoreManager.numberOfSections
        
        collectionHelper = HelperTrackersCollectionView(
            trackerStoreManager: trackerStoreManager,
            with: GeometricParams(cellCount: 2, topInset: 12,
                                  leftInset: 0, bottomInset: 32,
                                  rightInset: 0, cellSpacing: 9)
        )
        
        configure()
        
        collectionHelper?.completedTrackers = completedTrackers
        
        reloadCollectionWithCurrentWeekday()
    }
    
    // MARK: Methods
    
    private func fetchCategories() -> [TrackerCategory] {
        trackerStoreManager?.fetchAllCategories() ?? []
    }
    
    private func getCurrentWeekday() -> Day {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: TrackersViewController.currentDate)
        let currentWeekday = Day.getDayFromNumber(number: weekday)
        
        return currentWeekday
    }
    
    private func reloadCollection(/*with data: [TrackerCategory]*/) {
        //collectionHelper?.categories = data
        trackersCollection.reloadData()
    }
    
    private func reloadCollectionWithCurrentWeekday() {
        let weekday = getCurrentWeekday()
        let filteredTrackers = searchFilteredTrackers(by: weekday)
        
        visibleCategories = filteredTrackers
        
        reloadCollection()
        setupSubviews()
    }
    
    private func getFilteredTrackers(by day: Day) -> [TrackerCategory] {
        var filteredCategories = [TrackerCategory]()
        for category in categories ?? [] {
            let trackers: [Tracker] = category.trackers.filter {
                if let timetable = $0.timetable {
                    return timetable.contains(day)
                } else {
                    guard let creationDate = $0.creationDate else {
                        assertionFailure("creation date is nil")
                        return false
                    }
                    return Calendar.current.isDate(creationDate, inSameDayAs: TrackersViewController.currentDate)
                }
            }

            let newCategory = TrackerCategory(title: category.title, trackers: trackers)
            filteredCategories.append(newCategory)
        }
        
        return filteredCategories
    }
    
    private func searchFilteredTrackers(by day: Day) -> [TrackerCategory] {
        var filtered = getFilteredTrackers(by: day)
        
        if let searchText = navigationItem.searchController?.searchBar.text, !searchText.isEmpty {
            filtered = filtered.map { category in
                let filteredTrackers = category.trackers.filter { item in
                    guard let name = item.name else { return false }
                    return name.lowercased().contains(searchText.lowercased())
                }
                return TrackerCategory(title: category.title, trackers: filteredTrackers)
            }
        }
        
        return filtered
    }
    
    private func trackersIsEmpty() -> Bool {
        if categories?.isEmpty ?? true {
            return true
        }
        
        var trackersIsEmpty = true
        for category in visibleCategories {
            if !category.trackers.isEmpty {
                trackersIsEmpty = false
            }
        }
        
        return trackersIsEmpty
    }
}

// MARK: NewTrackerViewControllerDelegate

extension TrackersViewController: NewTrackerViewControllerDelegate {
    func addTracker(tracker: Tracker, category: TrackerCategory) {
        trackerStoreManager?.create(tracker: tracker, category: category)
    }
}

// MARK: TrackerStoreManagerDelegate

extension TrackersViewController: TrackerStoreManagerDelegate {
    func addTracker(at indexPath: IndexPath) {
        if stubView.isHidden == false {
            stubView.removeFromSuperview()
            addTrackersCollection()
        }
        
        if indexPath.section >= sectionCount - 1 {
            sectionCount += 1
            trackersCollection.performBatchUpdates {
                trackersCollection.insertSections(IndexSet(integer: indexPath.section))
            }
        } else {
            trackersCollection.performBatchUpdates {
                trackersCollection.insertItems(at: [indexPath])
            }
        }
    }
}

// MARK: TrackersNavigationControllerDelegate

extension TrackersViewController: TrackersNavigationControllerDelegate {
    func dateWasChanged(date: Date) {
        TrackersViewController.currentDate = date
        collectionHelper?.currentDate = date
        
        reloadCollectionWithCurrentWeekday()
    }
    
    func addButtonTapped() {
        let viewController = NewTrackerViewController()
        viewController.delegate = self
        let nav = UINavigationController(rootViewController: viewController)
        present(nav, animated: true)
    }
}

// MARK: UISearchResultsUpdating

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let currentWeekday = getCurrentWeekday()
        var filteredCategories = getFilteredTrackers(by: currentWeekday)
        
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredCategories = filteredCategories.map { category in
                let filteredTrackers = category.trackers.filter { item in
                    guard let name = item.name else { return false }
                    return name.lowercased().contains(searchText.lowercased())
                }
                return TrackerCategory(title: category.title, trackers: filteredTrackers)
            }
        }
        
        reloadCollection()
        setupSubviews()
        //reloadCollectionWithCurrentWeekday()
    }
}

// MARK: UI configuration

extension TrackersViewController {
    private func configure() {
        view.backgroundColor = Resources.Colors.white
        
        trackersCollection.dataSource = collectionHelper
        trackersCollection.delegate = collectionHelper
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        if trackersIsEmpty() {
            if trackersCollection.isDescendant(of: view) {
                trackersCollection.removeFromSuperview()
            }
            addStubView()
        } else {
            addTrackersCollection()
        }
    }
    
    private func addTrackersCollection() {
        view.addSubview(trackersCollection)
        
        NSLayoutConstraint.activate([
            trackersCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackersCollection.topAnchor.constraint(equalTo: view.topAnchor),
            trackersCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func addStubView() {
        view.addSubview(stubView)
        
        NSLayoutConstraint.activate([
            stubView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stubView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stubView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stubView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
}
