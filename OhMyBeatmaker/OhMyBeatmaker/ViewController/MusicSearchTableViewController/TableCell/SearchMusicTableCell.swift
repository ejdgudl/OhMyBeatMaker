//
//  SearchMusicTableCell.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/14.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Kingfisher

class SearchMusicTableCell: UITableViewCell {
    
    // MARK: Properties
    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 48 / 2
        return imageView
    }()
    
    var music: Music? {
        didSet {
            guard let coverImageStrUrl = music?.coverImageUrl else {return}
            guard let coverImageUrl = URL(string: coverImageStrUrl) else {return}
            self.coverImageView.kf.setImage(with: coverImageUrl)
            guard let musicTitle = music?.musicTitle else {return}
            textLabel?.text = musicTitle
        }
    }
    
    
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
        
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        [coverImageView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        coverImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        coverImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        coverImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        coverImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

