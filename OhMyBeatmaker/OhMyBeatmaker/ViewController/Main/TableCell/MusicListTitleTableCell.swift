//
//  MusicListTitleCell.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/09.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class MusicListTitleTableCell: UITableViewCell {
    
    // MARK: Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "추천 음악"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
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
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 3).isActive = true
    }
    
}
