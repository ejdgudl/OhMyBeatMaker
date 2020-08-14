//
//  File.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/10.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class MessagesTableCell: UITableViewCell {
    
    
    // MARK: Properties
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 48 / 2
        return imageView
    }()
    
    let timestampLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.text = "2h"
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "aaaa"
        return label
    }()
    
    let messageTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "aaaaasdffasfda"
        return label
    }()
    
    var message: Message? {
        didSet {
            guard let messageText = message?.messageText else {return}
            messageTextLabel.text = messageText
            if let seconds = message?.creationDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                timestampLabel.text = dateFormatter.string(from: seconds)
            }
            configureUserData()
        }
    }
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        congifure()
        congifureViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configureUserData() {
        guard let chatPartnerId = message?.getChatPartnerId() else {return}
        fetchUser(with: chatPartnerId) { (user) in
            guard let profileImageStrUrl = user.profileImageUrl else {return}
            guard let profileImageUrl = URL(string: profileImageStrUrl) else {return}
            self.profileImageView.kf.setImage(with: profileImageUrl)
            self.usernameLabel.text = user.nickName
        }
    }
    
    func fetchUser(with uid: String, completion: @escaping(User) -> ()) {
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    // MARK: Configure
    private func congifure() {
        selectionStyle = .none
    }
    
    // MARK: ConfigureViews
    private func congifureViews() {
        [profileImageView, timestampLabel, usernameLabel, messageTextLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        timestampLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        timestampLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        
        usernameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 4).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        
        messageTextLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 6).isActive = true
        messageTextLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
    }
}
