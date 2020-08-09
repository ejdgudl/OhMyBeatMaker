//
//  SecondVC.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/09.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class SecondVC: UIViewController {
    
    // MARK: Properties
    private let MusicListTitleView: MusicTitleHeaderView = {
        let view = MusicTitleHeaderView()
        view.headerTitle.text = "Youtube MV"
        return view
    }()
    
    let videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: ConfigureViews
    func configureViews() {
        view.backgroundColor = .clear
        
        [MusicListTitleView, videoView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        MusicListTitleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        MusicListTitleView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        MusicListTitleView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        MusicListTitleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        videoView.topAnchor.constraint(equalTo: MusicListTitleView.bottomAnchor).isActive = true
        videoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        videoView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
    }
}
