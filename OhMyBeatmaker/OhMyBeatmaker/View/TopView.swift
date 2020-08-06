//
//  TopView.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class TopView: UIView {
    
    // MARK: Properties
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Oh My Beat Maker"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "doc.plaintext"), for: .normal)
        return button
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        [containerView, editButton, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        containerView.addSubview(titleLabel)
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        containerView.addSubview(editButton)
        editButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        editButton.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
    }
}

