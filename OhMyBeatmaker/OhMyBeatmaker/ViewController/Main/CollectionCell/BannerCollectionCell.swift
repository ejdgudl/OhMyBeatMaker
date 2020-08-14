//
//  BannerCollectionCell.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class BannerCollectionCell: UICollectionViewCell {
    
    // MARK: Properties
    lazy var bannerImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ConfigureViews
    func configureViews() {
        layer.cornerRadius = 15
        
        addSubview(bannerImageView)
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        bannerImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bannerImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bannerImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bannerImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
