//
//  GeometricParams.swift
//  Tracker
//
//  Created by Александр Плешаков on 21.05.2024.
//

import Foundation

struct GeometricParams {
    let cellCount: Int
    let topInset: CGFloat
    let leftInset: CGFloat
    let bottomInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat
    
    init(cellCount: Int, topInset: CGFloat, leftInset: CGFloat, bottomInset: CGFloat, rightInset: CGFloat, cellSpacing: CGFloat) {
        self.cellCount = cellCount
        self.topInset = topInset
        self.leftInset = leftInset
        self.bottomInset = bottomInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
}
