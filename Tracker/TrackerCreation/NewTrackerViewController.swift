//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 09.05.2024.
//

import UIKit

final class NewTrackerViewController: UIViewController {
    
    private let newHabitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Resources.Colors.black
        button.tintColor = Resources.Colors.white
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Привычка", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let newEventButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Resources.Colors.black
        button.tintColor = Resources.Colors.white
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Нерегулярное событие", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: Methods
    
    private func configure() {
        view.backgroundColor = Resources.Colors.white
        newHabitButton.addTarget(self, action: #selector(newHabitButtonTapped), for: .touchUpInside)
        newEventButton.addTarget(self, action: #selector(newEventButtonTapped), for: .touchUpInside)
        
        title = "Создание трекера"
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.addSubview(newHabitButton)
        view.addSubview(newEventButton)
        
        NSLayoutConstraint.activate([
            newHabitButton.topAnchor.constraint(equalTo: view.centerYAnchor),
            newHabitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newHabitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            newHabitButton.heightAnchor.constraint(equalToConstant: 60),
            
            newEventButton.topAnchor.constraint(equalTo: newHabitButton.bottomAnchor, constant: 16),
            newEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            newEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func newHabitButtonTapped() {
        
    }
    
    @objc private func newEventButtonTapped() {
        
    }
}
