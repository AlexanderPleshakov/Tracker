//
//  NewHabitOrEventViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 10.05.2024.
//

import UIKit

final class NewHabitOrEventViewController: UIViewController,
                                           TimetableDelegate,
                                           CategoriesViewControllerDelegate {
    // MARK: Properties
    
    private let type: TrackerType
    private let navTitle: String
    private var tableViewHelper: HabitAndEventTableViewHelper?
    weak var delegate: NewHabitOrEventViewControllerDelegate?
    
    private var newCategory: TrackerCategory? = nil
    private var categoryTitle: String?
    
    var selectedDays = [Day]() {
        willSet(new) {
            tracker = Tracker(
                id: tracker.id,
                name: tracker.name,
                color: tracker.color,
                emoji: tracker.emoji,
                timetable: new,
                creationDate: TrackersViewController.currentDate)
        }
    }
    var selectedCategory: TrackerCategory? = nil {
        didSet {
            tracker = Tracker(
                id: tracker.id,
                name: tracker.name,
                color: tracker.color,
                emoji: tracker.emoji,
                timetable: tracker.timetable,
                creationDate: TrackersViewController.currentDate)
        }
    }
    
    var tracker: Tracker = Tracker(
        id: UUID(),
        name: nil,
        color: Resources.Colors.Tracker.trackersColors[Int.random(in: 0..<18)],
        emoji: "👻",
        timetable: nil,
        creationDate: TrackersViewController.currentDate
    ) {
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
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .brown
        
        return scroll
    }()
    
    private let scrollContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(InputFieldTableViewCell.self,
                           forCellReuseIdentifier: InputFieldTableViewCell.reuseIdentifier)
        tableView.register(DisclosureTableViewCell.self,
                           forCellReuseIdentifier: DisclosureTableViewCell.reuseIdentifier)
        tableView.isScrollEnabled = false
        
        
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
        
        return button
    }()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Resources.Colors.searchTextGray
        button.tintColor = Resources.Colors.white
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Создать", for: .normal)
        button.isEnabled = false
        
        return button
    }()
    
    private let emojiAndColorsCollectionView: EmojiAndColorsCollectionView = {
        let params = GeometricParams(cellCount: 6, topInset: 0,
                                     leftInset: 18, bottomInset: 0,
                                     rightInset: 18, cellSpacing: 5)
        let collection = EmojiAndColorsCollectionView(params: params)
        
        return collection
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
        self.navTitle = (type == .habit) ? Resources.Titles.habitTitle : Resources.Titles.eventTitle
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

// MARK: Keyboard

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
            tracker = Tracker(
                id: tracker.id,
                name: categoryTitle,
                color: tracker.color,
                emoji: tracker.emoji,
                timetable: tracker.timetable,
                creationDate: TrackersViewController.currentDate)
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
        [tableView, cancelButton, createButton, emojiAndColorsCollectionView, scrollView, scrollContainer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupScrollView()
    }
    
    private func setupScrollView() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
    
        scrollContainer.addSubview(tableView)
        scrollContainer.addSubview(cancelButton)
        scrollContainer.addSubview(createButton)
        
        
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Scroll Container
            scrollContainer.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContainer.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContainer.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            scrollContainer.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            
            // Table View
            tableView.topAnchor.constraint(equalTo: scrollContainer.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: 0),
            tableView.heightAnchor.constraint(equalToConstant: 75 * 3 + 48 + 8),
            
            // Cancel Button
            cancelButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 24),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 48) / 2),
            cancelButton.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor),
            
            // Create Button
            createButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 24),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 48) / 2),
            createButton.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor),
        ])
    }
}

