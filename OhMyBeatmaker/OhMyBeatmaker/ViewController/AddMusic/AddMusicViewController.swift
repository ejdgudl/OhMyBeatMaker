//
//  AddMusicViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/07.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices

class AddMusicViewController: UIViewController {
    
    // MARK: Properties
    lazy var plusCoverButton: PlusCoverButton = {
        let button = PlusCoverButton()
        button.addTarget(self, action: #selector(handleSelectProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    lazy var addMusicButton: AddMusicButton = {
        let button = AddMusicButton()
        button.addTarget(self, action: #selector(didTapAddMusicButton), for: .touchUpInside)
        return button
    }()
    
    private var indicator: IndicatorView = {
        var indicator = IndicatorView(frame: accessibilityFrame())
        return indicator
    }()
    
    var user: User?
    
    private let imagePicker = UIImagePickerController()
    
    let firebaseService = FirebaseService()
    let storageRef = Storage.storage().reference()
    let db = Database.database().reference()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: @Objc
    @objc private func handleSelectProfilePhoto() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true)
    }
    
    @objc private func didTapAddMusicButton() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeMP3)], in: .open)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }
    
    // MARK: Helpers
    private func uploadMusicData(musicTitle: String, musicFileUrl: String) {
        
        guard let coverImage = plusCoverButton.imageView?.image else {return}
        guard let uploadData = coverImage.jpegData(compressionQuality: 0.3) else {return}
        
        let fileName = NSUUID().uuidString
        self.storageRef.child("cover_images").child(fileName).putData(uploadData, metadata: nil) { (metaData, error) in
            if let error = error {
                print("failed to upload image to firebase stoarge with error", error.localizedDescription)
            }
            
            self.storageRef.child("cover_images").child(fileName).downloadURL { (downloadURL, error) in
                guard let coverImageUrl = downloadURL?.absoluteString else {
                    print("DEBUG: Profile image url is nil")
                    return
                }
                
                guard let artistNickName = self.user?.nickName else {return}
                
                let dictionaryValues: [String: Any] = [
                    "musicTitle": musicTitle,
                    "artistNickName": artistNickName,
                    "musicFileUrl": musicFileUrl,
                    "coverImageUrl": coverImageUrl,
                    "like": 0
                ]
                
                let values = [musicTitle : dictionaryValues]
                
                self.db.child("Musics").updateChildValues(values) { (error, ref) in
                    print("Successfully saved information to Music database")
                }
                self.firebaseService.makeNew5(musicTitle: musicTitle)
            }
        }
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        view.backgroundColor = .white
        
        [plusCoverButton, addMusicButton, indicator].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        plusCoverButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        plusCoverButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusCoverButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        plusCoverButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        addMusicButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true
        addMusicButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        imagePicker.view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerYAnchor.constraint(equalTo: imagePicker.view.centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: imagePicker.view.centerXAnchor).isActive = true
    }
}

// MARK: UIDocumentPickerDelegate
extension AddMusicViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.startActivityIndicator()
        
        guard controller.documentPickerMode == .open, let url = urls.first, url.startAccessingSecurityScopedResource() else {return}
        
        let metadata = StorageMetadata()
        metadata.contentType = "audio/mp3"
        
        if let data = try? Data(contentsOf: urls.first!) {
            storageRef.child("Musics").child(urls.first!.lastPathComponent).putData(data, metadata: metadata) { (_, error) in
                if error != nil {
                    print(error!)
                } else {
                    print("successed upload mp3 File in storage")
                }
                
                DispatchQueue.main.async {
                    url.stopAccessingSecurityScopedResource()
                    self.storageRef.child("Musics").child(urls.first!.lastPathComponent).downloadURL { (downloadUrl, error) in
                        guard let musicFileUrl = downloadUrl?.absoluteString else {return}
                        guard let musicTitle = urls.first?.deletingPathExtension().lastPathComponent else {return
                        }
                        self.uploadMusicData(musicTitle: musicTitle, musicFileUrl: musicFileUrl)
                        self.dismiss(animated: true, completion: nil)
                        self.indicator.stopAnimating()
                    }
                }
            }
        }
    }
}

// MARK: ImagePicker
extension AddMusicViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        indicator.startActivityIndicator()
        guard let profileImage = info[.editedImage] as? UIImage else {return}
        
        plusCoverButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true, completion: nil)
            self.indicator.stopAnimating()
        }
    }
}
