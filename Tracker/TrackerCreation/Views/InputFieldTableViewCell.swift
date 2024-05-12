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
    
    weak var delegate: HabitAndEventTableViewHelper?
    private var wasGreater = false
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.tintColor = Resources.Colors.blue
        textField.textColor = Resources.Colors.black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        return textField
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton.systemButton(with: Resources.Images.resetTextField, target: nil, action: nil)
        button.tintColor = Resources.Colors.searchTextGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        
        return button
    }()
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupSubviews()
        
        textField.addTarget(self, action: #selector(editingDidBegin(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEnd(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        resetButton.addTarget(self, action: #selector(buttonResetTapped(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setupSubviews() {
        backgroundColor = Resources.Colors.cellBackground
        
        contentView.addSubview(textField)
        contentView.addSubview(resetButton)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: resetButton.leadingAnchor, constant: -16),
            
            resetButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            resetButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            resetButton.heightAnchor.constraint(equalToConstant: 17),
            resetButton.widthAnchor.constraint(equalToConstant: 17),
        ])
    }
    
    @objc private func textChanged(_ textField: UITextField) {
        if textField.text?.count ?? 0 > 38 {
            wasGreater = true
            delegate?.addWarning()
        } else if wasGreater && textField.text?.count ?? 0 == 0 {
            wasGreater = false
            delegate?.removeWarning()
        } else if wasGreater && textField.text?.count ?? 0 < 38 {
            wasGreater = false
        } else if wasGreater {
            delegate?.removeWarning()
        }
    }
    
    @objc private func editingDidBegin(_ textField: UITextField) {
        textField.delegate = self
        resetButton.isHidden = false
    }
    
    @objc private func editingDidEnd(_ textField: UITextField) {
        if textField.text == "" {
            resetButton.isHidden = true
        }
        delegate?.textChanged(newText: textField.text)
    }
    
    @objc private func buttonResetTapped(_ button: UIButton) {
        button.isHidden = true
        textField.text = ""
        delegate?.textChanged(newText: "")
        delegate?.removeWarning()
    }
}

// MARK: UITextFieldDelegate

extension InputFieldTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textField.endEditing(true)
    }
}
