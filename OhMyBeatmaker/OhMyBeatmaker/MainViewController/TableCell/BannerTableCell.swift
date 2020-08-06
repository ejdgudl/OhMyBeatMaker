//
//  BannerImagesCell.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

// MARK: TouchedBannerCellDelegate
protocol TouchedBannerCellDelegate: class {
    func openBannerWeb(indexPatRow: Int)
}

class BannerTableCell: UITableViewCell {
    
    // MARK: Properties
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let firstBannerRow = IndexPath(item: 0, section: 0)
    private let secondBannerRow = IndexPath(item: 1, section: 0)
    private let timer = Timer()
    private var count = 0
    
    weak var touchedBannerCellDelegate: TouchedBannerCellDelegate?
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: @Objc
    @objc private func updateTime() {
        count += 1
        if count % 10 == 0 {
            isSelected.toggle()
            collectionView.scrollToItem(at: firstBannerRow, at: .centeredHorizontally, animated: true)
        } else if count % 5 == 0 {
            isSelected.toggle()
            collectionView.scrollToItem(at: secondBannerRow, at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK: Helpers
    private func makeImage(row: Int, cell: BannerCollectionCell) {
        if row == 0 {
            cell.bannerImageView.image = UIImage(named: "banner2")
        } else {
            cell.bannerImageView.image = UIImage(named: "banner1")
        }
    }
    
    // MARK: Configure
    private func configure() {
        selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BannerCollectionCell.self, forCellWithReuseIdentifier: UICollectionView.bannerCollectionCellID)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        backgroundColor = .white
        
        [collectionView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 130).isActive = true
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension BannerTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let bannerCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionView.bannerCollectionCellID, for: indexPath) as? BannerCollectionCell else {return UICollectionViewCell()}
        makeImage(row: indexPath.row, cell: bannerCollectionCell)
        return bannerCollectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        isSelected.toggle()
        guard isSelected else {return}
        switch indexPath.row {
        case 0:
            touchedBannerCellDelegate?.openBannerWeb(indexPatRow: indexPath.row)
        case 1:
            touchedBannerCellDelegate?.openBannerWeb(indexPatRow: indexPath.row)
        default:
            break
        }
    
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension BannerTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 50, height: collectionView.frame.height - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    }
}


