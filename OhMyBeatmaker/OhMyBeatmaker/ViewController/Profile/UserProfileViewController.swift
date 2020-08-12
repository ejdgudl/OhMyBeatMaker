//
//  UserProfileViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/10.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Kingfisher

class UserProfileViewController: UIViewController {
    
    // MARK: Properties
    var user: User? {
        didSet {
            title = user?.nickName
            guard let profileImageStrUrl = user?.profileImageUrl else {return}
            guard let profileImageUrl = URL(string: profileImageStrUrl) else {return}
            profileImageView.kf.setImage(with: profileImageUrl)
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 48 / 2
        return imageView
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureViews()
    }
    
    @objc private func handleShowMessage() {
        let messagesTableVC = MessagesTableViewController()
        navigationController?.pushViewController(messagesTableVC, animated: true)
    }
    
    
    // MARK: Configure
    private func configure() {
        
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleShowMessage))
        
        view.backgroundColor = .white
        [profileImageView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
}
