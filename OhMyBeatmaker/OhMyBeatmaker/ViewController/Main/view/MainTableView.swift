//
//  MainTableView.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/14.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class MainTableView: UITableView {
    
    // MARK: Properties
    let mainRefreshControl = UIRefreshControl()
    
    // MARK: Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        mainRefreshControl.tintColor = .black
        refreshControl = mainRefreshControl
        backgroundColor = .white
        separatorStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
