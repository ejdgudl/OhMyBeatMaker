//
//  MyAccountViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/07.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController {
    
    // MARK: Properties
    lazy var plusPhotoButton: PlusPhotoButton = {
        let button = PlusPhotoButton()
        button.addTarget(self, action: #selector(handleSelectProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureViews()
    }
    
    // MARK: @Objc
    @objc func handleSelectProfilePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true)
    }
    
    
    // MARK: Configure
    private func configure () {
        
    }
    
    // MARK: ConfigureViews
    private func configureViews () {
        view.backgroundColor = .white
        
        [plusPhotoButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        plusPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusPhotoButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        plusPhotoButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension MyAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let profileImage = info[.editedImage] as? UIImage else {return}
        
        plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
}
