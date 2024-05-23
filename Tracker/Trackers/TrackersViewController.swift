//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 03.05.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    // MARK: Properties
    
    static var categories: [TrackerCategory] = [
        TrackerCategory(title: "Важное", trackers: [
            Tracker(id: UUID(), name: "Поливать растения", color: Resources.Colors.Tracker.trackersColors[Int.random(in: 0..<18)], emoji: "❤️", timetable: [.monday, .wednesday]),
            Tracker(id: UUID(), name: "Кошка заслонила камеру на созвоне", color: Resources.Colors.Tracker.trackersColors[Int.random(in: 0..<18)], emoji: "👻", timetable: [.tuesday]),
            Tracker(id: UUID(), name: "Бабушка прислала открытку в вотсапе", color: Resources.Colors.Tracker.trackersColors[Int.random(in: 0..<18)], emoji: "☺️", timetable: [.wednesday])]),
        TrackerCategory(title: "Радостные мелочи", trackers: [
            Tracker(id: UUID(), name: "Свидания в апреле", color: Resources.Colors.Tracker.trackersColors[Int.random(in: 0..<18)], emoji: "😂", timetable: [.thursday, .tuesday]),
            Tracker(id: UUID(), name: "Хорошее настроение", color: Resources.Colors.Tracker.trackersColors[Int.random(in: 0..<18)], emoji: "💕", timetable: [.friday, .wednesday]),
            Tracker(id: UUID(), name: "Легкая тревожность", color: Resources.Colors.Tracker.trackersColors[Int.random(in: 0..<18)], emoji: "🙃", timetable: [.sunday])])
    ]
    var visibleCategories: [TrackerCategory] = []
    
    var completedTrackers: [TrackerRecord] = []
    var currentDate = Date()
    
    // MARK: Views
    
    private let collectionHelper = HelperTrackersCollectionView(categories: TrackersViewController.categories,
                                                                with: GeometricParams(cellCount: 2, topInset: 12,
                                                                                      leftInset: 0, bottomInset: 32,
                                                                                      rightInset: 0, cellSpacing: 9))
    
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
        
        configure()
        
        collectionHelper.completedTrackers = completedTrackers
        let currentWeekday = getCurrentWeekday()
        filterTrackers(by: currentWeekday)
    }
    
    // MARK: Methods
    
    private func getCurrentWeekday() -> Day {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: currentDate)
        let currentWeekday = Day.getDayFromNumber(number: weekday)
        
        return currentWeekday
    }
    
    private func reloadCollection(with data: [TrackerCategory]) {
        collectionHelper.categories = data
        trackersCollection.reloadData()
    }
    
    func addTracker() {
        if stubView.isHidden == false {
            stubView.removeFromSuperview()
            addTrackersCollection()
        }
        reloadCollection(with: TrackersViewController.categories)
    }
    
    private func getFilteredTrackers(by day: Day) -> [TrackerCategory] {
        var filteredCategories = [TrackerCategory]()
        for category in TrackersViewController.categories {
            var trackers: [Tracker] = []
            for tracker in category.trackers {
                if let timetable = tracker.timetable {
                    if timetable.contains(day) {
                        trackers.append(tracker)
                    }
                }
            }
            let newCategory = TrackerCategory(title: category.title, trackers: trackers)
            filteredCategories.append(newCategory)
        }
        
        return filteredCategories
    }
    
    private func filterTrackers(by day: Day) {
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
        
        reloadCollection(with: filtered)
        setupSubviews()
    }
    
    private func trackersIsEmpty() -> Bool {
        if TrackersViewController.categories.isEmpty {
            return true
        }
        
        var trackersIsEmpty = true
        for category in collectionHelper.categories {
            if !category.trackers.isEmpty {
                trackersIsEmpty = false
            }
        }
        
        return trackersIsEmpty
    }
}

// MARK: TrackersNavigationControllerDelegate

extension TrackersViewController: TrackersNavigationControllerDelegate {
    func dateWasChanged(date: Date) {
        currentDate = date
        collectionHelper.currentDate = date
        
        let currentWeekday = getCurrentWeekday()
        filterTrackers(by: currentWeekday)
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
        
        reloadCollection(with: filteredCategories)
        setupSubviews()
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
