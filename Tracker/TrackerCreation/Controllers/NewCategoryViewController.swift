//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 12.05.2024.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    // MARK: Properties
    
    weak var delegate: NewCategoryViewControllerDelegate?
    
    // MARK: Views
    
    private let doneButton: UIButton = {
        let button = BasicLargeButton(title: "Готово")
        button.backgroundColor = Resources.Colors.searchTextGray
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let textField: UITextField = {
        let textField = TextFieldWithPadding()
        textField.placeholder = "Введите название категории"
        textField.backgroundColor = Resources.Colors.cellBackground
        textField.tintColor = Resources.Colors.searchTextGray
        textField.textColor = Resources.Colors.black
        textField.layer.cornerRadius = 16
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: Methods
    
    @objc private func buttonDoneTapped() {
        guard let text = textField.text else { return }
        TrackersViewController.categories.append(TrackerCategory(title: text, trackers: []))
        self.dismiss(animated: true)
        delegate?.categories = TrackersViewController.categories
        delegate?.removeStubAndShowCategories()
    }
    
    @objc private func textChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text == "" {
            doneButton.isEnabled = false
            doneButton.backgroundColor = Resources.Colors.searchTextGray
        } else {
            doneButton.isEnabled = true
            doneButton.backgroundColor = Resources.Colors.black
        }
    }

}

extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension NewCategoryViewController {
    private func configure() {
        view.backgroundColor = Resources.Colors.white
        
        doneButton.addTarget(self, action: #selector(buttonDoneTapped), for: .touchUpInside)
        textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        textField.delegate = self
        
        title = Resources.Titles.newCategoryTitle
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: Resources.Colors.black ?? .black
        ]
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.addSubview(doneButton)
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
}
