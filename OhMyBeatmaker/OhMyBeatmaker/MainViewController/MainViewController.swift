//
//  ViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import SafariServices

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
    
    private lazy var editView: EditView = {
       let view = EditView()
        view.delegate = self
        return view
    }()
    
    private var constraintX: NSLayoutConstraint?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureViews()
    }
    
    // MARK: @Objc
    @objc func didTapEditButton() {
        moveToEditView(priority: .defaultHigh)
    }
    
    // MARK: Helpers
    private func moveToEditView(priority: UILayoutPriority) {
        UIView.animate(withDuration: 1) {
            self.constraintX?.priority = priority
            self.constraintX?.isActive = true
            self.view.layoutIfNeeded()
        }
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
        
        [topView, tableView, editView].forEach {
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
        
        editView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        editView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        editView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        editView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        let defaultConstraintX = editView.leftAnchor.constraint(equalTo: view.rightAnchor)
        defaultConstraintX.priority = UILayoutPriority(500)
        defaultConstraintX.isActive = true
        constraintX = editView.leftAnchor.constraint(equalTo: view.leftAnchor)
        constraintX?.priority = .defaultLow
        constraintX?.isActive = true
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
            bannerTableCell.touchedBannerCellDelegate = self
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

// MARK: TouchedBannerCellDelegate
extension MainViewController: TouchedBannerCellDelegate {
    func openBannerWeb(indexPatRow: Int) {
        let webService = WebService()
        switch indexPatRow {
        case 0:
            let sxswSite = webService.openWebSxsw()
            present(sxswSite, animated: true)
        case 1:
            let boilerSite = webService.openWebBoiler()
            present(boilerSite, animated: true)
        default:
            break
        }
    }
}

// MARK: DidTapPlayButtonSecondDelegate
extension MainViewController: DidTapPlayButtonSecondDelegate {
    func didTapPlayButton(_ cell: CoverCollectionCell) {
        print(cell.artistNameLabel)
    }
}

// MARK: DidTapBackgroundDelegate
extension MainViewController: DidTapBackgroundDelegate {
    func moveToOut() {
        moveToEditView(priority: .defaultLow)
    }
}
