//
//  PlayerViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/08.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase

class PlayerViewController: UIViewController {
    
    // MARK: Properties
    private var topMarkLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 3
        return view
    }()
    
    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        //        imageView.image = UIImage(named: "")
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 11
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 25, height: view.frame.width - 25)
        return imageView
    }()
    
    var musicTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "Song Title"
        return label
    }()
    
    var artistNickName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .red
        label.text = "artist"
        return label
    }()
    
    private var musicTimeSlider: UISlider = {
        let slider = UISlider()
        return slider
    }()
    
    private var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "playButton"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private var playBeforeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "playBefore"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private var playNextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "playNext"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private var musicVolumeSlider: UISlider = {
        let slider = UISlider()
        return slider
    }()
    
    private let volumeMinView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "speaker.slash.fill")
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    private let volumeMaxView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "speaker.fill")
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    private let db = Database.database().reference()
    
    var newMusic: String? {
        didSet {
            guard let music = newMusic else {return}
            db.child("Musics").child(music).observeSingleEvent(of: .value) { (snapshot) in
                guard let value = snapshot.value as? [String: Any] else {return}
                guard let title = value["musicTitle"] as? String else {return}
                self.musicTitle.text = title
                guard let artistNickName = value["artistNickName"] as? String else {return}
                self.artistNickName.text = artistNickName
                guard let imageUrlStr = value["coverImageUrl"] as? String else {return}
                guard let imageUrl = URL(string: imageUrlStr) else {return}
                URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                    guard error == nil else {return}
                    guard let data = data else {return}
                    DispatchQueue.main.async {
                        self.coverImageView.image = UIImage(data: data)
                    }
                }.resume()
            }
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureViews()
    }
    
    
    // MARK: Helpers
    
    
    // MARK: Configure
    private func configure() {
        
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        view.backgroundColor = .white
        
        [topMarkLine, coverImageView, musicTitle, artistNickName, musicTimeSlider, playBeforeButton, playButton, playNextButton, volumeMinView, musicVolumeSlider, volumeMaxView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        topMarkLine.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height * -0.45).isActive = true
        topMarkLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topMarkLine.widthAnchor.constraint(equalToConstant: 60).isActive = true
        topMarkLine.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        coverImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height * -0.209).isActive = true
        coverImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        coverImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        coverImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        musicTitle.bottomAnchor.constraint(equalTo: artistNickName.topAnchor, constant: -4).isActive = true
        musicTitle.leftAnchor.constraint(equalTo: coverImageView.leftAnchor).isActive = true
        
        artistNickName.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height * 0.335)).isActive = true
        artistNickName.leftAnchor.constraint(equalTo: coverImageView.leftAnchor).isActive = true
        
        musicTimeSlider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height * 0.243)).isActive = true
        musicTimeSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        musicTimeSlider.widthAnchor.constraint(equalTo: coverImageView.widthAnchor).isActive = true
        
        playBeforeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        playBeforeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        playBeforeButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor).isActive = true
        playBeforeButton.rightAnchor.constraint(equalTo: playButton.leftAnchor, constant: -60).isActive = true
        
        playButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        playButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height * 0.15)).isActive = true
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        playNextButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        playNextButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        playNextButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor).isActive = true
        playNextButton.leftAnchor.constraint(equalTo: playButton.rightAnchor, constant: 60).isActive = true
        
        volumeMinView.centerYAnchor.constraint(equalTo: musicVolumeSlider.centerYAnchor).isActive = true
        volumeMinView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        volumeMinView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        volumeMinView.rightAnchor.constraint(equalTo: musicVolumeSlider.leftAnchor, constant: -15).isActive = true
        
        musicVolumeSlider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height * 0.07)).isActive = true
        musicVolumeSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        musicVolumeSlider.widthAnchor.constraint(equalTo: coverImageView.widthAnchor, constant: -65).isActive = true
        
        volumeMaxView.centerYAnchor.constraint(equalTo: musicVolumeSlider.centerYAnchor).isActive = true
        volumeMaxView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        volumeMaxView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        volumeMaxView.leftAnchor.constraint(equalTo: musicVolumeSlider.rightAnchor, constant: 15).isActive = true
    }
    
}

