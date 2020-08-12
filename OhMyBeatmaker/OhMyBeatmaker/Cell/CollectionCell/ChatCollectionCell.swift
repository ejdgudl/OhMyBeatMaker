//
//  ChatCollectionCell.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/10.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class ChatCollectionCell: UICollectionViewCell {
    
    // MARK: Properties
    let bubbleView: UIView = {
       let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let textView: UITextView = {
        let view = UITextView()
        view.text = "sample text"
        view.font = UIFont.systemFont(ofSize: 16)
        view.backgroundColor = .clear
        view.textColor = .white
        view.isEditable = false
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 32 / 2
        return imageView
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    private func configure() {
        
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        [bubbleView, textView, profileImageView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
        bubbleRightAnchor?.isActive = true
        
        bubbleLeftAnchor = bubbleView.rightAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleLeftAnchor?.isActive = false
        
        bubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
}
