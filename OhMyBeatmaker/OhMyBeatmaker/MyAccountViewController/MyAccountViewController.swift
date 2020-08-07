//
//  MyAccountViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/07.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase

class MyAccountViewController: UIViewController {
    
    // MARK: Properties
    lazy var plusPhotoButton: PlusPhotoButton = {
        let button = PlusPhotoButton()
        button.addTarget(self, action: #selector(handleSelectProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    var user: User? {
        didSet {
            guard let user = user else {return}
            title = user.nickName
            guard let imageUrl = URL(string: user.profileImageUrl) else {return}
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                guard error == nil else {return}
                guard let data = data else {return}
                DispatchQueue.main.async {
                    self.plusPhotoButton.setImage(UIImage(data: data), for: .normal)
                }
            }.resume()
        }
    }
    
    private let indicator: IndicatorView = {
        var indicator = IndicatorView(frame: accessibilityFrame())
        return indicator
    }()
    
    private let imagePicker = UIImagePickerController()
    
    private let db = Database.database().reference()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        configure()
        configureViews()
    }
    
    // MARK: @Objc
    @objc func handleSelectProfilePhoto() {
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    // MARK: Helpers
    func fetchUser() {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        db.child("users").child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {return}
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            self.user = user
        }
    }
    
    private func uploadProfileImage() {
        
        guard let profileImage = plusPhotoButton.imageView?.image else {return}
        guard let uploadData = profileImage.jpegData(compressionQuality: 0.3) else {return}
        
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child(fileName)
        storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
            
            if let error = error {
                print("failed to upload image to firebase stoarge with error", error.localizedDescription)
            }
            
            storageRef.downloadURL { (downloadURL, error) in
                guard let profileImageUrl = downloadURL?.absoluteString else {
                    print("DEBUG: Profile image url is nil")
                    return
                }
                
                let dictionaryValues = ["profileImageUrl": profileImageUrl]
                guard let uid = Auth.auth().currentUser?.uid else {return}
                Database.database().reference().child("users").child(uid).updateChildValues(dictionaryValues) { (error, ref) in
                    print("Successfully saved iamgeUrl to database")
                }
            }
        }
    }
    
    // MARK: Configure
    private func configure () {
        
    }
    
    // MARK: ConfigureViews
    private func configureViews () {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
        
        [plusPhotoButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        plusPhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusPhotoButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        plusPhotoButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        imagePicker.view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerYAnchor.constraint(equalTo: imagePicker.view.centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: imagePicker.view.centerXAnchor).isActive = true
    }
    
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension MyAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        indicator.startActivityIndicator()
        guard let profileImage = info[.editedImage] as? UIImage else {return}
        
        plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.uploadProfileImage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true, completion: nil)
            self.indicator.stopActivityIndicator()
        }
    }
}
