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
    
    lazy var searchBar: SearchBar = {
       let searchBar = SearchBar()
        searchBar.delegate = self
        return searchBar
    }()
    
    private var searchedUsers = [User]()
    private var searchMode = false
    
    private let db = Database.database().reference()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        configure()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: @Objc
    @objc func searchTapped() {
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = nil
        searchBar.becomeFirstResponder()
    }
    
    // MARK: Helpers
    private func fetchUser() {
        db.child("users").observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {return}
            if Auth.auth().currentUser?.uid != uid {
                let user = User(uid: uid, dictionary: dictionary)
                self.users.append(user)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: Configure
    private func configure() {
        tableView.register(SearchTableCell.self, forCellReuseIdentifier: UITableView.searchTableCellID)
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        title = "유저 찾기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
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
        if searchMode == false {
            return users.count
        } else {
            return searchedUsers.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableView.searchTableCellID, for: indexPath) as! SearchTableCell
        var user: User?
        if searchMode == false {
            user = users[indexPath.row]
        } else {
            user = searchedUsers[indexPath.row]
        }
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var user: User?
        if searchMode == false {
             user = users[indexPath.row]
        } else {
            user = searchedUsers[indexPath.row]
        }
        let userProfileVC = UserProfileViewController()
        userProfileVC.user = user
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
}

extension UserSearchTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        searchBar.text = ""
        searchMode = false
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchMode = false
            tableView.reloadData()
        } else {
            searchMode = true
            let matchingUsers = self.users.filter { (user) -> Bool in
                guard let nickName = user.nickName else {return false}
                return nickName.lowercased().contains(searchText.lowercased())
            }
            self.searchedUsers = matchingUsers
            tableView.reloadData()
        }
    }
}
