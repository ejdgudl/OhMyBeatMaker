//
//  WebService.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/07.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import SafariServices

class WebService {
    func openWebSxsw() -> SFSafariViewController {
        guard let url = URL(string: "https://www.sxsw.com") else {fatalError()}
        let safariViewController = SFSafariViewController(url: url)
        return safariViewController
    }
    
    func openWebBoiler() -> SFSafariViewController {
        guard let url = URL(string: "https://boilerroom.tv") else {fatalError()}
        let safariViewController = SFSafariViewController(url: url)
        return safariViewController
    }
}
