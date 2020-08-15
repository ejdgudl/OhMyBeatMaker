//
//  MyAccountViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/07.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import Kingfisher

protocol MyAccountVCDelegate: class {
    func sendMyMusicTitle(musicTitle: String)
}

class MyAccountViewController: UIViewController {
    
    // MARK: Properties
    lazy var plusPhotoButton: PlusPhotoButton = {
        let button = PlusPhotoButton()
        button.addTarget(self, action: #selector(handleSelectProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    let myMusicListTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var myAccountVCDelegate: MyAccountVCDelegate?
    
    var user: User? {
        didSet {
            db.child("Musics").observe(.childAdded) { (snapshot) in
                let musicTitle = snapshot.key
                guard let dic = snapshot.value as? Dictionary<String, AnyObject> else {return}
                let music = Music(musicTitle: musicTitle, dictionary: dic)
                if music.artistNickName == self.user?.nickName {
                    self.myMusics.append(music)
                }
            }
            
            guard let user = user else {return}
            title = user.nickName
            guard let imageUrl = URL(string: user.profileImageUrl) else {return}
            plusPhotoButton.kf.setImage(with: imageUrl, for: .normal)
        }
    }
    
    private var myMusics = [Music]() {
        didSet {
            self.myMusicListTableView.reloadData()
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
        configure()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: @Objc
    @objc private func didTapAddMusicButton() {
        let addMusicVC = AddMusicViewController()
        addMusicVC.user = self.user
        present(addMusicVC, animated: true)
    }
    
    @objc func handleSelectProfilePhoto() {
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    // MARK: Helpers
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
                self.db.child("users").child(uid).updateChildValues(dictionaryValues) { (error, ref) in
                    print("Successfully saved iamgeUrl to database")
                }
            }
        }
    }
    
    // MARK: Configure
    private func configure() {
        myMusicListTableView.delegate = self
        myMusicListTableView.dataSource = self
        
        myMusicListTableView.register(UserMusicListTableCell.self, forCellReuseIdentifier: UITableView.userMusicListTableCellID)
    }
    
    // MARK: ConfigureViews
    private func configureViews () {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil.tip.crop.circle.badge.plus"), style: .plain, target: self, action: #selector(didTapAddMusicButton))
        
        view.backgroundColor = .white
        
        [plusPhotoButton, myMusicListTableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        plusPhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusPhotoButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        plusPhotoButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        myMusicListTableView.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 70).isActive = true
        myMusicListTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        myMusicListTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myMusicListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
        
        imagePicker.view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerYAnchor.constraint(equalTo: imagePicker.view.centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: imagePicker.view.centerXAnchor).isActive = true
    }
}

// MARK: UITableView
extension MyAccountViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myMusics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myMusicListTableView.dequeueReusableCell(withIdentifier: UITableView.userMusicListTableCellID, for: indexPath) as! UserMusicListTableCell
        print(self.myMusics)
        cell.userMusicListCellDelegate = self
        cell.userMusic = self.myMusics[indexPath.row]
        return cell
    }
}

extension MyAccountViewController: UserMusicListCellDelegate {
    func sendUserMusicTitle(musicTitle: String) {
        myAccountVCDelegate?.sendMyMusicTitle(musicTitle: musicTitle)
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

// MARK: UIDocumentPickerDelegate
extension MyAccountViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard controller.documentPickerMode == .open, let url = urls.first, url.startAccessingSecurityScopedResource() else {return}
        
        let metadata = StorageMetadata()
        metadata.contentType = "audio/mp3"
        
        if let data = try? Data(contentsOf: urls.first!) {
            let fileName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("Musics").child(fileName)
            storageRef.putData(data, metadata: metadata) { (_, error) in
                if error != nil {
                    print(error!)
                } else {
                    print("suc")
                }
                
                DispatchQueue.main.async {
                    url.stopAccessingSecurityScopedResource()
                }
            }
        }
    }
}
