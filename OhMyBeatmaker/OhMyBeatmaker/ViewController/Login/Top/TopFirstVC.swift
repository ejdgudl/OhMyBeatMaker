//
//  TopFirstVC.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class TopFirstVC: UIViewController {
    
    // MARK: Properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "loginBannerSample1")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
