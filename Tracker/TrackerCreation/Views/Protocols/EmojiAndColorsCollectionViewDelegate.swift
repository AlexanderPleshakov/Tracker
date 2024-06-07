//
//  EmojiAndColorsCollectionViewDelegate.swift
//  Tracker
//
//  Created by Александр Плешаков on 05.06.2024.
//

import UIKit

protocol EmojiAndColorsCollectionViewDelegate: NSObject {
    var selectedColor: Int? { get set }
    var selectedEmoji: Character? { get set }
}
