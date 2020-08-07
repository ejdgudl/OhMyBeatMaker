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
    func openWeb(row: Int) -> SFSafariViewController {
        if row == 0 {
            guard let url = URL(string: "https://www.sxsw.com") else {fatalError()}
            let safariViewController = SFSafariViewController(url: url)
            return safariViewController
        } else {
            guard let url = URL(string: "https://boilerroom.tv") else {fatalError()}
            let safariViewController = SFSafariViewController(url: url)
            return safariViewController
        }
    }
}
