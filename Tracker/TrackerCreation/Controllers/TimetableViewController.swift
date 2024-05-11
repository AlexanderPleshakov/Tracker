//
//  TimetableViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 10.05.2024.
//

import UIKit

final class TimetableViewController: UIViewController {
    // MARK: Properties
    
    weak var delegate: TimetableDelegate?
    static let buttonTappedNotification = NSNotification.Name("buttonTappedNotification")
    
    private let allDays: [Day] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    private let days = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    private var selectedDays: Set<Day> = []
    
    // MARK: Views
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(TimetableTableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let doneButton = BasicLargeButton(title: "Готово")
    
    // MARK: Init
    
    init(delegate: TimetableDelegate? = nil, selectedDays: Set<Day>) {
        self.delegate = delegate
        self.selectedDays = selectedDays
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.selectedDays = getArraySelectedDays()
        delegate?.changeSubtitle()
    }
    
    // MARK: Methods
    
    private func configure() {
        view.backgroundColor = Resources.Colors.white
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = Resources.Colors.white
        
        doneButton.addTarget(self, action: #selector(buttonDoneTapped), for: .touchUpInside)
        
        title = "Расписание"
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -16),
        ])
    }
    
    private func getArraySelectedDays() -> [Day] {
        var daysArray = [Day]()
        for day in allDays {
            if selectedDays.contains(day) {
                daysArray.append(day)
            }
        }
        
        return daysArray
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        let day = allDays[sender.tag]
        if sender.isOn {
            selectedDays.insert(day)
        } else {
            selectedDays.remove(day)
        }
    }
    
    @objc private func buttonDoneTapped() {
        NotificationCenter.default.post(name: TimetableViewController.buttonTappedNotification, object: self, userInfo: ["days": getArraySelectedDays()])
        self.dismiss(animated: true)
    }
}

extension TimetableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        guard let cell = cell as? TimetableTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = Resources.Colors.cellBackground
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.attributedText = NSAttributedString(string: days[indexPath.row], attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .regular)])
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = days[indexPath.row]
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        }
        
        cell.switchView.setOn(selectedDays.contains(allDays[indexPath.row]), animated: true)
        cell.switchView.tag = indexPath.row
        cell.switchView.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        return cell
    }
}

extension TimetableViewController: UITableViewDelegate {
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
