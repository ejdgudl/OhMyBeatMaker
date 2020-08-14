//
//  UserProfileViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/10.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class UserProfileViewController: UIViewController {
    
    // MARK: Properties
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 48 / 2
        return imageView
    }()
    
    private let firebaseService = FirebaseService()
    
    var user: User? {
        didSet {
            title = user?.nickName
            guard let profileImageStrUrl = user?.profileImageUrl else {return}
            guard let profileImageUrl = URL(string: profileImageStrUrl) else {return}
            profileImageView.kf.setImage(with: profileImageUrl)
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: @Objc
    @objc private func handleShowMessage() {
        didSelectUser()
    }
    
    // MARK: Helpers
    private func didSelectUser() {
        guard let userUid = user?.uid else {return}
        firebaseService.fetchUserService(with: userUid) { (user) in
            self.showChatCollectionVC(for: user)
        }
    }
    
    private func showChatCollectionVC(for user: User) {
        let chatCollectionVC = ChatCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatCollectionVC.user = user
        navigationController?.pushViewController(chatCollectionVC, animated: true)
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
