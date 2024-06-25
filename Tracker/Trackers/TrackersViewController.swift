//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 03.05.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    // MARK: Properties
    
    private var currentDate = Date()
    private var trackerStoreManager: TrackerStoreManager?
    private var searchText: String? = nil
    private var lastNumberOfSections = 0
    
    // MARK: Views
    
    private var collectionHelper: HelperTrackersCollectionView?
    
    private let emptyView = UIView()
    
    private let trackersCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collection.register(
            TrackersCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackersCollectionViewCell.identifier
        )
        collection.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.identifier
        )
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = Resources.Colors.background
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.clipsToBounds = false
        
        return collection
    }()
    
    private let filtersButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Resources.Colors.blue
        button.tintColor = Resources.Colors.alwaysWhite
        button.setTitleColor(Resources.Colors.alwaysWhite, for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitle("Filters", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let stubView = StubView(text: NSLocalizedString("stub.trackers", comment: "Stub for empty trackers"))
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollection()
        
        configure()
        reloadCollectionAndSetup()
    }
    
    // MARK: Methods
    
    private func setupCollection() {
        trackerStoreManager = TrackerStoreManager(
            trackerStore: TrackerStore(),
            categoryStore: CategoryStore()
        )
        trackerStoreManager?.delegate = self
        
        trackerStoreManager?.setupFetchedResultsController(
            with: getCurrentWeekday(),
            and: searchText,
            date: currentDate
        )
        
        guard let trackerStoreManager = trackerStoreManager else {
            return
        }
        
        collectionHelper = HelperTrackersCollectionView(
            trackerStoreManager: trackerStoreManager,
            with: GeometricParams(cellCount: 2, topInset: 12,
                                  leftInset: 0, bottomInset: 32,
                                  rightInset: 0, cellSpacing: 9)
        )
        collectionHelper?.delegate = self
        lastNumberOfSections = trackerStoreManager.numberOfSections
    }
    
    private func fetchCategories() -> [TrackerCategory] {
        trackerStoreManager?.fetchAllCategories() ?? []
    }
    
    private func getCurrentWeekday() -> Day {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: currentDate)
        let currentWeekday = Day.getDayFromNumber(number: weekday)
        
        return currentWeekday
    }
    
    private func reloadCollectionAndSetup() {
        guard let trackerStoreManager else { return }
        trackersCollection.reloadData()
        setupSubviews()
        lastNumberOfSections = trackerStoreManager.numberOfSections
    }
    
    private func trackersIsEmpty() -> Bool {
        trackerStoreManager?.trackersIsEmpty() ?? true
    }
}

// MARK: HelperTrackersCollectionViewDelegate

extension TrackersViewController: HelperTrackersCollectionViewDelegate {
    func showEditController(for tracker: Tracker, with category: TrackerCategory) {
        
        let editViewModel = NewTrackerViewModel(tracker: tracker, category: category)
        let editViewController = HabitOrEventViewController(viewModel: editViewModel)
        let editNavController = UINavigationController(rootViewController: editViewController)
        
        present(editNavController, animated: true)
    }
    
    func hideFiltersButton() {
        filtersButton.isHidden = true
    }
    
    func showFiltersButton() {
        filtersButton.isHidden = false
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
        
        trackersCollection.reloadData()
    }
    
    func updateTracker(at indexPath: IndexPath) {
        trackersCollection.reloadData()
    }
    
    func deleteTracker(at indexPath: IndexPath) {
        guard let trackerStoreManager else { return }
        if trackersIsEmpty() {
            trackersCollection.performBatchUpdates({
                trackersCollection.deleteSections(IndexSet(integer: indexPath.section))
            }, completion: { [weak self] _ in
                self?.addStubAndRemoveCollection()
            })
        } else {
            trackersCollection.performBatchUpdates({
                
                if trackerStoreManager.numberOfSections != lastNumberOfSections {
                    trackersCollection.deleteSections(IndexSet(integer: indexPath.section))
                } else {
                    trackersCollection.deleteItems(at: [indexPath])
                }
            }, completion: nil)
        }
    }
    
    func forceReload() {
        trackersCollection.reloadData()
    }
}

// MARK: TrackersNavigationControllerDelegate

extension TrackersViewController: TrackersNavigationControllerDelegate {
    func dateWasChanged(date: Date) {
        currentDate = date
        collectionHelper?.changeCurrentDate(date: date)
        trackerStoreManager?.setupFetchedResultsController(
            with: getCurrentWeekday(),
            and: searchText,
            date: currentDate
        )
        
        reloadCollectionAndSetup()
    }
    
    func addButtonTapped() {
        let viewController = NewTrackerViewController(currentDate: currentDate)
        viewController.delegate = self
        let nav = UINavigationController(rootViewController: viewController)
        present(nav, animated: true)
    }
}

// MARK: UISearchResultsUpdating

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            self.searchText = searchText
        } else {
            self.searchText = nil
        }
        
        trackerStoreManager?.setupFetchedResultsController(
            with: getCurrentWeekday(),
            and: searchText,
            date: currentDate
        )
        reloadCollectionAndSetup()
    }
}

// MARK: UI configuration

extension TrackersViewController {
    private func configure() {
        view.backgroundColor = Resources.Colors.background
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        trackersCollection.dataSource = collectionHelper
        trackersCollection.delegate = collectionHelper
        
        addEmptyView()
        setupSubviews()
        setFiltersButton()
    }
    
    private func setupSubviews() {
        if trackersIsEmpty() {
            addStubAndRemoveCollection()
        } else {
            addTrackersCollection()
        }
    }
    
    private func addEmptyView() {
        view.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: 0),
        ])
    }
    
    private func addStubAndRemoveCollection() {
        if trackersCollection.isDescendant(of: view) {
            trackersCollection.removeFromSuperview()
        }
        addStubView()
        view.bringSubviewToFront(filtersButton)
    }
    
    private func addTrackersCollection() {
        view.addSubview(trackersCollection)
        
        NSLayoutConstraint.activate([
            trackersCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackersCollection.topAnchor.constraint(equalTo: view.topAnchor),
            trackersCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        view.bringSubviewToFront(filtersButton)
    }
    
    private func setFiltersButton() {
        view.addSubview(filtersButton)
        
        NSLayoutConstraint.activate([
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.widthAnchor.constraint(equalToConstant: 114),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
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
