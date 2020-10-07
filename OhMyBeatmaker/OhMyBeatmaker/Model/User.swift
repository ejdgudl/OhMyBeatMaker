//
//  Model.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class User {
    
    var nickName: String!
    var profileImageUrl: String!
    var uid: String!
    
    init(uid: String, dictionary: Dictionary<String, AnyObject>) {
        self.uid = uid
        
        if let nickName = dictionary["nickName"] as? String {
            self.nickName = nickName
        }
        
        if let profileImageUrl = dictionary["profileImageUrl"] as? String {
            self.profileImageUrl = profileImageUrl
        }
    }
}



