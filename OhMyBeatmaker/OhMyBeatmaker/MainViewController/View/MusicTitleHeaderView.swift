//
//  ChartHeaderView.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/09.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class MusicTitleHeaderView: UIView {
    
    // MARK: Properties
    var headerTitle: UILabel = {
        let label = UILabel()
        label.text = "Entire Music"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        addSubview(headerTitle)
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        
        headerTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        headerTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
    }
}
