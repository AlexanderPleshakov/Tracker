//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Александр Плешаков on 13.06.2024.
//

import UIKit

final class OnboardingPageViewController: UIPageViewController {
    lazy var pages: [UIViewController] = {
        let firstPage = PageOfOnboardingViewController(
            text: "Отслеживайте только то, что хотите",
            image: Resources.Images.onboardingBlue
        )
        let secondPage = PageOfOnboardingViewController(
            text: "Даже если это не литры воды и йога",
            image: Resources.Images.onboardingRed
        )
        
        return [firstPage, secondPage]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Resources.Colors.black
        
        dataSource = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
    }
}

// MARK: UIPageViewControllerDataSource

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = index - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = index + 1
        
        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
}
