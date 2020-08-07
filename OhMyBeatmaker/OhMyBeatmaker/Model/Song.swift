//
//  Song.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/07.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class Song {
    
    var musicTitle: String!
    var artistNickName: String!
    var musicFileUrl: String!
    var coverImageUrl: String!
    var like: Int!
    
    init(musicTitle: String, dictionary: Dictionary<String, AnyObject>) {
        self.musicTitle = musicTitle
        
        if let artistNickName = dictionary["artistNickName"] as? String {
            self.artistNickName = artistNickName
        }
        
        if let musicFileUrl = dictionary["musicFileUrl"] as? String {
            self.musicFileUrl = musicFileUrl
        }
        
        if let coverImageUrl = dictionary["coverImageUrl"] as? String {
            self.coverImageUrl = coverImageUrl
        }
        
        if let like = dictionary["like"] as? Int {
            self.like = like
        }
    }
}

