//
//  Extension.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

extension UITableView {
    
    static let bannerTableCellID = "bannerTableCellID"
    static let newMusicTitleTableCellID = "newMusicTitleTableCellID"
    static let newMusicCoverTableCellID = "newMusicCoverTableCellID"
}

extension UICollectionView {
    
    static let bannerCollectionCellID = "bannerCollectionCellID"
    static let newMusicCoverCollectionCellID = "newMusicCoverCollectionCellID"
}


// MARK: - AlertController
extension UIViewController {
    
    func alertNormal(title: String? = nil, message: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let cancel = UIAlertAction(title: "닫기", style: .cancel, handler: handler)
      alert.addAction(cancel)
      self.present(alert, animated: true)
    }
    
    func alertAddAction(title: String? = nil, message: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let ok = UIAlertAction(title: "확인", style: .default, handler: handler)
      let cancel = UIAlertAction(title: "닫기", style: .cancel)
      alert.addAction(ok)
      alert.addAction(cancel)
      self.present(alert, animated: true)
    }
    
    func alertSingleTextField(title: String? = nil, message: String? = nil, actionTitle: String, keyboardType: UIKeyboardType = .default, completion: @escaping (String?) -> ()) {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alert.addTextField { $0.keyboardType = keyboardType }
      
      let action = UIAlertAction(title: actionTitle, style: .default) { (_) in
        let text = alert.textFields?[0].text
        completion(text)
      }
      let cancel = UIAlertAction(title: "닫기", style: .cancel)
      
      alert.addAction(action)
      alert.addAction(cancel)
      self.present(alert, animated: true)
    }
}

// MARK: - moveViewWithKeyboard
extension UIViewController {
    
    func moveViewWithKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
