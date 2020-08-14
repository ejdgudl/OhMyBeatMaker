//
//  ChartCell.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/09.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

protocol MusicListCellDelegate: class {
    func sendMusicTitle(musicTitle: String)
}

class MusicListCell: UITableViewCell {
    
    // MARK: Properties
    var musicListImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 11
        imageView.layer.masksToBounds = true
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
    
    weak var musicListCellDelegate: MusicListCellDelegate?
    private let db = Database.database().reference()
    
    var music: Music? {
        didSet {
            guard let music = music else {return}
            guard let imageUrlStr = music.coverImageUrl else {return}
            guard let imageUrl = URL(string: imageUrlStr) else {return}
            self.musicListImageView.kf.setImage(with: imageUrl)
            guard let title = music.musicTitle else {return}
            self.musicTitle.text = title
            guard let artistNickName = music.artistNickName else {return}
            self.artistNickName.text = artistNickName
        }
    }
    
    var topMusic: String? {
        didSet {
            print("newMusic didSet in the collection")
            guard let music = topMusic else {return}
            db.child("Musics").child(music).observeSingleEvent(of: .value) { (snapshot) in
                guard let value = snapshot.value as? [String: Any] else {return}
                guard let title = value["musicTitle"] as? String else {return}
                self.musicTitle.text = title
                guard let artistNickName = value["artistNickName"] as? String else {return}
                self.artistNickName.text = artistNickName
                guard let imageUrlStr = value["coverImageUrl"] as? String else {return}
                guard let imageUrl = URL(string: imageUrlStr) else {return}
                self.musicListImageView.kf.setImage(with: imageUrl)
            }
        }
    }
    
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
        guard let musicTitle = self.musicTitle.text else {return}
        musicListCellDelegate?.sendMusicTitle(musicTitle: musicTitle)
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        selectionStyle = .none
        [musicListImageView, musicTitle, artistNickName, playButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        musicListImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        musicListImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        musicListImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        musicListImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        musicTitle.bottomAnchor.constraint(equalTo: musicListImageView.centerYAnchor, constant: -3).isActive = true
        musicTitle.leftAnchor.constraint(equalTo: musicListImageView.rightAnchor, constant: 5).isActive = true
        
        artistNickName.topAnchor.constraint(equalTo: musicListImageView.centerYAnchor, constant: 3).isActive = true
        artistNickName.leftAnchor.constraint(equalTo: musicListImageView.rightAnchor, constant: 5).isActive = true
        
        playButton.centerYAnchor.constraint(equalTo: musicListImageView.centerYAnchor).isActive = true
        playButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 17).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
    }
}
