//
//  MusicVolumeSlider.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/14.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class MusicVolumeSlider: UISlider {
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        minimumValue = 0
        maximumValue = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
