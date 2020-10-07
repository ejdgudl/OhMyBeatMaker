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
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            print("No crrent user")
        } else {
            print("User is logged in")
        }
    }
    
    func fetchUserService(with uid: String, completion: @escaping(User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    func makeNew5(musicTitle: String) {
        let db = Database.database().reference()
        
        db.child("New5").observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else {
                let new5DictValues: [String: Any] = [
                    "New5": [musicTitle]
                ]
                db.updateChildValues(new5DictValues) { (error, ref) in
                    print("Successfully saved FIRST information to new5Music database")
                }
                return
            }
            if let array = snapshot.value as? [String] {
                if array.count == 1 {
                    let new5DictValues: [String: Any] = [
                        "New5": [musicTitle, array[0]]
                    ]
                    db.updateChildValues(new5DictValues) { (error, ref) in
                        print("Successfully saved SECOND information to new5Music database")
                    }
                } else if array.count == 2 {
                    let new5DictValues: [String: Any] = [
                        "New5": [musicTitle, array[0], array[1]]
                    ]
                    db.updateChildValues(new5DictValues) { (error, ref) in
                        print("Successfully saved THIRD information to new5Music database")
                    }
                } else if array.count == 3 {
                    let new5DictValues: [String: Any] = [
                        "New5": [musicTitle, array[0], array[1], array[2]]
                    ]
                    db.updateChildValues(new5DictValues) { (error, ref) in
                        print("Successfully saved FOURTH information to new5Music database")
                    }
                } else if array.count >= 4 {
                    let new5DictValues: [String: Any] = [
                        "New5": [musicTitle, array[0], array[1], array[2], array[3]]
                    ]
                    db.updateChildValues(new5DictValues) { (error, ref) in
                        print("Successfully saved FIFTH information to new5Music database")
                    }
                }
            }
        }
    }
    
}
