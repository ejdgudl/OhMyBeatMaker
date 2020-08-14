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
    private let MusicListTitleView: MusicTitleHeaderView = {
        let view = MusicTitleHeaderView()
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
        
        [MusicListTitleView, firstMusicListView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        MusicListTitleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        MusicListTitleView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        MusicListTitleView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        MusicListTitleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        firstMusicListView.topAnchor.constraint(equalTo: MusicListTitleView.bottomAnchor).isActive = true
        firstMusicListView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        firstMusicListView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        firstMusicListView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
    }
    
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension FirstVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musics.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let musicListCell = firstMusicListView.dequeueReusableCell(withIdentifier: UITableView.musicCellID, for: indexPath) as? MusicListCell else {fatalError()}
        musicListCell.music = self.musics[indexPath.row]
        musicListCell.musicListCellDelegate = self
        return musicListCell
    }
}

extension FirstVC: MusicListCellDelegate {
    func sendMusicTitle(musicTitle: String) {
        firstPageVCDelegate?.sendMusicTitle(musicTitle: musicTitle)
    }
}
