//
//  MusicSearchTableViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/14.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase

protocol MusicSearchSendTitleDelegate: class {
    func searchSendMusicTitle(musicTitle: String)
}

class MusicSearchTableViewController: UITableViewController {

    // MARK: Properties
    var musics = [Music]()
    
    lazy var searchBar: SearchBar = {
       let searchBar = SearchBar()
        searchBar.delegate = self
        return searchBar
    }()
    
    private var searchedMusics = [Music]()
    private var searchMode = false
    
    weak var musicSearchSendTitleDelegate: MusicSearchSendTitleDelegate?
    
    private let db = Database.database().reference()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMusic()
        configure()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: @Objc
    @objc func searchTapped() {
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = nil
        searchBar.becomeFirstResponder()
    }
    
    // MARK: Helpers
    private func fetchMusic() {
        db.child("Musics").observe(.childAdded) { (snapshot) in
            let musicTitle = snapshot.key
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {return}
            let music = Music(musicTitle: musicTitle, dictionary: dictionary)
            self.musics.append(music)
            self.tableView.reloadData()
        }
    }
    
    // MARK: Configure
    private func configure() {
        tableView.register(SearchMusicTableCell.self, forCellReuseIdentifier: UITableView.searchMusicTableCellID)
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        title = "노래 찾기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 0)
    }
}

extension MusicSearchTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchMode == false {
            return musics.count
        } else {
            return searchedMusics.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableView.searchMusicTableCellID, for: indexPath) as! SearchMusicTableCell
        var music: Music?
        if searchMode == false {
            music = musics[indexPath.row]
        } else {
            music = searchedMusics[indexPath.row]
        }
        cell.music = music
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var music: Music?
        if searchMode == false {
             music = musics[indexPath.row]
        } else {
            music = searchedMusics[indexPath.row]
        }
        guard let selectMusic = music else {return}
        musicSearchSendTitleDelegate?.searchSendMusicTitle(musicTitle: selectMusic.musicTitle)
    }
}

extension MusicSearchTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        searchBar.text = ""
        searchMode = false
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchMode = false
            tableView.reloadData()
        } else {
            searchMode = true
            let matchingUsers = self.musics.filter { (music) -> Bool in
                guard let musicTitle = music.musicTitle else {return false}
                return musicTitle.lowercased().contains(searchText.lowercased())
            }
            self.searchedMusics = matchingUsers
            tableView.reloadData()
        }
    }
}

