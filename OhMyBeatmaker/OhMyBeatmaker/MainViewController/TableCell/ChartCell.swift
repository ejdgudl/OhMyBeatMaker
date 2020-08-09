//
//  ChartCell.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/09.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class ChartCell: UITableViewCell {
    
    // MARK: Properties
    var chartImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 11
        imageView.layer.masksToBounds = true
        imageView.tintColor = .black
        imageView.backgroundColor = .orange
        return imageView
    }()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        
        [chartImageView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        chartImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        chartImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        chartImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        chartImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
}
