//
//  StatisticTableViewCell.swift
//  Tracker
//
//  Created by Александр Плешаков on 27.06.2024.
//

import UIKit

final class StatisticTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "StatisticTableViewCell"
    private let gradientLayer = CAGradientLayer()
    private let borderLayer = CAShapeLayer()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.textColor = Resources.Colors.foreground
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.textColor = Resources.Colors.foreground
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        layer.cornerRadius = 16
        
        configure()
        setupGradientBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        countLabel.text = ""
        titleLabel.text = ""
    }
    
    func setCount(count: Int) {
        countLabel.text = String(count)
    }
    
    func setTitle(text: String?) {
        titleLabel.text = text
    }
    
    private func setupGradientBorder() {
        gradientLayer.colors = [
            UIColor(rgb: 0xFD4C49).cgColor,
            UIColor(rgb: 0x46E69D).cgColor,
            UIColor(rgb: 0x007BFA).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = contentView.bounds
        gradientLayer.cornerRadius = 16
        
        borderLayer.lineWidth = 2
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.path = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 16).cgPath
        
        gradientLayer.mask = borderLayer
        
        contentView.layer.addSublayer(gradientLayer)
        
        contentView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.bounds
        borderLayer.path = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 16).cgPath
    }
    
    private func configure() {
        [countLabel, titleLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            countLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            countLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -7),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 7),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
}
