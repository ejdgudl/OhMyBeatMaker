//
//  PlayerService.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/14.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase

class PlayerService {

    func presentPlayer(playerVC: PlayerViewController, bottomButton: BottomButton, selfVC: MainViewController, musicTitle: String) {
        playerVC.musicTitle = musicTitle
        bottomButton.newMusic = musicTitle
        bottomButton.playButton.setImage(UIImage(named: "pause"), for: .normal)
        playerVC.mainVC = selfVC
    }
    
}
