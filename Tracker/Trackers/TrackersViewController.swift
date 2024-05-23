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
            Tracker(id: 1, name: "Поливать растения", color: .red, emoji: "❤️", timetable: [.monday, .wednesday]),
            Tracker(id: 2, name: "Кошка заслонила камеру на созвоне", color: .blue, emoji: "👻", timetable: [.tuesday]),
            Tracker(id: 3, name: "Бабушка прислала открытку в вотсапе", color: .cyan, emoji: "☺️", timetable: [.wednesday])]),
        TrackerCategory(title: "Радостные мелочи", trackers: [
            Tracker(id: 4, name: "Свидания в апреле", color: .systemPink, emoji: "😂", timetable: [.thursday, .tuesday]),
            Tracker(id: 5, name: "Хорошее настроение", color: .orange, emoji: "💕", timetable: [.friday, .wednesday]),
            Tracker(id: 6, name: "Легкая тревожность", color: .purple, emoji: "🙃", timetable: [.sunday])])
    ] {
        willSet(newValue) {
            print(newValue)
        }
    }
    
    var currentDate: Date = Date()
    var completedTrackers: [TrackerRecord] = []
    private let collectionHelper = HelperTrackersCollectionView(categories: TrackersViewController.categories,
                                                                with: GeometricParams(cellCount: 2, topInset: 12, leftInset: 0, bottomInset: 32, rightInset: 0, cellSpacing: 9))
    
    // MARK: Views
    
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
    }
    
    // MARK: Methods
    
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
    
    private func filterTrackers(by day: Day) {
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
        reloadCollection(with: filteredCategories)
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
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let currentDay = Day.getDayFromNumber(number: weekday)
        filterTrackers(by: currentDay)
        print(currentDay)
    }
    
    func addButtonTapped() {
        let viewController = NewTrackerViewController()
        viewController.delegate = self
        let nav = UINavigationController(rootViewController: viewController)
        present(nav, animated: true)
    }
}

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        var filteredCategories = [TrackerCategory]()
        
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            for category in TrackersViewController.categories {
                var filteredTrackers: [Tracker] = []
                for tracker in category.trackers {
                    filteredTrackers = category.trackers.filter { item in
                        guard let name = item.name else { return false }
                        return name.lowercased().contains(searchText.lowercased())
                    }
                }
                let newCategory = TrackerCategory(title: category.title, trackers: filteredTrackers)
                filteredCategories.append(newCategory)
            }
        } else {
            filteredCategories = TrackersViewController.categories
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
            trackersCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            trackersCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
