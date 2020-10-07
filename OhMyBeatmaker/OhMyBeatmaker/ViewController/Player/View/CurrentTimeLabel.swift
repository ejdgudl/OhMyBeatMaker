//
//  CurrentTimeLabel.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/14.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class CurrentTimeLabel: UILabel {
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        text = "00:00"
        textColor = .lightGray
        font = UIFont.boldSystemFont(ofSize: 8)
        textAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
