//
//  CustomIndicatorView.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class IndicatorView: UIActivityIndicatorView {
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    func startActivityIndicator() {
        style = .large
        color = .red
        startAnimating()
    }
    
    func stopActivityIndicator() {
        stopAnimating()
        removeFromSuperview()
    }
}

