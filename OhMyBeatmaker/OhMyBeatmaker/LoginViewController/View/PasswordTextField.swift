//
//  PasswordTextField.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class PasswordTextField: UITextField {
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        placeholder = "Password"
        backgroundColor = UIColor(white: 0, alpha: 0.03)
        borderStyle = .roundedRect
        font = UIFont.systemFont(ofSize: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

