//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 11.05.2024.
//

import UIKit

final class CategoriesViewController: UIViewController {
    // MARK: Properties
    var categories: [TrackerCategory] = [TrackerCategory(title: "Важное", trackers: [])]
    
    // MARK: Views
    
    let addButton: UIButton = {
        let button = BasicLargeButton(title: "Добавить категорию")
        
        return button
    }()
    
    let stubView: StubView = {
        let stubView = StubView(text: "Привычки и события можно\nобъединить по смыслу")
        stubView.textLabel.textAlignment = .center
        stubView.textLabel.numberOfLines = 2
        
        return stubView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        
        return tableView
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: Methods
    
    private func configure() {
        view.backgroundColor = Resources.Colors.white
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = Resources.Colors.white
        
        addButton.addTarget(self, action: #selector(buttonDoneTapped), for: .touchUpInside)
        
        title = "Категория"
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
    
    @objc private func buttonDoneTapped() {
        self.dismiss(animated: true)
    }
}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)

        cell.backgroundColor = Resources.Colors.cellBackground
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.attributedText = NSAttributedString(string: categories[indexPath.row].title, attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .regular)])
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = categories[indexPath.row].title
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        }
        
        return cell
    }
}

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
    }
}
