//
//  EmojiOrColorsCollectionView.swift
//  Tracker
//
//  Created by Александр Плешаков on 30.05.2024.
//

import UIKit

final class EmojiOrColorsCollectionView: UICollectionView {
    
    init(type: CollectionType) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = Resources.Colors.lightGray
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
    }
}
