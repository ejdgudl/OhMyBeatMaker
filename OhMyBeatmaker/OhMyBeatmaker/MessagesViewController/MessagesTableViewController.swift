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
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureViews()
    }
    
    // MARK: @Objc
    @objc private func handleNewMessage() {
        
    }
    
    
    // MARK: Configure
    private func configure() {
        tableView.register(MessagesTableCell.self, forCellReuseIdentifier: UITableView.messagesTableCellID)
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        title = "Messages"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewMessage))
    }
}

extension MessagesTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableView.messagesTableCellID, for: indexPath) as! MessagesTableCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("z")
    }
}
