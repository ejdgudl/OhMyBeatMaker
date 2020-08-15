//
//  UserMusicListTableCell.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/15.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Kingfisher

class UserMusicListTableCell: UITableViewCell {
    
    // MARK: Properties
    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    let musicTitleNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "playButton"), for: .normal)
        button.addTarget(self, action: #selector(didTapPlaybutton), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    var userMusic: Music? {
        didSet {
            guard let userMusic = userMusic else {return}
            guard let coverImageStrUrl = userMusic.coverImageUrl else {return}
            guard let coverImageUrl = URL(string: coverImageStrUrl) else {return}
            coverImageView.kf.setImage(with: coverImageUrl)
            guard let musicTitle = userMusic.musicTitle else {return}
            musicTitleNameLabel.text = musicTitle
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
    
    // MARK: @Objc
    @objc private func didTapPlaybutton() {
        print("didTap")
    }
    
    // MARK: Configure
    private func configure() {
        selectionStyle = .none
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        [coverImageView, musicTitleNameLabel, playButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        coverImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        coverImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        coverImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        coverImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        musicTitleNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        musicTitleNameLabel.leftAnchor.constraint(equalTo: coverImageView.rightAnchor, constant: 15).isActive = true
        
        playButton.centerYAnchor.constraint(equalTo: coverImageView.centerYAnchor).isActive = true
        playButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 17).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
    }
}
