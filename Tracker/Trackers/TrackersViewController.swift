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
            Tracker(id: 1, name: "name", color: .red, emoji: "r", timetable: [.friday]),
            Tracker(id: 1, name: "Кошка заслонила камеру на созвоне", color: .red, emoji: "r", timetable: [.friday]),
            Tracker(id: 1, name: "Кошка заслонила камеру на созвоне", color: .red, emoji: "r", timetable: [.friday])])
    ] {
        willSet(newValue) {
            print(newValue)
        }
    }
    
    var completedTrackers: [TrackerRecord] = []
    private let collectionHelper = HelperTrackersCollectionView(categories: TrackersViewController.categories,
                                                                with: GeometricParams(cellCount: 2, leftInset: 0, rightInset: 0, cellSpacing: 9))
    
    // MARK: Views
    
    private let trackersCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(TrackersCollectionViewCell.self,
                            forCellWithReuseIdentifier: TrackersCollectionViewCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        return collection
    }()
    private let stubView = StubView(text: "Что будем отслеживать?")
    
    // MARK: Init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: Methods
    
    
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count")
        return TrackersViewController.categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("data source")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCollectionViewCell.identifier, for: indexPath)
        guard let cell = cell as? TrackersCollectionViewCell else {
            print("Cell is nil")
            return UICollectionViewCell()
        }
        
        return cell
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
        addTrackersCollection()
//        addStubView()
    }
    
    private func addTrackersCollection() {
        view.addSubview(trackersCollection)
        
        NSLayoutConstraint.activate([
            trackersCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackersCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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

extension TrackersViewController: TrackersNavigationControllerDelegate {
    func dateWasChanged(date: Date) {
        let selectedDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy" // Формат даты
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    func addButtonTapped() {
        let viewController = NewTrackerViewController()
        let nav = UINavigationController(rootViewController: viewController)
        present(nav, animated: true)
    }
}
