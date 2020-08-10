//
//  ChatCollectionViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/10.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase

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
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
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
        observeMessages()
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
        uploadMessageToServer()
        messageTextField.text = nil
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
    
    private func uploadMessageToServer() {
        guard let messageText = messageTextField.text else {return}
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        guard let userUid = self.user?.uid else {return}
        let creationDate = Int(NSDate().timeIntervalSince1970)
        let messageValues = [
            "creationDate": creationDate,
            "fromId": currentUid,
            "toId": userUid,
            "messageText": messageText
        ] as [String: Any]
        let messageRef = Database.database().reference().child("messages").childByAutoId()
        messageRef.updateChildValues(messageValues)
        
        guard let messageKey = messageRef.key else { return }
        
        Database.database().reference().child("user-messages").child(currentUid).child(userUid).updateChildValues([messageKey: 1])
        Database.database().reference().child("user-messages").child(userUid).child(currentUid).updateChildValues([messageKey: 1])
    }
    
    private func observeMessages() {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        guard let chatPartnerId = self.user?.uid else {return}
        Database.database().reference().child("user-messages").child(currentUid).child(chatPartnerId).observe(.childAdded) { (snapshot) in
            let messageId = snapshot.key
            self.fetchMessage(withMessageId: messageId)
        }
    }
    
    private func fetchMessage(withMessageId messageId: String) {
        Database.database().reference().child("messages").child(messageId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {return}
            let message = Message(dictionary: dictionary)
            self.messages.append(message)
            self.collectionView.reloadData()
        }
    }
    
    // MARK: Configure
    private func configure() {
        collectionView.register(ChatCollectionCell.self, forCellWithReuseIdentifier: UICollectionView.chatCollectionCellID)
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        collectionView.backgroundColor = .white
        
        [sendButton, messageTextField, separatorView].forEach {
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        messageTextField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        messageTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        messageTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -8).isActive = true
        messageTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
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
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionView.chatCollectionCellID, for: indexPath) as! ChatCollectionCell
        return cell
    }
}
