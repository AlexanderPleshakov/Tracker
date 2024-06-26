//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 04.05.2024.
//

import UIKit

final class StatisticViewController: UIViewController {
    // MARK: Properties
    
    private let stub = StubView(text: "Анализировать пока нечего",
                                image: Resources.Images.statisticStub)
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: Methods
}

// MARK: UI

extension StatisticViewController {
    private func configureUI() {
        view.backgroundColor = Resources.Colors.background
        title = NSLocalizedString("statistic", comment: "")
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: Resources.Colors.foreground]
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        [stub].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        setupStub()
    }
    
    private func setupStub() {
        view.addSubview(stub)
        
        NSLayoutConstraint.activate([
            stub.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stub.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
