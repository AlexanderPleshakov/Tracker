//
//  StubView.swift
//  Tracker
//
//  Created by Александр Плешаков on 09.05.2024.
//

import UIKit

final class StubView: UIView {
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private let stubLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = Resources.Colors.black
        label.text = "Что будем отслеживать?"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let stubImage: UIImageView = {
        let imageView = UIImageView(image: Resources.Images.stubTrackersImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(stubImage)
        vStack.addArrangedSubview(stubLabel)
        
        addSubview(vStack)
        
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            vStack.topAnchor.constraint(equalTo: topAnchor),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stubImage.heightAnchor.constraint(equalToConstant: 80),
            stubImage.widthAnchor.constraint(equalToConstant: 80),
            
            stubLabel.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
            stubLabel.trailingAnchor.constraint(equalTo: vStack.trailingAnchor)
        ])
    }
}
