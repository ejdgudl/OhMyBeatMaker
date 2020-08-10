//
//  LoginButton.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/07.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class LoginButton: UIButton {
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .center
        setTitle("로그인", for: .normal)
        setTitleColor(.black, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        adjustsImageWhenDisabled = false
        layer.cornerRadius = 25
        layer.masksToBounds = true
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
