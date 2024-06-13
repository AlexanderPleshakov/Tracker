//
//  SplashViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 13.06.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    // MARK: Properties
    
    private let imageView: UIImageView = {
        let view = UIImageView(image: Resources.Images.logo)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setCurrentState()
    }
    
    // MARK: Methods
    
    private func configure() {
        view.backgroundColor = Resources.Colors.blue
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 94),
            imageView.widthAnchor.constraint(equalToConstant: 91),
        ])
    }
    
    private func setCurrentState() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        
        guard let _ = UserDefaults.standard.object(forKey: "OnboardingWasShown") as? Bool else {
            let onboarding = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            sceneDelegate.changeRootViewController(onboarding, animated: false)
            return
        }
        
        let tabBar = TabBarViewController()
        sceneDelegate.changeRootViewController(tabBar, animated: false)
    }
}
