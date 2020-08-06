//
//  ViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: Properties
    private lazy var topView: TopView = {
        let view = TopView()
        view.editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        return view
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: @Objc
    @objc func didTapEditButton() {
        
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        [topView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.addSubview(topView)
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}

