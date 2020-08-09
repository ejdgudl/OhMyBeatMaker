//
//  UserSearchTableViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/09.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase

class UserSearchTableViewController: UITableViewController {

    // MARK: Properties
    var users = [User]()
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        configure()
        configureViews()
    }
    
    // MARK: Helpers
    private func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {return}
            
            let user = User(uid: uid, dictionary: dictionary)
            self.users.append(user)
            self.tableView.reloadData()
        }
    }
    
    // MARK: Configure
    private func configure() {
        tableView.register(SearchTableCell.self, forCellReuseIdentifier: UITableView.searchTableCellID)
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        navigationController?.navigationBar.isHidden = false
        title = "유저 찾기"
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 0)
    }
}

extension UserSearchTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableView.searchTableCellID, for: indexPath) as! SearchTableCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
    }
}
