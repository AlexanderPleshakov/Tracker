//
//  TrackerColorCellView.swift
//  Tracker
//
//  Created by Александр Плешаков on 21.06.2024.
//

import UIKit

final class TrackerColorCellView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = Resources.Colors.alwaysWhite
        
        return label
    }()
    
    private let emojiView = EmojiView()
    
    init(color: UIColor, title: String, emoji: String, frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        backgroundColor = color
        titleLabel.text = title
        emojiView.changeEmoji(emoji: emoji)
        
        configure()
    }
    
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 16
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(color: UIColor) {
        backgroundColor = color
    }
    
    func set(title: String?) {
        titleLabel.text = title
    }
    
    func set(emoji: String) {
        emojiView.changeEmoji(emoji: emoji)
    }
    
    private func configure() {
        [titleLabel, emojiView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addSubview(titleLabel)
        addSubview(emojiView)
        
        NSLayoutConstraint.activate([
            emojiView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            emojiView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: emojiView.bottomAnchor, constant: 8),
        ])
    }
}
