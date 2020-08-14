//
//  FirstVC.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/09.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase

protocol FirstPageVCDelegate: class{
    func sendMusicTitle(musicTitle: String)
}

class FirstVC: UIViewController {
    
    // MARK: Properties
    private let musicListTitleView: MusicTitleHeaderView = {
        let view = MusicTitleHeaderView()
        view.headerTitle.text = "Top5"
        return view
    }()
    
    let firstMusicListView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.separatorStyle = .none
//        view.isScrollEnabled = true
        return view
    }()
    
    let db = Database.database().reference()
    
    weak var firstPageVCDelegate: FirstPageVCDelegate?
    
    var musics = [Music]() {
        didSet {
            musics.shuffle()
            firstMusicListView.reloadData()
        }
    }
    
    var newMusic: [String]? {
        didSet {
            guard let newMusic = newMusic else {return}
            firstMusicListView.reloadData()
//            guard let music = newMusic else {return}
//            db.child("Musics").child(music).observeSingleEvent(of: .value) { (snapshot) in
//                guard let value = snapshot.value as? [String: Any] else {return}
//                guard let title = value["musicTitle"] as? String else {return}
//                self.musicTitleLabel.text = title
//                guard let artistNickName = value["artistNickName"] as? String else {return}
//                self.artistNameLabel.text = artistNickName
//                guard let imageUrlStr = value["coverImageUrl"] as? String else {return}
//                guard let imageUrl = URL(string: imageUrlStr) else {return}
//                self.coverImage.kf.setImage(with: imageUrl)
//            }
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMusic()
        configure()
        configureViews()
    }
    
    private func fetchMusic() {
        db.child("Musics").observe(.childAdded) { (snapShot) in
            let musicTitle = snapShot.key
            guard let dictionary = snapShot.value as? Dictionary<String, AnyObject> else {return}
            let music = Music(musicTitle: musicTitle, dictionary: dictionary)
            self.musics.append(music)
        }
    }
    
    // MARK: Configure
    private func configure() {
        firstMusicListView.delegate = self
        firstMusicListView.dataSource = self
        firstMusicListView.register(MusicListCell.self, forCellReuseIdentifier: UITableView.musicCellID)
    }
    
    // MARK: ConfigureViews
    func configureViews() {
        view.backgroundColor = .clear
        
        [musicListTitleView, firstMusicListView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        musicListTitleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        musicListTitleView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        musicListTitleView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        musicListTitleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        firstMusicListView.topAnchor.constraint(equalTo: musicListTitleView.bottomAnchor).isActive = true
        firstMusicListView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        firstMusicListView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        firstMusicListView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
    }
    
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension FirstVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let newMusic = self.newMusic else {return 0 }
        return newMusic.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let musicListCell = firstMusicListView.dequeueReusableCell(withIdentifier: UITableView.musicCellID, for: indexPath) as? MusicListCell else {fatalError()}
        guard let newMusic = self.newMusic else {fatalError()}
        musicListCell.topMusic = newMusic[indexPath.row]
        musicListCell.musicListCellDelegate = self
        return musicListCell
    }
}

extension FirstVC: MusicListCellDelegate {
    func sendMusicTitle(musicTitle: String) {
        firstPageVCDelegate?.sendMusicTitle(musicTitle: musicTitle)
    }
}
