//
//  PlayerViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/08.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import Kingfisher

var player: AVPlayer?

class PlayerViewController: UIViewController {
    
    // MARK: Properties
    private var topMarkLine: TopMarkLine = {
        let view = TopMarkLine()
        return view
    }()
    
    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 25, height: view.frame.width - 25)
        imageView.layer.cornerRadius = 11
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var musicTitleLabel: MusicTitleLabel = {
        let label = MusicTitleLabel()
        return label
    }()
    
    var artistNickName: ArtistNickName = {
        let label = ArtistNickName()
        return label
    }()
    
    private let currentTimeLabel: CurrentTimeLabel = {
        let label = CurrentTimeLabel()
        return label
    }()
    
    private lazy var musicTimeSlider: MusicTimeSlider = {
        let slider = MusicTimeSlider()
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    private let musicLengthLabel: MusicLengthLabel = {
        let label = MusicLengthLabel()
        return label
    }()
    
    lazy var playButton: PlayButton = {
        let button = PlayButton(type: .system)
        button.addTarget(self, action: #selector(didTapPlaybutton), for: .touchUpInside)
        return button
    }()
    
    private var playBeforeButton: PlayBeforeButton = {
        let button = PlayBeforeButton(type: .system)
        return button
    }()
    
    private var playNextButton: PlayNextButton = {
        let button = PlayNextButton(type: .system)
        return button
    }()
    
    private lazy var musicVolumeSlider: MusicVolumeSlider = {
        let slider = MusicVolumeSlider()
        slider.addTarget(self, action: #selector(handleVolumeSliderChange), for: .valueChanged)
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
    
    var playerItem: AVPlayerItem?
    
    private let db = Database.database().reference()
    
    var mainVC: MainViewController?
    
    var dictValues = [String: Int]()
    var sortedArray = [Dictionary<String, Int>.Element]()
    
    var musicTitle: String? {
        didSet {
            guard let music = musicTitle else {return}
            db.child("Musics").child(music).observeSingleEvent(of: .value) { (snapshot) in
                guard let musicData = snapshot.value as? [String: Any] else {return}
                guard let title = musicData["musicTitle"] as? String else {return}
                self.musicTitleLabel.text = title
                guard let artistNickName = musicData["artistNickName"] as? String else {return}
                self.artistNickName.text = artistNickName
                guard let imageUrlStr = musicData["coverImageUrl"] as? String else {return}
                guard let imageUrl = URL(string: imageUrlStr) else {return}
                self.coverImageView.kf.setImage(with: imageUrl)
                guard let mp3Url = musicData["musicFileUrl"] as? String else {return}
                self.playMusic(mp3FileUrl: mp3Url, musicTitle: title)
            }
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: @Objc
    @objc private func handleVolumeSliderChange() {
        player?.volume = musicVolumeSlider.value
    }
    
    @objc private func handleSliderChange() {
        if let duration = player?.currentItem?.duration {
            let totalSeocnds = CMTimeGetSeconds(duration)
            let value = Float64(musicTimeSlider.value) * totalSeocnds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                print(seekTime)
            })
        }
    }
    
    @objc private func didTapPlaybutton() {
        guard let mainVC = self.mainVC else {return}
        if player?.rate == 0 {
            player?.play()
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.coverImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
            mainVC.bottomButton.playButton.setImage(UIImage(named: "pause"), for: .normal)
            playButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            player?.pause()
            UIView.animate(withDuration: 0.3) {
                self.coverImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
            mainVC.bottomButton.playButton.setImage(UIImage(named: "playButton"), for: .normal)
            playButton.setImage(UIImage(named: "playButton"), for: .normal)
        }
    }
    
    // MARK: Helpers
    func playMusic(mp3FileUrl: String, musicTitle: String) {
        
        if player?.currentItem != nil {
            player?.pause()
        }
        
        // Like + 1
        db.child("Musics").child(musicTitle).observeSingleEvent(of: .value, with: { (snapshot) in
            let musicTitle = snapshot.key
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {return}
            let music = Music(musicTitle: musicTitle, dictionary: dictionary)
            guard var like = music.like else {return}
            like += 1
            self.db.child("Musics").child(musicTitle).updateChildValues(["like" : like])
        })
        
        // Make Top5
        db.child("Musics").observe(.childAdded) { (snapshot) in
            let musicTitle = snapshot.key
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {return}
            let music = Music(musicTitle: musicTitle, dictionary: dictionary)
            self.dictValues[music.musicTitle] = music.like
            self.sortedArray = self.dictValues.sorted { $0.1 > $1.1 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if self.sortedArray.count >= 6 {
                self.sortedArray.removeSubrange(5...)
                var top5List = [String]()
                for item in self.sortedArray {
                    top5List.append(item.0)
                }
                self.db.updateChildValues(["Top5": top5List])
            } else {
                var top5List = [String]()
                for item in self.sortedArray {
                    top5List.append(item.0)
                }
                self.db.updateChildValues(["Top5": top5List])
            }
        }
        
        // Play
        let url = URL(string: mp3FileUrl)
        self.playerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: self.playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
        self.view.layer.addSublayer(playerLayer)
        player?.play()
        self.playButton.setImage(UIImage(named: "pause"), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                var secondsString = String(format: "%02d", Int(seconds) % 60)
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                if secondsString.count == 1 {
                    secondsString = "0" + secondsString
                }
                self.musicLengthLabel.text = "\(minutesText):\(secondsString)"
                
                let interval = CMTime(value: 1, timescale: 2)
                player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { (progressTime) in
                    let seconds = CMTimeGetSeconds(progressTime)
                    let secondsString = String(format: "%02d", Int(seconds) % 60)
                    let minutesText = String(format: "%02d", Int(seconds) / 60)
                    self.currentTimeLabel.text = "\(minutesText):\(secondsString)"
                    
                    let durationSeconds = CMTimeGetSeconds(duration)
                    self.musicTimeSlider.value = Float(seconds / durationSeconds)
                })
            }
        }
        self.musicVolumeSlider.setValue(AVAudioSession.sharedInstance().outputVolume, animated: true)
        player?.volume = AVAudioSession.sharedInstance().outputVolume
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        view.backgroundColor = .white
        
        [topMarkLine, coverImageView, musicTitleLabel, artistNickName, musicTimeSlider, musicLengthLabel, currentTimeLabel, playBeforeButton, playButton, playNextButton, volumeMinView, musicVolumeSlider, volumeMaxView].forEach {
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
        coverImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        musicTitleLabel.bottomAnchor.constraint(equalTo: artistNickName.topAnchor, constant: -4).isActive = true
        musicTitleLabel.leftAnchor.constraint(equalTo: coverImageView.leftAnchor).isActive = true
        
        artistNickName.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height * 0.335)).isActive = true
        artistNickName.leftAnchor.constraint(equalTo: coverImageView.leftAnchor).isActive = true
        
        musicTimeSlider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height * 0.243)).isActive = true
        musicTimeSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        musicTimeSlider.widthAnchor.constraint(equalTo: coverImageView.widthAnchor).isActive = true
        
        musicLengthLabel.topAnchor.constraint(equalTo: musicTimeSlider.bottomAnchor, constant: -5).isActive = true
        musicLengthLabel.rightAnchor.constraint(equalTo: musicTimeSlider.rightAnchor).isActive = true
        musicLengthLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        musicLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        currentTimeLabel.topAnchor.constraint(equalTo: musicTimeSlider.bottomAnchor, constant: -5).isActive = true
        currentTimeLabel.leftAnchor.constraint(equalTo: musicTimeSlider.leftAnchor).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
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

