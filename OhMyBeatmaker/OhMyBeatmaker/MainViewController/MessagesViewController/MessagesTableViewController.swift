//
//  MessagesViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/10.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableViewController: UITableViewController {
    
    
    // MARK: Properties
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureViews()
        fetchMessages()
    }
    
    // MARK: @Objc
    @objc private func handleNewMessage() {
        let newMessageTalbeVC = NewMessageViewController()
        newMessageTalbeVC.messagesTableViewController = self
        let navVC = UINavigationController(rootViewController: newMessageTalbeVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    // MARK: Helpers
    func showChatCollectionVC(for user: User) {
        let chatCollectionVC = ChatCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatCollectionVC.user = user
        navigationController?.pushViewController(chatCollectionVC, animated: true)
    }
    
    private func fetchMessages() {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        self.messages.removeAll()
        self.messagesDictionary.removeAll()
        self.tableView.reloadData()
        
        Database.database().reference().child("user-messages").child(currentUid).observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            Database.database().reference().child("user-messages").child(currentUid).child(uid).observe(.childAdded) { (snapshot) in
                let messageId = snapshot.key
                self.fetchMessage(withMessageId: messageId)
            }
        }
    }
    
    private func fetchMessage(withMessageId messageId: String) {
        Database.database().reference().child("messages").child(messageId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {return}
            let message = Message(dictionary: dictionary)
            let chatPartnerId = message.getChatPartnerId()
            self.messagesDictionary[chatPartnerId] = message
            self.messages = Array(self.messagesDictionary.values)
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: Configure
    private func configure() {
        tableView.register(MessagesTableCell.self, forCellReuseIdentifier: UITableView.messagesTableCellID)
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        navigationController?.navigationBar.tintColor = .black
        title = "Messages"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewMessage))
    }
}

extension MessagesTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableView.messagesTableCellID, for: indexPath) as! MessagesTableCell
        cell.message = self.messages[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        let chatPartnerId = message.getChatPartnerId()
        Database.database().reference().child("users").child(chatPartnerId).observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {return}
            let user = User(uid: uid, dictionary: dictionary)
            self.showChatCollectionVC(for: user)
        }
    }
}
