//
//  TracksViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 03.05.2024.
//

import UIKit

class TracksViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Resources.Colors.white
        
        navigationItem.title = "Трекеры"
        navigationItem.titleView?.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

