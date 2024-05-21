//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by Александр Плешаков on 21.05.2024.
//

import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    static let identifier = "TrackersCollectionViewCell"
    
    // MARK: Properties
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 16
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = Resources.Colors.white
        
        return label
    }()
    
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = Resources.Colors.black
        
        return label
    }()
    
    private let addButton: UIButton = {
        let image = Resources.Images.addTrackerButton
        let button = UIButton.systemButton(with: Resources.Images.addTrackerButton, target: nil, action: nil)
        button.layer.cornerRadius = 17
        button.backgroundColor = .red
        button.tintColor = Resources.Colors.white
        
        return button
    }()
    
    private let emojiView = EmojiView()
    
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        titleLabel.text = "Кошка заслонила камеру на созвоне"
        daysLabel.text = "1 день"
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func configure() {
        [backView, titleLabel, daysLabel, addButton, emojiView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        backView.addSubview(titleLabel)
        backView.addSubview(emojiView)
        contentView.addSubview(backView)
        contentView.addSubview(daysLabel)
        contentView.addSubview(addButton)
        
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: topAnchor),
            backView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 12),
            emojiView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 12),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: emojiView.bottomAnchor, constant: 8),
            
            addButton.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            addButton.heightAnchor.constraint(equalToConstant: 34),
            addButton.widthAnchor.constraint(equalToConstant: 34),
            
            daysLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            daysLabel.trailingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: 8),
            daysLabel.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
        ])
    }
}
