//
//  HabitOrEventViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 10.05.2024.
//

import UIKit

final class HabitOrEventViewController: UIViewController {
    // MARK: Properties

    private let viewModel: NewTrackerViewModel
    
    weak var delegate: HabitOrEventViewControllerDelegate?
    
    private let navTitle: String
    private var tableViewHelper: HabitAndEventTableViewHelper?
    
    private var tableHeightAnchor: NSLayoutConstraint!
    
    // MARK: Views
    
    private let scrollView: UIScrollView = UIScrollView()
    private let scrollContainer: UIView = UIView()
    
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.textColor = Resources.Colors.foreground
        
        return label
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
    
    private var emojiAndColorsCollectionView: EmojiAndColorsCollectionView!
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Resources.Colors.red, for: .normal)
        button.tintColor = Resources.Colors.red
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = Resources.Colors.red.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitle(NSLocalizedString("cancel", comment: "Cancel button"), for: .normal)
        
        return button
    }()
    
    private let saveOrCreateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Resources.Colors.secondaryGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitle(NSLocalizedString("create", comment: "Create button"), for: .normal)
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: Init
    
    init(viewModel: NewTrackerViewModel) {
        self.viewModel = viewModel
        self.navTitle = viewModel.navTitle
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let params = GeometricParams(cellCount: 6, topInset: 24,
                                     leftInset: 18, bottomInset: 40,
                                     rightInset: 18, cellSpacing: 5)
        emojiAndColorsCollectionView = EmojiAndColorsCollectionView(params: params, viewModel: viewModel)
        
        setupBindings()
        tableViewHelper = HabitAndEventTableViewHelper(type: viewModel.type,
                                                       delegate: self,
                                                       trackerName: viewModel.oldTitle)
        configure()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: Methods
    
    private func setupBindings() {
        viewModel.categoriesViewModel.selectedCategoryBinding = { [weak self] category in
            self?.viewModel.changeSelectedCategory(new: category)
            self?.tableViewHelper?.changeCategoryDetail(text: category?.title ?? "")
        }
        
        viewModel.timetableViewModel.selectedDaysBinding = { [weak self] days in
            guard let self = self else { return }
            self.tableViewHelper?.changeDaysDetail(days: days)
            self.viewModel.changeSelectedDays(new: viewModel.timetableViewModel.selectedDaysArray)
        }
        
        viewModel.needUnlockBinding = { [weak self] isNeed in
            guard let self = self else { return }
            isNeed ? unlockCreateButton() : blockCreateButton()
        }
        
        viewModel.trackerBinding = { [weak self] tracker in
            guard let self = self else { return }
            tableViewHelper?.changeDays(days: viewModel.timetableViewModel.selectedDaysString)
            tableViewHelper?.changeCategory(category: viewModel.selectedCategory?.title)
        }
    }
    
    private func blockCreateButton() {
        saveOrCreateButton.backgroundColor = Resources.Colors.secondaryGray
        saveOrCreateButton.isEnabled = false
        saveOrCreateButton.setTitleColor(.white, for: .normal)
    }
    
    private func unlockCreateButton() {
        saveOrCreateButton.backgroundColor = Resources.Colors.foreground
        saveOrCreateButton.isEnabled = true
        saveOrCreateButton.setTitleColor(Resources.Colors.background, for: .normal)
    }
    
    @objc private func buttonCancelTapped() {
        dismiss(animated: true)
        delegate?.closeController()
    }
    
    @objc private func buttonCreateTapped() {
        self.dismiss(animated: true)
        viewModel.addTracker()
        delegate?.closeController()
    }
    
    @objc private func buttonSaveTapped() {
        self.dismiss(animated: true)
        viewModel.updateTracker()
    }
}

// MARK: Keyboard

extension HabitOrEventViewController {
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

// MARK: HabitAndEventTableViewDelegate

extension HabitOrEventViewController: HabitAndEventTableViewDelegate {
    func changeTrackerTitle(text: String?) {
        viewModel.changeTrackerTitle(text: text)
    }
    
    func presentTimetable() {
        let timetable = TimetableViewController(viewModel: viewModel.timetableViewModel)
        let timetableNav = UINavigationController(rootViewController: timetable)
        present(timetableNav, animated: true)
    }
    
    func presentCategories() {
        let categoriesVC = CategoriesViewController(viewModel: viewModel.categoriesViewModel)
        let categoriesVCNav = UINavigationController(rootViewController: categoriesVC)
        present(categoriesVCNav, animated: true)
    }
    
    func reloadTable(isAdding: Bool) {
        tableHeightAnchor.constant = isAdding ? getTableHeight() + 38.0 : getTableHeight()
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    func getCell(at indexPath: IndexPath) -> UITableViewCell? {
        tableView.cellForRow(at: indexPath)
    }
}

// MARK: UI configure

extension HabitOrEventViewController {
    private func getCollectionHeight() -> CGFloat {
        let availableWidth = view.frame.width - emojiAndColorsCollectionView.params.paddingWidth
        let cellHeight =  availableWidth / CGFloat(emojiAndColorsCollectionView.params.cellCount)
        let paddings = CGFloat(38 + 48 + 80)
        
        let num = paddings + cellHeight * 6
        let collectionSize = CGFloat(num)
        
        return collectionSize
    }
    
    private func getTableHeight() -> CGFloat {
        let headersHeight = 48
        let cellHeight = 75
        let cellCount = (viewModel.type == .habit ? 3 : 2)
        let height = headersHeight + cellHeight * cellCount
        
        return CGFloat(height)
    }
    
    private func configure() {
        view.backgroundColor = Resources.Colors.background
        
        tableView.dataSource = tableViewHelper
        tableView.delegate = tableViewHelper
        
        tableView.backgroundColor = Resources.Colors.background
        
        title = navTitle
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: Resources.Colors.foreground
        ]
        
        cancelButton.addTarget(self, action: #selector(buttonCancelTapped), for: .touchUpInside)
        
        if viewModel.isEditing {
            saveOrCreateButton.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
            saveOrCreateButton.addTarget(self, action: #selector(buttonSaveTapped), for: .touchUpInside)
        } else {
            saveOrCreateButton.addTarget(self, action: #selector(buttonCreateTapped), for: .touchUpInside)
        }
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        [tableView, cancelButton, saveOrCreateButton,
         emojiAndColorsCollectionView, scrollView, scrollContainer, daysLabel].forEach {
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
        scrollContainer.addSubview(saveOrCreateButton)
        
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
            saveOrCreateButton.topAnchor.constraint(equalTo: emojiAndColorsCollectionView.bottomAnchor, constant: 0),
            saveOrCreateButton.heightAnchor.constraint(equalToConstant: 60),
            saveOrCreateButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 48) / 2),
            saveOrCreateButton.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: -20),
            saveOrCreateButton.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor),
        ])
        
        if viewModel.isEditing {
            scrollContainer.addSubview(daysLabel)
            daysLabel.text = viewModel.days
            NSLayoutConstraint.activate([
                daysLabel.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: 16),
                daysLabel.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: -16),
                daysLabel.topAnchor.constraint(equalTo: scrollContainer.topAnchor, constant: 24),
                
                tableView.topAnchor.constraint(equalTo: daysLabel.bottomAnchor, constant: 16),
                tableView.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: 0),
                tableView.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: 0),
            ])
            
        } else {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: scrollContainer.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: 0),
                tableView.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: 0),
            ])
        }
    }
}

