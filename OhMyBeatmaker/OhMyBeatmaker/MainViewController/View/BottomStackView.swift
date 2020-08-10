//
//  BottomStackView.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/07.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class BottomStackView: UIStackView {
    
    // MARK: Properties
    var indicator: IndicatorView = {
        var indicator = IndicatorView(frame: accessibilityFrame())
        return indicator
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        spacing = 10
        distribution = .fillEqually
        
        addSubview(indicator)
        indicator.layer.zPosition = 999
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
