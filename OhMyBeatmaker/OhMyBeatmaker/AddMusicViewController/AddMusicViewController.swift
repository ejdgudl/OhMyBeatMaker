//
//  AddSongViewController.swift
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
    lazy var addMusicButton: UIButton = {
        let button = UIButton()
        button.setTitle("음악 선택", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapAddMusicButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: @Objc
    @objc private func didTapAddMusicButton() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeMP3)], in: .open)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        view.backgroundColor = .white
        
        view.addSubview(addMusicButton)
        addMusicButton.translatesAutoresizingMaskIntoConstraints = false
        addMusicButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        addMusicButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

// MARK: UIDocumentPickerDelegate
extension AddMusicViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard controller.documentPickerMode == .open, let url = urls.first, url.startAccessingSecurityScopedResource() else {return}
        
        let metadata = StorageMetadata()
        metadata.contentType = "audio/mp3"
        
        if let data = try? Data(contentsOf: urls.first!) {
//            let fileName = urls.first?.deletingPathExtension().lastPathComponent
            let fileName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("Musics").child(fileName)
            storageRef.putData(data, metadata: metadata) { (_, error) in
                if error != nil {
                    print(error!)
                } else {
                    print("successed upload mp3 File in storage")
                }
                
                DispatchQueue.main.async {
                    url.stopAccessingSecurityScopedResource()
                }
            }
        }
    }
}


