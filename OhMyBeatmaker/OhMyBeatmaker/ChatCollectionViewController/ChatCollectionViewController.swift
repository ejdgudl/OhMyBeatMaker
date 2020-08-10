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
    
    private var containerView: UIView = {
       let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 55)
        return view
    }()
    
    private let messageTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Enter message..."
        return tf
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    let separatorView = UIView()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavi()
        configure()
        configureViews()
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: @Objc
    @objc private func handleInfoTapped() {
    
    }
    
    @objc private func handleSend() {
    
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
        
        [messageTextField, sendButton, separatorView].forEach {
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        messageTextField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        messageTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        messageTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        messageTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        
        separatorView.backgroundColor = .lightGray
        separatorView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }
}

extension ChatCollectionViewController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionView.chatCollectionCellID, for: indexPath) as! ChatCollectionCell
        return cell
    }
}
