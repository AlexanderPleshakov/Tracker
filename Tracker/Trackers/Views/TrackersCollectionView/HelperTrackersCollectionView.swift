//
//  HelperTrackersCollectionView.swift
//  Tracker
//
//  Created by Александр Плешаков on 21.05.2024.
//

import UIKit

final class HelperTrackersCollectionView: NSObject  {
    var categories: [TrackerCategory]
    private let params: GeometricParams
    
    init(categories: [TrackerCategory], with params: GeometricParams) {
        self.categories = categories
        self.params = params
    }
}

// MARK: UICollectionViewDataSource

extension HelperTrackersCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count", categories[section].trackers.count)
        return categories[section].trackers.count
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

// MARK: UICollectionViewDelegateFlowLayout

extension HelperTrackersCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: params.leftInset, bottom: 0, right: params.rightInset)
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
