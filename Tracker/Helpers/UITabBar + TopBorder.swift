//
//  UITabBar + TopBorder.swift
//  Tracker
//
//  Created by Александр Плешаков on 09.06.2024.
//

import UIKit

extension UITabBar {
    func addTopBorder(color: UIColor?, thickness: CGFloat) {
        let subview = UIView()
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.backgroundColor = color
        self.addSubview(subview)
        
        NSLayoutConstraint.activate([
            subview.leftAnchor.constraint(equalTo: self.leftAnchor),
            subview.rightAnchor.constraint(equalTo: self.rightAnchor),
            subview.heightAnchor.constraint(equalToConstant: thickness),
            subview.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
}
