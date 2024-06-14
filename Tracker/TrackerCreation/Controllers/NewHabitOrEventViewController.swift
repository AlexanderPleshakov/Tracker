//
//  NewHabitOrEventViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 10.05.2024.
//

import UIKit

final class NewHabitOrEventViewController: UIViewController {
    // MARK: Properties
    private let timetableViewModel = TimetableViewModel()
    private let categoriesViewModel = CategoriesViewModel()
    private let viewModel: NewTrackerViewModel
    
    weak var delegate: NewHabitOrEventViewControllerDelegate?
    
    private let navTitle: String
    private var tableViewHelper: HabitAndEventTableViewHelper?
    
    private var tableHeightAnchor: NSLayoutConstraint!
    
    // MARK: Views
    
    private let scrollView: UIScrollView = UIScrollView()
    private let scrollContainer: UIView = UIView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(InputFieldTableViewCell.self,
                           forCellReuseIdentifier: InputFieldTableViewCell.reuseIdentifier)
        tableView.register(DisclosureTableViewCell.self,
                           forCellReuseIdentifier: DisclosureTableViewCell.reuseIdentifier)
        tableView.isScrollEnabled = false
        
        
        return tableView
    }()
    
    private let emojiAndColorsCollectionView: EmojiAndColorsCollectionView = {
        let params = GeometricParams(cellCount: 6, topInset: 24,
                                     leftInset: 18, bottomInset: 40,
                                     rightInset: 18, cellSpacing: 5)
        let collection = EmojiAndColorsCollectionView(params: params)
        
        return collection
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
    
    // MARK: Init
    
    init(viewModel: NewTrackerViewModel) {
        self.viewModel = viewModel
        self.navTitle = (viewModel.type == .habit) ? Resources.Titles.habitTitle : Resources.Titles.eventTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        tableViewHelper = HabitAndEventTableViewHelper(type: viewModel.type, delegate: self)
        configure()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: Methods
    
    private func setupBindings() {
        categoriesViewModel.selectedCategoryBinding = { [weak self] category in
            self?.viewModel.changeSelectedCategory(new: category)
            
            NotificationCenter.default.post(name: DisclosureTableViewCell.buttonTappedNotification, object: self, userInfo: ["category": category?.title ?? ""])
        }
        
        timetableViewModel.selectedDaysBinding = { [weak self] days in
            guard let self = self else { return }
            NotificationCenter.default.post(name: DisclosureTableViewCell.buttonTappedNotification, object: self, userInfo: ["days": self.timetableViewModel.selectedDaysArray])
            
            self.viewModel.changeSelectedDays(new: self.timetableViewModel.selectedDaysArray)
        }
        
        viewModel.needUnlockBinding = { [weak self] isNeed in
            guard let self = self else { return }
            isNeed ? unlockCreateButton() : blockCreateButton()
        }
        
        viewModel.trackerBinding = { [weak self] tracker in
            guard let self = self else { return }
            tableViewHelper?.changeDays(days: tracker.timetable ?? [])
            tableViewHelper?.changeCategory(category: viewModel.selectedCategory?.title)
        }
    }
    
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
        guard let category = viewModel.newCategory else {
            return
        }

        self.dismiss(animated: true)
        delegate?.addTracker(tracker: viewModel.tracker, category: category)
    }
}

// MARK: Keyboard

extension NewHabitOrEventViewController {
    private func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: TimetableDelegate

extension NewHabitOrEventViewController {
    
}

// MARK: CategoriesViewControllerDelegate

extension NewHabitOrEventViewController {
    
}

// MARK: TimetableDelegate

extension NewHabitOrEventViewController: EmojiAndColorsCollectionViewDelegate {
    func changeSelectedColor(new color: Int?) {
        viewModel.changeSelectedColor(new: color)
    }
    
    func changeSelectedEmoji(new emoji: Character?) {
        viewModel.changeSelectedEmoji(new: emoji)
    }
    
    
}

// MARK: HabitAndEventTableViewDelegate

extension NewHabitOrEventViewController: HabitAndEventTableViewDelegate {
    func changeCategoryTitle(text: String?) {
        viewModel.changeCategoryTitle(text: text)
    }
    
    func presentTimetable() {
        let timetable = TimetableViewController(viewModel: timetableViewModel)
        let timetableNav = UINavigationController(rootViewController: timetable)
        present(timetableNav, animated: true)
    }
    
    func presentCategories() {
        let categoriesVC = CategoriesViewController(viewModel: categoriesViewModel)
        let categoriesVCNav = UINavigationController(rootViewController: categoriesVC)
        present(categoriesVCNav, animated: true)
    }
    
    func reloadTable(isAdding: Bool) {
        tableHeightAnchor.constant = isAdding ? getTableHeight() + 38.0 : getTableHeight()
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
}

// MARK: UI configure

extension NewHabitOrEventViewController {
    private func getCollectionHeight() -> CGFloat {
        let availableWidth = view.frame.width - emojiAndColorsCollectionView.params.paddingWidth
        let cellHeight =  availableWidth / CGFloat(emojiAndColorsCollectionView.params.cellCount)
        
        let num = 38 + 48 + 80 + cellHeight * 6
        let collectionSize = CGFloat(num)
        
        return collectionSize
    }
    
    private func getTableHeight() -> CGFloat {
        let height = 48 + (viewModel.type == .habit ? 75 * 3 : 75 * 2)
        
        return CGFloat(height)
    }
    
    private func configure() {
        view.backgroundColor = Resources.Colors.white
        
        tableView.dataSource = tableViewHelper
        tableView.delegate = tableViewHelper
        emojiAndColorsCollectionView.delegateController = self
        
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
        [tableView, cancelButton, createButton,
         emojiAndColorsCollectionView, scrollView, scrollContainer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupScrollView()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
    
        scrollContainer.addSubview(tableView)
        scrollContainer.addSubview(emojiAndColorsCollectionView)
        scrollContainer.addSubview(cancelButton)
        scrollContainer.addSubview(createButton)
        
        tableHeightAnchor = tableView.heightAnchor.constraint(equalToConstant: getTableHeight())
        tableHeightAnchor.isActive = true
        
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
            
            // Collection View
            emojiAndColorsCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            emojiAndColorsCollectionView.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: 0),
            emojiAndColorsCollectionView.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: 0),
            emojiAndColorsCollectionView.heightAnchor.constraint(equalToConstant: getCollectionHeight()),
            
            // Cancel Button
            cancelButton.topAnchor.constraint(equalTo: emojiAndColorsCollectionView.bottomAnchor, constant: 0),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 48) / 2),
            cancelButton.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor),
            
            // Create Button
            createButton.topAnchor.constraint(equalTo: emojiAndColorsCollectionView.bottomAnchor, constant: 0),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 48) / 2),
            createButton.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor),
        ])
    }
}

