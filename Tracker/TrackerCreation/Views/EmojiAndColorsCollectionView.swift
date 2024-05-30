//
//  EmojiAndColorsCollectionView.swift
//  Tracker
//
//  Created by Александр Плешаков on 30.05.2024.
//

import UIKit

final class EmojiAndColorsCollectionView: UICollectionView {
    // MARK: Properties
    
    private let params: GeometricParams
    private let colors = Resources.Colors.Tracker.trackersColors
    private let emojies: [Character] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔"]
    
    // MARK: Init
    
    init(params: GeometricParams) {
        self.params = params
        
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func configure() {
        backgroundColor = Resources.Colors.lightGray
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        
        register(EmojiOrColorCollectionViewCell.self,
                 forCellWithReuseIdentifier: EmojiOrColorCollectionViewCell.reuseIdentifier)
        
        dataSource = self
        delegate = self
    }
}

// MARK: UICollectionViewDataSource

extension EmojiAndColorsCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let isEmojies = numberOfSections == 0
        return isEmojies ? emojies.count : colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(
            withReuseIdentifier: EmojiOrColorCollectionViewCell.reuseIdentifier,
            for: indexPath
        )
        guard let cell = cell as? EmojiOrColorCollectionViewCell else {
            assertionFailure("color or emoji cell is nil")
            return UICollectionViewCell()
        }
        
        if indexPath.section == 0 {
            cell.configure(with: emojies[indexPath.row])
        } else {
            cell.configure(with: colors[indexPath.row])
        }
        
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension EmojiAndColorsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: cellWidth)
    }
}


