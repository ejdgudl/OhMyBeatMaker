//
//  EditTableHeaderView.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/07.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class EditTableHeaderView: UIView {
    
    // MARK: Properties
    let headerTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
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
        backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 0.7)
        
        addSubview(headerTitle)
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        
        headerTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        headerTitle.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
