//
//  EmojiAndColorsCollectionViewDelegate.swift
//  Tracker
//
//  Created by Александр Плешаков on 05.06.2024.
//

import UIKit

protocol EmojiAndColorsCollectionViewDelegate: NSObject {
    func changeSelectedColor(new color: Int?)
    func changeSelectedEmoji(new emoji: Character?)
}
