//
//  FirebaseService.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/07.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase

class FirebaseService {
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("successfully logged user out")
        }catch {
            print("failed to sign out")
        }
    }
    
}
