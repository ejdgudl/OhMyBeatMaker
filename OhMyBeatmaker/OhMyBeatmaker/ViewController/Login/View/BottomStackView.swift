//
//  BottomStackView.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/07.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class BottomStackView: UIStackView {
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        spacing = 10
        distribution = .fillEqually
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
