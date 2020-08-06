//
//  LoginViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    private let topLoginPageViewController = TopLoginPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    let bottomLoginPageViewController = BottomLoginPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureViews()
    }
    
    // MARK: @Objc
    @objc private func didTapSignUpButton() {
        
    }
    
    // MARK: Helpers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    // MARK: Configure
    private func configure() {
        moveViewWithKeyboard()
        addChild(topLoginPageViewController)
        addChild(bottomLoginPageViewController)
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        view.backgroundColor = .white
        
        view.addSubview(bottomLoginPageViewController.view)
        bottomLoginPageViewController.view.backgroundColor = .red
        bottomLoginPageViewController.view.translatesAutoresizingMaskIntoConstraints = false

        bottomLoginPageViewController.view.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height * 0.2)).isActive = true
        bottomLoginPageViewController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        bottomLoginPageViewController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        bottomLoginPageViewController.view.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        view.addSubview(topLoginPageViewController.view)
        topLoginPageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        topLoginPageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        topLoginPageViewController.view.bottomAnchor.constraint(equalTo: bottomLoginPageViewController.view.topAnchor, constant: -30).isActive = true
        topLoginPageViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topLoginPageViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
