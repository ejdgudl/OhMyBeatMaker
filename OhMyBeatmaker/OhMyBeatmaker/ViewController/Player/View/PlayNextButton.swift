//
//  PlayNextButton.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/14.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class PlayNextButton: UIButton {
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(UIImage(named: "playNext"), for: .normal)
        tintColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
