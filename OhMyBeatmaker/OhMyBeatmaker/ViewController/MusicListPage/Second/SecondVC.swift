//
//  SecondVC.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/09.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase

protocol SecondPageVCDelegate: class{
    func sendMusicSecondChartTitle(musicTitle: String)
}

class SecondVC: UIViewController {
    
    // MARK: Properties
    private let musicListTitleHeaderView: MusicListTitleHeaderView = {
        let view = MusicListTitleHeaderView()
        view.headerTitle.text = "Today Beat"
        return view
    }()
    
    let secondMusicListView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.isScrollEnabled = true
        return view
    }()
    
    let db = Database.database().reference()
    
    weak var secondPageVCDelegate: SecondPageVCDelegate?
    
    var musics = [Music]() {
        didSet {
            secondMusicListView.reloadData()
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
            self.musics.shuffle()
            if self.musics.count >= 5 {
                let range = 5...
                self.musics.removeSubrange(range)
            }
        }
    }
    
    // MARK: Configure
    private func configure() {
        secondMusicListView.delegate = self
        secondMusicListView.dataSource = self
        secondMusicListView.register(MusicListCell.self, forCellReuseIdentifier: UITableView.musicCellID)
    }
    
    // MARK: ConfigureViews
    func configureViews() {
        view.backgroundColor = .clear
        
        [musicListTitleHeaderView, secondMusicListView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        musicListTitleHeaderView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        musicListTitleHeaderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        musicListTitleHeaderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        musicListTitleHeaderView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        secondMusicListView.topAnchor.constraint(equalTo: musicListTitleHeaderView.bottomAnchor).isActive = true
        secondMusicListView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        secondMusicListView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        secondMusicListView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
    }
    
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension SecondVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musics.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let musicListCell = secondMusicListView.dequeueReusableCell(withIdentifier: UITableView.musicCellID, for: indexPath) as? MusicListCell else {fatalError()}
        musicListCell.music = self.musics[indexPath.row]
        musicListCell.musicListCellDelegate = self
        return musicListCell
    }
}

extension SecondVC: MusicListCellDelegate {
    func sendMusicTitle(musicTitle: String) {
        secondPageVCDelegate?.sendMusicSecondChartTitle(musicTitle: musicTitle)
    }
}

