//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 12.05.2024.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    // MARK: Properties
    
    private let viewModel: CategoriesViewModelProtocol
    
    // MARK: Views
    
    private let doneButton: UIButton = {
        let button = BasicLargeButton(title: NSLocalizedString("done", comment: "done button"))
        button.backgroundColor = Resources.Colors.secondaryGray
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let textField: UITextField = {
        let textField = TextFieldWithPadding()
        textField.placeholder = NSLocalizedString("input.name.category", comment: "")
        textField.backgroundColor = Resources.Colors.cellBackground
        textField.tintColor = Resources.Colors.secondaryGray
        textField.textColor = Resources.Colors.foreground
        textField.layer.cornerRadius = 16
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    // MARK: Init
    
    init(viewModel: CategoriesViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: Methods
    
    @objc private func buttonDoneTapped() {
        guard let text = textField.text else { return }
        let category = TrackerCategory(title: text, trackers: [])
        
        viewModel.addCategory(category: category)
        
        self.dismiss(animated: true)
    }
    
    @objc private func textChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text == "" {
            doneButton.setTitleColor(.white, for: .normal)
            doneButton.isEnabled = false
            doneButton.backgroundColor = Resources.Colors.secondaryGray
        } else {
            doneButton.setTitleColor(Resources.Colors.background, for: .normal)
            doneButton.isEnabled = true
            doneButton.backgroundColor = Resources.Colors.foreground
        }
    }

}

// MARK: UITextFieldDelegate

extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: UI

extension NewCategoryViewController {
    private func configure() {
        view.backgroundColor = Resources.Colors.background
        
        doneButton.addTarget(self, action: #selector(buttonDoneTapped), for: .touchUpInside)
        textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        textField.delegate = self
        
        title = NSLocalizedString("newCategory.title", comment: "")
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: Resources.Colors.foreground
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
