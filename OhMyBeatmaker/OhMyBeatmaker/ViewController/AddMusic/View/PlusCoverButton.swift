//
//  PlusCoverButton.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/07.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class PlusCoverButton: UIButton {
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("커버 추가", for: .normal)
        setTitleColor(.black, for: .normal)
        imageView?.contentMode = .scaleAspectFill
        layer.cornerRadius = 15
        layer.masksToBounds = true
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
