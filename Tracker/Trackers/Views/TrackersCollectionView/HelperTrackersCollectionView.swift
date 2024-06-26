//
//  HelperTrackersCollectionView.swift
//  Tracker
//
//  Created by Александр Плешаков on 21.05.2024.
//

import UIKit

final class HelperTrackersCollectionView: NSObject  {
    
    // MARK: Properties
    
    private var currentDate = Date()
    
    private let trackerStoreManager: TrackerStoreManager
    private let trackerRecordStore = TrackerRecordStore()
    private let params: GeometricParams
    
    weak var delegate: HelperTrackersCollectionViewDelegate?
    private let analyticsService = AnalyticsService()
    
    // MARK: Init
    
    init(trackerStoreManager: TrackerStoreManager, with params: GeometricParams) {
        self.trackerStoreManager = trackerStoreManager
        self.params = params
    }
    
    // MARK: Methods
    
    func changeCurrentDate(date: Date) {
        currentDate = date
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        let completedTracker = trackerRecordStore.fetch(by: id, and: currentDate)
        return completedTracker != nil ? true : false
    }
}

// MARK: TrackersCellDelegate

extension HelperTrackersCollectionView: TrackersCellDelegate {
    func completeTracker(id: UUID) {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "track"])
        let completedTracker = TrackerRecord(id: id, date: currentDate)
        trackerRecordStore.add(trackerRecord: completedTracker)
    }
    
    func incompleteTracker(id: UUID) {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "track"])
        trackerRecordStore.delete(id: id, date: currentDate)
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
        
        guard let isPinned = trackerStoreManager.isPinnedTracker(with: tracker.id) else {
            print("Category of tracker didn't find for check pinned state")
            return UICollectionViewCell()
        }
        
        let isCompleted = isTrackerCompletedToday(id: tracker.id)
        let completedDays = trackerRecordStore.fetchCount(by: tracker.id)
        
        cell.delegate = self
        cell.configure(tracker: tracker, isCompleted: isCompleted, completedDays: completedDays, date: currentDate, isPinned: isPinned)
        
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
            let categoryName = trackerStoreManager.categoryTitle(at: indexPath.section)
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
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
        
        let indexPath = indexPaths[0]
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackersCollectionViewCell else {
            return UIContextMenuConfiguration()
        }
        let pinText = cell.isPinned ?
        NSLocalizedString("unpin", comment: "pin tracker") :
        NSLocalizedString("pin", comment: "pin tracker")
    
        return UIContextMenuConfiguration(previewProvider: { [weak self] in
            self?.createPreviewProvider(for: cell)
        }, actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: pinText) { [weak self] _ in
                    guard let self else { return }
                    if cell.isPinned {
                        cell.unpin()
                        self.trackerStoreManager.unpinTracker(with: cell.trackerId)
                    } else {
                        cell.pin()
                        self.trackerStoreManager.pinTracker(with: cell.trackerId)
                    }
                },
                UIAction(title: NSLocalizedString("edit", comment: "edit tracker")) { [weak self] _ in
                    self?.analyticsService.report(event: "click", params: ["screen": "Main", "item": "edit"])
                    guard let self,
                          let id = cell.trackerId,
                          let tracker = trackerStoreManager.fetchTracker(by: id),
                          let category = trackerStoreManager.fetchCategory(by: id)
                    else { return }
                    
                    self.delegate?.showEditController(for: tracker, with: category)
                },
                UIAction(title: NSLocalizedString("delete", comment: "delete tracker"),
                         attributes: .destructive) { [weak self] _ in
                    guard let self else { return }
                    analyticsService.report(event: "click", params: ["screen": "Main", "item": "delete"])
                             
                    let actionHandler = { [weak self] in
                        guard let id = cell.trackerId, let self else { return }
                        trackerStoreManager.deleteTracker(by: id)
                    }
                    
                    let actionSheet = DeleteActionSheet(
                        title: nil,
                        message: NSLocalizedString("message.delete.tracker",
                                                   comment: "delete message confirmation"),
                        handler: actionHandler
                    )
                    
                    actionSheet.present(on: delegate)
                }
            ])
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        if offsetY > contentHeight - scrollViewHeight - 2 {
            delegate?.hideFiltersButton()
        } else {
            delegate?.showFiltersButton()
        }
    }
    
    private func createPreviewProvider(for cell: TrackersCollectionViewCell) -> UIViewController {
        let visibleView = TrackerColorCellView(
            color: cell.getColor(),
            title: cell.getTitle(),
            emoji: cell.getEmoji(),
            frame: cell.getTrackerViewFrame(),
            isPinned: cell.isPinned
        )
        
        let previewViewController = UIViewController()
        previewViewController.view.frame = CGRect(x: 0, y: 0,
                                                  width: visibleView.bounds.width,
                                                  height: visibleView.bounds.height)
        previewViewController.view.layer.cornerRadius = 0
        previewViewController.view.clipsToBounds = true
        
        visibleView.center = previewViewController.view.center
        previewViewController.view.addSubview(visibleView)
        
        previewViewController.preferredContentSize = CGSize(width: visibleView.frame.width,
                                                            height: visibleView.frame.height)
        
        return previewViewController
    }
}
