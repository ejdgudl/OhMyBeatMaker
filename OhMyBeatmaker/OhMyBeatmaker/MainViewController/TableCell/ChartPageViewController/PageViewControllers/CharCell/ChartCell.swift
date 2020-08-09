//
//  ChartCell.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/09.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class ChartCell: UITableViewCell {
    
    // MARK: Properties
    var chartImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 11
        imageView.layer.masksToBounds = true
        imageView.tintColor = .black
        imageView.backgroundColor = .orange
        return imageView
    }()
    
    var musicTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Song Title"
        return label
    }()
    
    var artistNickName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        label.text = "artist"
        return label
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "playButton"), for: .normal)
        button.addTarget(self, action: #selector(didTapPlaybutton), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: @Objc
    @objc private func didTapPlaybutton() {
        if player?.rate == 0 {
            player?.play()
            playButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            player?.pause()
            playButton.setImage(UIImage(named: "playButton"), for: .normal)
        }
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        selectionStyle = .none
        [chartImageView, musicTitle, artistNickName, playButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        chartImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        chartImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        chartImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        chartImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        musicTitle.bottomAnchor.constraint(equalTo: chartImageView.centerYAnchor, constant: -3).isActive = true
        musicTitle.leftAnchor.constraint(equalTo: chartImageView.rightAnchor, constant: 5).isActive = true
        
        artistNickName.topAnchor.constraint(equalTo: chartImageView.centerYAnchor, constant: 3).isActive = true
        artistNickName.leftAnchor.constraint(equalTo: chartImageView.rightAnchor, constant: 5).isActive = true
        
        playButton.centerYAnchor.constraint(equalTo: chartImageView.centerYAnchor).isActive = true
        playButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 17).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
    }
}
