//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 10.05.2024.
//

import UIKit

final class NewHabitViewController: UIViewController {
    // MARK: Properties
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(InputFieldTableViewCell.self, forCellReuseIdentifier: InputFieldTableViewCell.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: Init
    
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
        
        title = "Новая привычка"
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension NewHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: InputFieldTableViewCell.reuseIdentifier, for: indexPath)
            
            guard let cell = cell as? InputFieldTableViewCell else {
                return UITableViewCell()
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            let cellText = indexPath.row == 0 ? "Категория" : "Расписание"
            cell.backgroundColor = Resources.Colors.cellBackground
            cell.accessoryType = .disclosureIndicator
            
            
            if #available(iOS 14.0, *) {
                var content = cell.defaultContentConfiguration()
                content.attributedText = NSAttributedString(string: cellText, attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .regular)])
                cell.contentConfiguration = content
            } else {
                cell.textLabel?.text = cellText
                cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            }
            
            
            return cell
        }
    }
}

extension NewHabitViewController: UITableViewDelegate {
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
