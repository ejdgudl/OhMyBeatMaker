//
//  ViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: Properties
    private lazy var topView: TopView = {
        let view = TopView()
        view.editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        return tableView
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureViews()
    }
    
    // MARK: @Objc
    @objc func didTapEditButton() {
        
    }
    
    // MARK: Configure
    private func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BannerTableCell.self, forCellReuseIdentifier: UITableView.bannerTableCellID)
        tableView.register(NewMusicTitleTableCell.self, forCellReuseIdentifier: UITableView.newMusicTitleTableCellID)
        tableView.register(NewMusicCoverTableCell.self, forCellReuseIdentifier: UITableView.newMusicCoverTableCellID)
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        [topView, tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        tableView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let bannerTableCell = tableView.dequeueReusableCell(withIdentifier: UITableView.bannerTableCellID, for: indexPath) as? BannerTableCell else {return UITableViewCell()}
            return bannerTableCell
        case 1:
            guard let newMusicTitleCell = tableView.dequeueReusableCell(withIdentifier: UITableView.newMusicTitleTableCellID, for: indexPath) as? NewMusicTitleTableCell else {return UITableViewCell()}
            return newMusicTitleCell
        case 2:
            guard let newMusicCoverCell = tableView.dequeueReusableCell(withIdentifier: UITableView.newMusicCoverTableCellID, for: indexPath) as? NewMusicCoverTableCell else {fatalError()}
            newMusicCoverCell.delegate = self
            return newMusicCoverCell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 130
        case 1:
            return 50
        case 2:
            return 140
        default:
            break
        }
        return 0
    }
}

// MARK: Extension
extension MainViewController: DidTapPlayButtonSecondDelegate {
    func didTapPlayButton(_ cell: CoverCollectionCell) {
        print(cell.artistNameLabel)
    }
}
