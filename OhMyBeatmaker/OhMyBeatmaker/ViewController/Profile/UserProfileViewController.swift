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
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    let userMusicListTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let firebaseService = FirebaseService()
    private let db = Database.database().reference()
    
    var user: User? {
        didSet {
            db.child("Musics").observe(.childAdded) { (snapshot) in
                let musicTitle = snapshot.key
                guard let dic = snapshot.value as? Dictionary<String, AnyObject> else {return}
                let music = Music(musicTitle: musicTitle, dictionary: dic)
                if music.artistNickName == self.user?.nickName {
                    self.userMusics.append(music)
                }
            }
            title = user?.nickName
            guard let profileImageStrUrl = user?.profileImageUrl else {return}
            guard let profileImageUrl = URL(string: profileImageStrUrl) else {return}
            profileImageView.kf.setImage(with: profileImageUrl)
        }
    }
    
    private var userMusics = [Music]() {
        didSet {
            userMusicListTableView.reloadData()
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
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

    // MARK: Configure
    private func configure() {
        userMusicListTableView.delegate = self
        userMusicListTableView.dataSource = self
        
        userMusicListTableView.register(UserMusicListTableCell.self, forCellReuseIdentifier: UITableView.userMusicListTableCellID)
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleShowMessage))
        
        view.backgroundColor = .white
        
        [profileImageView, userMusicListTableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        userMusicListTableView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 70).isActive = true
        userMusicListTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        userMusicListTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userMusicListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
    }
}

extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMusics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userMusicListTableView.dequeueReusableCell(withIdentifier: UITableView.userMusicListTableCellID, for: indexPath) as! UserMusicListTableCell
        cell.userMusic = self.userMusics[indexPath.row]
        return cell
    }
}
