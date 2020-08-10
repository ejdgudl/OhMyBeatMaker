//
//  BottomLoginPageViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class BottomLoginPageViewController: UIPageViewController {
    
    // MARK: Properties
    let firstVC = BottomFirstVC()
    private let secondVC = BottomSecondVC()
    
    private lazy var vcList = [firstVC, secondVC]
    
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
        firstVC.scrollToSignUpVCDelegate = self
        secondVC.delegate = self
    }
    
    // MARK: ConfigureView
    private func configureView() {
        view.backgroundColor = .white
    }
}

// MARK: UIPageViewControllerDelegate, UIPageViewControllerDataSource
extension BottomLoginPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // before
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vcList.firstIndex(of: viewController) else { return nil }
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
        let nextIndex = viewControllerIndex + 1
        
        if nextIndex >= vcList.count {
            return nil
        } else {
            return vcList[nextIndex]
        }
    }
    
}

// MARK: ScrollToSignUpVCDelegate
extension BottomLoginPageViewController: ScrollToSignUpVCDelegate {
    func ScrollToSignUpVC() {
        setViewControllers([secondVC], direction: .forward, animated: true, completion: nil)
    }
}

extension BottomLoginPageViewController: SignUpCompletionDelegate {
    func ScrollToFirst() {
        setViewControllers([firstVC], direction: .reverse, animated: true, completion: nil)
    }
}

