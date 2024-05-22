//
//  NewHabitOrEventViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 10.05.2024.
//

import UIKit

final class NewHabitOrEventViewController: UIViewController, TimetableDelegate, CategoriesViewControllerDelegate {
    // MARK: Properties
    private let type: TrackerType
    private let navTitle: String
    private var tableViewHelper: HabitAndEventTableViewHelper!
    weak var delegate: NewHabitOrEventViewControllerDelegate?
    
    private var newCategory: TrackerCategory? = nil
    private var categoryTitle: String?
    
    var selectedDays = [Day]() {
        willSet(new) {
            tracker = Tracker(id: tracker.id, name: tracker.name, color: tracker.color, emoji: tracker.emoji, timetable: new)
        }
    }
    var selectedCategory: TrackerCategory? = nil {
        didSet {
            tracker = Tracker(id: tracker.id, name: tracker.name, color: tracker.color, emoji: tracker.emoji, timetable: tracker.timetable)
        }
    }
    
    var tracker: Tracker = Tracker(id: 1, name: nil, color: Resources.Colors.Tracker.trackersColors[Int.random(in: 0..<18)], emoji: "👻", timetable: nil) {
        willSet(newValue) {
            if !newValue.isEmpty(type: type) && selectedCategory != nil {
                newCategory = TrackerCategory(title: selectedCategory!.title,
                                              trackers: selectedCategory!.trackers + [newValue])
                
                unlockCreateButton()
            } else {
                blockCreateButton()
            }
        }
    }
    
    
    
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
    
    let warningLabel: UILabel = {
        let label = UILabel()
        label.textColor = Resources.Colors.buttonRed
        label.text = "Ограничение 38 символов"
        label.textAlignment = .center
        
        return label
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
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: Methods
    
    private func blockCreateButton() {
        createButton.backgroundColor = Resources.Colors.searchTextGray
        createButton.isEnabled = false
    }
    
    private func unlockCreateButton() {
        createButton.backgroundColor = Resources.Colors.black
        createButton.isEnabled = true
    }
    
    @objc private func buttonCancelTapped() {
        dismiss(animated: true)
        delegate?.closeController()
    }
    
    @objc private func buttonCreateTapped() {
        guard let newCategory = newCategory else {
            print("Category is nil")
            return
        }
        
        let index = TrackersViewController.categories.firstIndex(of: newCategory)
        
        if let index = index {
            TrackersViewController.categories[index] = newCategory
        } else {
            TrackersViewController.categories.append(newCategory)
        }
        self.dismiss(animated: true)
        delegate?.addTracker()
    }
}

extension NewHabitOrEventViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: HabitAndEventTableViewDelegate

extension NewHabitOrEventViewController: HabitAndEventTableViewDelegate {
    func changeCategoryTitle(text: String?) {
        if text?.count ?? 0 <= 38 {
            categoryTitle = text
            tracker = Tracker(id: tracker.id, name: categoryTitle, color: tracker.color, emoji: tracker.emoji, timetable: tracker.timetable)
        } else {
            blockCreateButton()
        }
    }
    
    func presentTimetable() {
        let timetable = TimetableViewController(delegate: self, selectedDays: Set(selectedDays))
        let timetableNav = UINavigationController(rootViewController: timetable)
        present(timetableNav, animated: true)
    }
    
    func presentCategories() {
        let categoriesVC = CategoriesViewController(delegate: self, selectedCategory: selectedCategory)
        let categoriesVCNav = UINavigationController(rootViewController: categoriesVC)
        present(categoriesVCNav, animated: true)
    }
    
    func reloadTable() {
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
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

