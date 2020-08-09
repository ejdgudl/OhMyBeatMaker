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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureViews()
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
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableView.searchTableCellID, for: indexPath)
        return cell
    }
}
