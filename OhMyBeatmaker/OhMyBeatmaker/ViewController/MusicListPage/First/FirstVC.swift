//
//  FirstVC.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/09.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase

// MARK: FirstPageVCDelegate
protocol FirstPageVCDelegate: class{
    func sendMusicTitle(musicTitle: String)
}

class FirstVC: UIViewController {
    
    // MARK: Properties
    private let musicListTitleHeaderView: MusicListTitleHeaderView = {
        let view = MusicListTitleHeaderView()
        view.headerTitle.text = "Top5"
        return view
    }()
    
    let firstMusicListView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.isScrollEnabled = false
        return view
    }()
    
    let db = Database.database().reference()
    
    weak var firstPageVCDelegate: FirstPageVCDelegate?
    
    var top5Array: [String]? {
        didSet {
            firstMusicListView.reloadData()
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureViews()
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
        
        [musicListTitleHeaderView, firstMusicListView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        musicListTitleHeaderView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        musicListTitleHeaderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        musicListTitleHeaderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        musicListTitleHeaderView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        firstMusicListView.topAnchor.constraint(equalTo: musicListTitleHeaderView.bottomAnchor).isActive = true
        firstMusicListView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        firstMusicListView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        firstMusicListView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
    }
    
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension FirstVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let top5Array = self.top5Array else {return 0 }
        return top5Array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let musicListCell = firstMusicListView.dequeueReusableCell(withIdentifier: UITableView.musicCellID, for: indexPath) as? MusicListCell else {fatalError()}
        guard let top5Array = self.top5Array else {fatalError()}
        musicListCell.top5ArrayOf1 = top5Array[indexPath.row]
        musicListCell.musicListCellDelegate = self
        return musicListCell
    }
}

extension FirstVC: MusicListCellDelegate {
    func sendMusicTitle(musicTitle: String) {
        firstPageVCDelegate?.sendMusicTitle(musicTitle: musicTitle)
    }
}
