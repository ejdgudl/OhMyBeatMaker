//
//  CoverCell.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase

protocol DidTapPlayButtonFirstDelegate: class {
    func didTapPlayButton(newMusic: String)
}

class CoverCollectionCell: UICollectionViewCell {
    
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
    
    private let musicTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "노래제목"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "아티스트"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    private let db = Database.database().reference()
    
    weak var delegate: DidTapPlayButtonFirstDelegate?
    
    var newMusic: String? {
        didSet {
            print("newMusic didSet in the collection")
            guard let music = newMusic else {return}
            db.child("Musics").child(music).observeSingleEvent(of: .value) { (snapshot) in
                guard let value = snapshot.value as? [String: Any] else {return}
                guard let title = value["musicTitle"] as? String else {return}
                self.musicTitleLabel.text = title
                guard let artistNickName = value["artistNickName"] as? String else {return}
                self.artistNameLabel.text = artistNickName
                guard let imageUrlStr = value["coverImageUrl"] as? String else {return}
                guard let imageUrl = URL(string: imageUrlStr) else {return}
                URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                    guard error == nil else {return}
                    guard let data = data else {return}
                    DispatchQueue.main.async {
                        self.coverImage.image = UIImage(data: data)
                    }
                }.resume()
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
        guard let newMusic = self.newMusic else {return}
        delegate?.didTapPlayButton(newMusic: newMusic)
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        layer.cornerRadius = 15
        layer.masksToBounds = true
        
        [coverImage, playButtonInCover, musicTitleLabel, artistNameLabel].forEach {
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
        
        musicTitleLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 5).isActive = true
        musicTitleLabel.leftAnchor.constraint(equalTo: coverImage.leftAnchor).isActive = true
        
        artistNameLabel.topAnchor.constraint(equalTo: musicTitleLabel.bottomAnchor, constant: 2).isActive = true
        artistNameLabel.leftAnchor.constraint(equalTo: coverImage.leftAnchor).isActive = true
    }
    
}

