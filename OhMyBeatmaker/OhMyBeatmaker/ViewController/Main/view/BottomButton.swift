//
//  BottomButton.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/08.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

protocol ChangeButtonImageDelegate: class {
    func changeButtonImage(imageName: String)
}

class BottomButton: UIButton {
    
    // MARK: Properties
    var bottomImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 11
        imageView.layer.masksToBounds = true
        imageView.tintColor = .black
        imageView.backgroundColor = .white
        return imageView
    }()
    
    var musicTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.adjustsFontSizeToFitWidth = true
        label.text = "재생중인 곡이 없습니다"
        return label
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "playButton"), for: .normal)
        button.addTarget(self, action: #selector(didTapPlaybutton), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    private let db = Database.database().reference()
    
    weak var changeButtonImageDelegate: ChangeButtonImageDelegate?
    
    var newMusic: String? {
        didSet {
            guard let music = newMusic else {return}
            db.child("Musics").child(music).observeSingleEvent(of: .value) { (snapshot) in
                guard let value = snapshot.value as? [String: Any] else {return}
                guard let title = value["musicTitle"] as? String else {return}
                self.musicTitle.text = title
                guard let imageUrlStr = value["coverImageUrl"] as? String else {return}
                guard let imageUrl = URL(string: imageUrlStr) else {return}
                self.bottomImageView.kf.setImage(with: imageUrl)
            }
        }
    }
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: @Objc
    @objc private func didTapPlaybutton() {
        if player?.rate == 0 {
            player?.play()
            changeButtonImageDelegate?.changeButtonImage(imageName: "pause")
            playButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            player?.pause()
            changeButtonImageDelegate?.changeButtonImage(imageName: "playButton")
            playButton.setImage(UIImage(named: "playButton"), for: .normal)
        }
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        backgroundColor = .lightGray
        [bottomImageView, musicTitle, playButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        bottomImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        bottomImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        bottomImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        bottomImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        musicTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        musicTitle.leftAnchor.constraint(equalTo: bottomImageView.rightAnchor, constant: 15).isActive = true
        musicTitle.heightAnchor.constraint(equalToConstant: 35).isActive = true
        musicTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        playButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        playButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
}
