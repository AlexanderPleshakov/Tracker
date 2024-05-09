//
//  DatePickerView.swift
//  Tracker
//
//  Created by Александр Плешаков on 06.05.2024.
//

import UIKit

final class DatePickerView: UIView {
    // MARK: Properties
    
    private var date: String
    
    // MARK: Init
    
    init(date: String) {
        self.date = date
        
        super.init(frame: CGRect(x: 0, y: 0, width: 77, height: 34))
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func configure() {
        self.backgroundColor = Resources.Colors.lightGray
        self.layer.cornerRadius = 8
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 77, height: 34))
        label.text = date
        label.textColor = Resources.Colors.black
        label.textAlignment = .center
        addSubview(label)
        print(date)
    }
}
