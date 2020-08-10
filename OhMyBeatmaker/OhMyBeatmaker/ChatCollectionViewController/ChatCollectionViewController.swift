//
//  ChatCollectionViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/10.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class ChatCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    var user: User?
    var messages = [Message]()
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavi()
        configure()
        configureViews()
    }
    
    // MARK: @Objc
    @objc private func handleInfoTapped() {
    
    }
    
    // MARK: Helpers
    private func configureNavi() {
        guard let user = self.user else {return}
        title = user.nickName
        
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(handleInfoTapped), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = infoBarButtonItem
    }
    
    // MARK: Configure
    private func configure() {
        collectionView.register(ChatCollectionCell.self, forCellWithReuseIdentifier: UICollectionView.chatCollectionCellID)
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        collectionView.backgroundColor = .white
        
    }
}

extension ChatCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionView.chatCollectionCellID, for: indexPath) as! ChatCollectionCell
        return cell
    }
}
