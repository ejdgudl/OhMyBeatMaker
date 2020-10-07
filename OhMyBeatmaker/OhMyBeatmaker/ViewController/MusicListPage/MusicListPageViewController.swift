//
//  ChartPageViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/09.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

// MARK: MusicListPageViewControllerDelegate
protocol MusicListPageViewControllerDelegate: class {
    func sendMusicTitle(musicTitle: String)
}

class MusicListPageViewController: UIPageViewController {
    
    // MARK: Properties
    private lazy var vcList = [firstVC, secondVC, thirdVC]
    
    let firstVC = FirstVC()
    private let secondVC = SecondVC()
    private let thirdVC = ThirdVC()
    
    weak var musicListPageViewControllerDelegate: MusicListPageViewControllerDelegate?
    
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
        firstVC.firstPageVCDelegate = self
        secondVC.secondPageVCDelegate = self
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
    
    // MARK: ConfigureView
    private func configureView() {
        view.backgroundColor = .clear
    }
}

// MARK: UIPageViewControllerDelegate, UIPageViewControllerDataSource
extension MusicListPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
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

// MARK: FirstPageVCDelegate
extension MusicListPageViewController: FirstPageVCDelegate {
    func sendMusicTitle(musicTitle: String) {
        musicListPageViewControllerDelegate?.sendMusicTitle(musicTitle: musicTitle)
    }
}

// MARK: SecondPageVCDelegate
extension MusicListPageViewController: SecondPageVCDelegate {
    func sendMusicSecondChartTitle(musicTitle: String) {
        musicListPageViewControllerDelegate?.sendMusicTitle(musicTitle: musicTitle)
    }
}
