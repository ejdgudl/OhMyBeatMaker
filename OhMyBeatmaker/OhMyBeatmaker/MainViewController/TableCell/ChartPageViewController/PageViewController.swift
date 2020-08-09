//
//  ChartPageViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/09.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

// MARK: Protocol SendFinishedTransition

class PageViewController: UIPageViewController {
    
    // MARK: Properties
    private lazy var vcList = [firstVC, secondVC]
    
    private let firstVC = FirstVC()
    private let secondVC = SecondVC()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureView()
    }
    
    // MARK: Configure
    private func configure() {
        dataSource = self
        delegate = self
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
    
    // MARK: ConfigureView
    private func configureView() {
        view.backgroundColor = .clear
    }
}

// MARK: UIPageViewControllerDelegate, UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return vcList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // before
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = vcList.firstIndex(of: viewController) else { return nil }
        print(viewController)
        print(viewControllerIndex)
        let previousIndex = viewControllerIndex - 1
        
        if previousIndex < 0 {
            return nil
        } else {
            return vcList[previousIndex]
        }
    }
    
    // after
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = vcList.firstIndex(of: viewController) else { return nil }
        print(viewController)
        print(viewControllerIndex)
        let nextIndex = viewControllerIndex + 1
        
        if nextIndex >= vcList.count {
            return nil
        } else {
            return vcList[nextIndex]
        }
    }
    
}
