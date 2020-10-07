//
//  TopLoginPageViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class TopLoginPageViewController: UIPageViewController {
    
    // MARK: Properties
    private let firstVC = TopFirstVC()
    private let secondVC = TopSecondVC()
    
    private lazy var vcList = [firstVC, secondVC]
    
    private let timer = Timer()
    private var count = 0
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureView()
    }
    
    deinit {
        timer.invalidate()
    }
    
    // MARK: @Objc
    @objc private func updateTime() {
        count += 1
        if count % 10 == 0 {
            setViewControllers([firstVC], direction: .reverse, animated: true, completion: nil)
        } else if count % 5 == 0 {
            setViewControllers([secondVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: Configure
    private func configure() {
        dataSource = self
        delegate = self
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    // MARK: ConfigureView
    private func configureView() {
        view.backgroundColor = .white
    }
}

// MARK: UIPageViewControllerDelegate, UIPageViewControllerDataSource
extension TopLoginPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vcList.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        if previousIndex < 0 {
            return nil
        } else {
            return vcList[previousIndex]
        }
    }

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
