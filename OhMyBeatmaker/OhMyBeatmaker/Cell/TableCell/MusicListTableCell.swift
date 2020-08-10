//
//  MusicListTableCell.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/09.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class MusicListTableCell: UITableViewCell {
    
    // MARK: Properties
    let pageView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    private func configure() {
        selectionStyle = .none
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        backgroundColor = .clear
        
        addSubview(pageView)
        pageView.translatesAutoresizingMaskIntoConstraints = false
        
        pageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        pageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        pageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        pageView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
    }
}
