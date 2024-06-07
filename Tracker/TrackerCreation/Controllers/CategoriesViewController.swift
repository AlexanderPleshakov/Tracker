//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 11.05.2024.
//

import UIKit

final class CategoriesViewController: UIViewController {
    // MARK: Properties
    
    weak var delegate: CategoriesViewControllerDelegate?
    private var selectedCategory: TrackerCategory? = nil
    private var categoryStoreManager: CategoryStoreManager?
    
    // MARK: Init
    
    init(delegate: CategoriesViewControllerDelegate? = nil, selectedCategory: TrackerCategory? = nil) {
        self.delegate = delegate
        self.selectedCategory = selectedCategory
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Views
    
    private let addButton: UIButton = {
        let button = BasicLargeButton(title: "Добавить категорию")
        
        return button
    }()
    
    private let stubView: StubView = {
        let stubView = StubView(text: "Привычки и события можно\nобъединить по смыслу")
        stubView.textLabel.textAlignment = .center
        stubView.textLabel.numberOfLines = 2
        
        return stubView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        
        return tableView
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryStoreManager = CategoryStoreManager(categoryStore: CategoryStore(),
                                                    delegate: self)

        configure()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        delegate?.selectedCategory = selectedCategory
        
        NotificationCenter.default.post(name: DisclosureTableViewCell.buttonTappedNotification, object: self, userInfo: ["category": selectedCategory?.title ?? ""])
    }
    
    // MARK: Methods
    
    private func categoryDidSelect(category: TrackerCategory) {
        selectedCategory = category
        self.dismiss(animated: true)
    }
    
    private func categoryDidDeselect() {
        selectedCategory = nil
    }
    
    @objc private func buttonAddTapped() {
        let newCategoryViewController = NewCategoryViewController()
        newCategoryViewController.delegate = self
        let nav = UINavigationController(rootViewController: newCategoryViewController)
        present(nav, animated: true)
    }
}

// MARK: NewCategoryViewControllerDelegate

extension CategoriesViewController: NewCategoryViewControllerDelegate {
    func add(category: TrackerCategory) {
        categoryStoreManager?.create(category: category)
    }
}

// MARK: NewCategoryStoreManagerDelegate

extension CategoriesViewController: NewCategoryStoreManagerDelegate {
    func removeStubAndShowCategories(indexPath: IndexPath) {
        stubView.removeFromSuperview()
        setupTableView()
        tableView.performBatchUpdates {
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: UITableViewDataSource

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryStoreManager?.numberOfRowsInSection(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)

        cell.backgroundColor = Resources.Colors.cellBackground
        
        guard let category = categoryStoreManager?.object(at: indexPath) else {
            print("Category is nil in creation cell")
            return UITableViewCell()
        }
        
        cell.textLabel?.text = category.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        if selectedCategory != nil && cell.textLabel?.text == selectedCategory?.title {
            let imageView = UIImageView(image: Resources.Images.checkmark)
            cell.accessoryView = imageView
        }
        
        return cell
    }
}

// MARK: UITableViewDelegate

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        if cell.accessoryView == nil {
            let imageView = UIImageView(image: Resources.Images.checkmark)
            cell.accessoryView = imageView
            
            guard let category = categoryStoreManager?.object(at: indexPath) else {
                print("Category is nil in did select cell")
                return
            }
            
            categoryDidSelect(category: category)
        } else {
            cell.accessoryView = nil
            categoryDidDeselect()
        }
    }
}

// MARK: UI

extension CategoriesViewController {
    private func configure() {
        view.backgroundColor = Resources.Colors.white
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = Resources.Colors.white
        
        addButton.addTarget(self, action: #selector(buttonAddTapped), for: .touchUpInside)
        
        title = Resources.Titles.categoriesTitle
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: Resources.Colors.black ?? .black
        ]
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        [addButton, stubView, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setupDoneButton()
        let categories = categoryStoreManager?.fetchAll() ?? []
        categories.isEmpty ? setupStubView() : setupTableView()
    }
    
    private func setupStubView() {
        view.addSubview(stubView)
        
        NSLayoutConstraint.activate([
            stubView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stubView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stubView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -16),
        ])
    }
    
    private func setupDoneButton() {
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
}
