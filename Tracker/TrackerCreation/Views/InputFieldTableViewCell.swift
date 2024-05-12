//
//  InputFieldTableViewCell.swift
//  Tracker
//
//  Created by Александр Плешаков on 10.05.2024.
//

import UIKit

final class InputFieldTableViewCell: UITableViewCell {
    // MARK: Properties
    static let reuseIdentifier = "InputFieldTableViewCell"
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.tintColor = Resources.Colors.searchTextGray
        textField.textColor = Resources.Colors.black
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupSubviews()
        
        textField.addTarget(self, action: #selector(editingDidBegin(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEnd(_:)), for: .editingDidEnd)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setupSubviews() {
        backgroundColor = Resources.Colors.cellBackground
        
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func editingDidBegin(_ textField: UITextField) {
        textField.delegate = self
    }
    
    @objc private func editingDidEnd(_ textField: UITextField) {
        
    }
}

extension InputFieldTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textField.endEditing(true)
    }
}
