//
//  HelperTrackersCollectionView.swift
//  Tracker
//
//  Created by Александр Плешаков on 21.05.2024.
//

import UIKit

final class HelperTrackersCollectionView: NSObject  {
    
    var completedTrackers: [TrackerRecord] = []
    var currentDate = Date()
    
    private let trackerStoreManager: TrackerStoreManager
    private let params: GeometricParams
    
    init(trackerStoreManager: TrackerStoreManager, with params: GeometricParams) {
        self.trackerStoreManager = trackerStoreManager
        self.params = params
    }
    
    // MARK: Methods
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        let completedTracker = TrackerRecord(id: id, date: currentDate)
        return completedTrackers.contains(completedTracker)
    }
}

// MARK: TrackersCellDelegate

extension HelperTrackersCollectionView: TrackersCellDelegate {
    func completeTracker(id: UUID) {
        let completedTracker = TrackerRecord(id: id, date: currentDate)
        completedTrackers.append(completedTracker)
    }
    
    func incompleteTracker(id: UUID) {
        completedTrackers.removeAll { trackerRecord in
            let isSameDate = Calendar.current.isDate(trackerRecord.date, inSameDayAs: currentDate)
            return trackerRecord.id == id && isSameDate
        }
    }
}

// MARK: UICollectionViewDataSource

extension HelperTrackersCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackerStoreManager.numberOfRowsInSection(section)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return trackerStoreManager.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackersCollectionViewCell.identifier,
            for: indexPath
        )
        
        guard let cell = cell as? TrackersCollectionViewCell else {
            print("Cell is nil")
            return UICollectionViewCell()
        }

        guard let tracker = trackerStoreManager.object(at: indexPath) else {
            print("tracker is nil in CollectionViewCell")
            return UICollectionViewCell()
        }
        
        let isCompleted = isTrackerCompletedToday(id: tracker.id)
        let completedDays = completedTrackers.filter {
            $0.id == tracker.id
        }.count
        
        cell.delegate = self
        cell.configure(tracker: tracker, isCompleted: isCompleted, completedDays: completedDays, date: currentDate)
        
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension HelperTrackersCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.identifier,
            for: indexPath
        )
        
        guard let view = view as? SectionHeaderView else {
            print("SectionHeaderView is nil")
            return UICollectionReusableView()
        }
        
        if trackerStoreManager.categoryIsEmpty(in: indexPath.section) {
            return view
        } else {
            let categoryName = trackerStoreManager.categoryTitle(in: indexPath.section)
            view.configure(text: categoryName, leadingAnchor: 12)
        }
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if trackerStoreManager.categoryIsEmpty(in: section) {
            return CGSize(width: collectionView.frame.width, height: 0)
        } else {
            return CGSize(width: collectionView.frame.width, height: 19)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if trackerStoreManager.categoryIsEmpty(in: section) {
            return UIEdgeInsets(top: 0, left: params.leftInset, bottom: 0, right: params.rightInset)
        } else {
            return UIEdgeInsets(top: params.topInset, left: params.leftInset, bottom: params.bottomInset, right: params.rightInset)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 132)
    }
}
