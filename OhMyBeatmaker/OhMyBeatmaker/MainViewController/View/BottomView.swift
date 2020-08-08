//
//  BottomView.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/08.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class BottomButton: UIButton {
    
    // MARK: Properties
    var bottomImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: " ")
        imageView.backgroundColor = .red
        return imageView
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: @Objc
    
    // MARK: Configure
    private func configure() {
        
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        backgroundColor = .gray
        
        addSubview(bottomImageView)
        bottomImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        bottomImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        bottomImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        bottomImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
