//
//  Song.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/07.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class Song {
    
    var songName: String!
    var artistName: String!
    var songFileUrl: String!
    var coverImageUrl: String!
    var like: Int!
    
    init(songName: String, dictionary: Dictionary<String, AnyObject>) {
        self.songName = songName
        
        if let artistName = dictionary["artistName"] as? String {
            self.artistName = artistName
        }
        
        if let songFileUrl = dictionary["songFileUrl"] as? String {
            self.songFileUrl = songFileUrl
        }
        
        if let coverImageUrl = dictionary["coverImageUrl"] as? String {
            self.coverImageUrl = coverImageUrl
        }
        
        if let like = dictionary["like"] as? Int {
            self.like = like
        }
    }
}
