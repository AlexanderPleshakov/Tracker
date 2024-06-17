//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 09.05.2024.
//

import UIKit

final class NewTrackerViewController: UIViewController {
    // MARK: Properties
    
    weak var delegate: NewTrackerViewControllerDelegate?
    private let newHabitButton = BasicLargeButton(title: NSLocalizedString("habit", comment: "Create habit button"))
    private let newEventButton = BasicLargeButton(title: NSLocalizedString("event", comment: "Create event button"))
    private let currentDate: Date
    
    // MARK: Init
    
    init(currentDate: Date) {
        self.currentDate = currentDate
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
    
    // MARK: Actions
    
    @objc private func newHabitButtonTapped() {
        let viewModel = NewTrackerViewModel(type: .habit, date: currentDate)
        let habitViewController = NewHabitOrEventViewController(viewModel: viewModel)
        habitViewController.delegate = self
        let habitNav = UINavigationController(rootViewController: habitViewController)
        present(habitNav, animated: true)
    }
    
    @objc private func newEventButtonTapped() {
        let viewModel = NewTrackerViewModel(type: .event, date: currentDate)
        let eventViewController = NewHabitOrEventViewController(viewModel: viewModel)
        eventViewController.delegate = self
        let eventNav = UINavigationController(rootViewController: eventViewController)
        present(eventNav, animated: true)
    }
}

// MARK: NewHabitOrEventViewControllerDelegate

extension NewTrackerViewController: NewHabitOrEventViewControllerDelegate {
    func closeController() {
        self.dismiss(animated: true)
    }
}

// MARK: UI

extension NewTrackerViewController {
    private func configure() {
        view.backgroundColor = Resources.Colors.white
        newHabitButton.addTarget(self, action: #selector(newHabitButtonTapped), for: .touchUpInside)
        newEventButton.addTarget(self, action: #selector(newEventButtonTapped), for: .touchUpInside)
        
        title = NSLocalizedString("newTracker.title ", comment: "New tracker title")
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: Resources.Colors.black ?? .black
        ]
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        [newEventButton, newHabitButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
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
}
