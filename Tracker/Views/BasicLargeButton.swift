//
//  BasicLargeButton.swift
//  Tracker
//
//  Created by Александр Плешаков on 10.05.2024.
//

import UIKit

final class BasicLargeButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        backgroundColor = Resources.Colors.foreground
        tintColor = Resources.Colors.background
        setTitleColor(Resources.Colors.background, for: .normal)
        layer.cornerRadius = 16
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        setTitle(title, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
