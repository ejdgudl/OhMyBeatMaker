//
//  SearchBar.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/15.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class SearchBar: UISearchBar {
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        sizeToFit()
        showsCancelButton = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
