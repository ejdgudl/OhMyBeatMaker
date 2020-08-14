//
//  CoverCell.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

protocol DidTapPlayButtonFirstDelegate: class {
    func didTapPlayButton(newMusic: String)
}

class NewMusicCoverCollectionCell: UICollectionViewCell {
    
    private let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cover")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var playButtonInCover: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.circle"), for: .normal)
        button.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        return button
    }()
    
    private let musicTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    let artistNickName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    private let db = Database.database().reference()
    
    weak var didTapPlayButtonFirstDelegate: DidTapPlayButtonFirstDelegate?
    
    var new5ArrayOf1: String? {
        didSet {
            guard let new5ArrayOf1 = new5ArrayOf1 else {return}
            db.child("Musics").child(new5ArrayOf1).observeSingleEvent(of: .value) { (snapshot) in
                guard let musicData = snapshot.value as? [String: Any] else {return}
                guard let title = musicData["musicTitle"] as? String else {return}
                self.musicTitle.text = title
                guard let artistNickName = musicData["artistNickName"] as? String else {return}
                self.artistNickName.text = artistNickName
                guard let imageUrlStr = musicData["coverImageUrl"] as? String else {return}
                guard let imageUrl = URL(string: imageUrlStr) else {return}
                self.coverImage.kf.setImage(with: imageUrl)
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
    @objc private func didTapPlayButton() {
        guard let newMusic = self.new5ArrayOf1 else {return}
        didTapPlayButtonFirstDelegate?.didTapPlayButton(newMusic: newMusic)
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        layer.cornerRadius = 15
        layer.masksToBounds = true
        
        [coverImage, playButtonInCover, musicTitle, artistNickName].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        coverImage.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        coverImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        coverImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        coverImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        playButtonInCover.translatesAutoresizingMaskIntoConstraints = false
        playButtonInCover.topAnchor.constraint(equalTo: coverImage.topAnchor, constant: 2).isActive = true
        playButtonInCover.rightAnchor.constraint(equalTo: coverImage.rightAnchor, constant: -2).isActive = true
        playButtonInCover.widthAnchor.constraint(equalToConstant: 30).isActive = true
        playButtonInCover.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        musicTitle.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 5).isActive = true
        musicTitle.leftAnchor.constraint(equalTo: coverImage.leftAnchor).isActive = true
        
        artistNickName.topAnchor.constraint(equalTo: musicTitle.bottomAnchor, constant: 2).isActive = true
        artistNickName.leftAnchor.constraint(equalTo: coverImage.leftAnchor).isActive = true
    }
}

