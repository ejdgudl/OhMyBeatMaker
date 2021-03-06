//
//  zz.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

protocol DidTapPlayButtonSecondDelegate: class {
    func didTapPlayButton(newMusic: String)
}

class NewMusicCoverTableCell: UITableViewCell {
    
    // MARK: Properties
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        return view
    }()
    
    weak var didTapPlayButtonSecondDelegate: DidTapPlayButtonSecondDelegate?
    
    var new5Array: [String]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    private func configure() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NewMusicCoverCollectionCell.self, forCellWithReuseIdentifier:    UICollectionView.newMusicCoverCollectionCellID)
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        backgroundColor = .white
        selectionStyle = .none
        
        [collectionView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension NewMusicCoverTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let new5Array = self.new5Array else {return 0}
        return new5Array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionView.newMusicCoverCollectionCellID, for: indexPath) as! NewMusicCoverCollectionCell
        cell.didTapPlayButtonFirstDelegate = self
        if let new5Array = self.new5Array?[indexPath.row] {
            cell.new5ArrayOf1 = new5Array
        }
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension NewMusicCoverTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0) // 각셀의 padding
    }
}

// MARK: DidTapPlayButtonFirstDelegate
extension NewMusicCoverTableCell: DidTapPlayButtonFirstDelegate {
    func didTapPlayButton(newMusic: String) {
        didTapPlayButtonSecondDelegate?.didTapPlayButton(newMusic: newMusic)
    }
}
