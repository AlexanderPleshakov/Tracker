//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 09.05.2024.
//

import UIKit

final class NewTrackerViewController: UIViewController {
    // MARK: Properties
    
    private let newHabitButton = BasicLargeButton(title: "Привычка")
    private let newEventButton = BasicLargeButton(title: "Нерегулярное событие")
    
    // MARK: Init
    
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
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: Resources.Colors.black ?? .black
        ]
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        newEventButton.translatesAutoresizingMaskIntoConstraints = false
        newHabitButton.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    // MARK: Actions
    
    @objc private func newHabitButtonTapped() {
        let habitViewController = NewHabitOrEventViewController(type: .habit)
        habitViewController.delegate = self
        let habitNav = UINavigationController(rootViewController: habitViewController)
        present(habitNav, animated: true)
    }
    
    @objc private func newEventButtonTapped() {
        let eventViewController = NewHabitOrEventViewController(type: .event)
        eventViewController.delegate = self
        let eventNav = UINavigationController(rootViewController: eventViewController)
        present(eventNav, animated: true)
    }
}

extension NewTrackerViewController: NewHabitOrEventViewControllerDelegate {
    func closeController() {
        self.dismiss(animated: true)
    }
}
