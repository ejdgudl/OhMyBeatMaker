//
//  NewMessageViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/10.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase

class NewMessageViewController: UITableViewController {
    
    // MARK: Properties
    var users = [User]()
    var messagesTableViewController: MessagesTableViewController?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        configure()
        configureViews()
    }
    
    // MARK: @Objc
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: Helpler
    private func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            if uid != Auth.auth().currentUser?.uid {
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {return}
                let user = User(uid: uid, dictionary: dictionary)
                self.users.append(user)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: Configure
    private func configure() {
        tableView.register(NewMessageTableCell.self, forCellReuseIdentifier: UITableView.newMessageTableCellID)
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationController?.navigationBar.tintColor = .black
    }
}

extension NewMessageViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableView.newMessageTableCellID, for: indexPath) as! NewMessageTableCell
        cell.user = self.users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messagesTableViewController?.showChatCollectionVC(for: user)
        }
    }
}
