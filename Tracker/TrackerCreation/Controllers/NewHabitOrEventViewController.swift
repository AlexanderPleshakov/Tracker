//
//  NewHabitOrEventViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 10.05.2024.
//

import UIKit

final class NewHabitOrEventViewController: UIViewController, TimetableDelegate {
    // MARK: Properties
    
    weak var delegate: NewHabitOrEventViewControllerDelegate?
    
    var selectedDays = [Day]()
    var selectedCategory: TrackerCategory? = nil
    
    private let type: TrackerType
    private let navTitle: String
    private var tableViewHelper: HabitAndEventTableViewHelper!
    
    // MARK: Views
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(InputFieldTableViewCell.self, forCellReuseIdentifier: InputFieldTableViewCell.reuseIdentifier)
        tableView.register(DisclosureTableViewCell.self, forCellReuseIdentifier: DisclosureTableViewCell.reuseIdentifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Resources.Colors.buttonRed, for: .normal)
        button.tintColor = Resources.Colors.buttonRed
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = Resources.Colors.buttonRed?.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Отменить", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Resources.Colors.searchTextGray
        button.tintColor = Resources.Colors.white
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Создать", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: Init
    
    init(type: TrackerType) {
        self.type = type
        self.navTitle = (type == .habit) ? "Новая привычка" : "Новое нерегулярное событие"
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewHelper = HabitAndEventTableViewHelper(type: type, delegate: self)
        configure()
    }
    
    // MARK: Methods
    
    @objc private func buttonCancelTapped() {
        dismiss(animated: true)
        delegate?.closeController()
    }
    
    @objc private func buttonCreateTapped() {
        print("Create tap")
    }
}

// MARK: HabitAndEventTableViewDelegate

extension NewHabitOrEventViewController: HabitAndEventTableViewDelegate {
    func presentTimetable() {
        let timetable = TimetableViewController(delegate: self, selectedDays: Set(selectedDays))
        let timetableNav = UINavigationController(rootViewController: timetable)
        present(timetableNav, animated: true)
    }
    
    func presentCategories() {
        let categoriesVC = CategoriesViewController()
        let categoriesVCNav = UINavigationController(rootViewController: categoriesVC)
        present(categoriesVCNav, animated: true)
    }
}

// MARK: UI configure

extension NewHabitOrEventViewController {
    private func configure() {
        view.backgroundColor = Resources.Colors.white
        
        tableView.dataSource = tableViewHelper
        tableView.delegate = tableViewHelper
        
        tableView.backgroundColor = Resources.Colors.white
        
        title = navTitle
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: Resources.Colors.black ?? .black
        ]
        
        cancelButton.addTarget(self, action: #selector(buttonCancelTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(buttonCreateTapped), for: .touchUpInside)
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        setupButtons()
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor)
        ])
    }
    
    private func setupButtons() {
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 48) / 2),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 48) / 2),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

