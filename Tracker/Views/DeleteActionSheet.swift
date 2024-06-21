//
//  DeleteActionSheet.swift
//  Tracker
//
//  Created by Александр Плешаков on 22.06.2024.
//

import UIKit

final class DeleteActionSheet {
    private let alert: UIAlertController
    
    init(title: String?, message: String?, handler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) {_ in
            handler()
        })
        
        alert.addAction(UIAlertAction(title: "Назад", style: .cancel) { action in
            alert.dismiss(animated: true)
        })
        
        self.alert = alert
    }
    
    func present(on viewController: UIViewController?) {
        viewController?.present(alert, animated: true)
    }
}
