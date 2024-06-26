//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 11.05.2024.
//

import UIKit

final class CategoriesViewController: UIViewController {
    // MARK: Properties
    
    private var viewModel: CategoriesViewModelProtocol
    
    // MARK: Init
    
    init(viewModel: CategoriesViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Views
    
    private let addButton: UIButton = BasicLargeButton(title: NSLocalizedString("addCategory", comment: "Categories title"))
    
    private let stubView: StubView = {
        let stubView = StubView(text: NSLocalizedString("stub.categories", comment: "Stub"))
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
        
        viewModel.categoriesBinding = { [weak self] _ in
            guard let self = self else { return }
            if self.stubView.isHidden == false {
                self.stubView.removeFromSuperview()
                self.setupTableView()
            }

            self.tableView.reloadData()
        }
        
        configure()
        tableView.reloadData()
    }
    
    // MARK: Methods
    
    @objc private func buttonAddTapped() {
        let newCategoryViewController = NewCategoryViewController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: newCategoryViewController)
        present(nav, animated: true)
    }
}

// MARK: UITableViewDataSource

extension CategoriesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)

        cell.backgroundColor = Resources.Colors.cellBackground
        let category = viewModel.categories[indexPath.row]
        
        cell.textLabel?.text = category.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        let selectedCategory = viewModel.selectedCategory
        
        if selectedCategory != nil && cell.textLabel?.text == selectedCategory?.title {
            let imageView = UIImageView(image: Resources.Images.checkmark)
            cell.accessoryView = imageView
        } else {
            cell.accessoryView = nil
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
            
            let category = viewModel.categories[indexPath.row]
            
            viewModel.didSelect(category)
            self.dismiss(animated: true)
        } else {
            cell.accessoryView = nil
            viewModel.didDeselect()
        }
    }
}

// MARK: UI

extension CategoriesViewController {
    private func configure() {
        view.backgroundColor = Resources.Colors.background
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = Resources.Colors.background
        
        addButton.addTarget(self, action: #selector(buttonAddTapped), for: .touchUpInside)
        
        title = NSLocalizedString("categories.title", comment: "Categories title")
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: Resources.Colors.foreground
        ]
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        [addButton, stubView, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setupDoneButton()
        let categories = viewModel.categories
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
