//
//  BottomSecondVC.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase

protocol SignUpCompletionDelegate: class {
    func ScrollToFirst()
}

class BottomSecondVC: UIViewController {
    
    // MARK: Properties
    private let emailTextField: EmailTextField = {
        let tf = EmailTextField()
        return tf
    }()
    
    private let nickNameTextField: NickNameTextField = {
        let tf = NickNameTextField()
        return tf
    }()
    
    private let passwordTextField: PasswordTextField = {
        let tf = PasswordTextField()
        return tf
    }()
    
    private let signUpButton: LogButton = {
        let button = LogButton(type: .system)
        button.setTitle("SignUp", for: .normal)
        button.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: BottomStackView = {
        let stackView = BottomStackView(arrangedSubviews: [emailTextField, nickNameTextField, passwordTextField, signUpButton])
        return stackView
    }()
    
    private let db = Database.database().reference()
    
    private let firebaseService = FirebaseService()
    
    weak var signUpCompletionDelegate: SignUpCompletionDelegate?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: @Objc
    @objc private func didTapSignUpButton() {
        
        self.stackView.indicator.startActivityIndicator()
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let nickName = nickNameTextField.text else {return}
        guard email != "", password != "", nickName != "", password.count >= 6 else {
            alertNormal(title: "회원가입 오류", message: "다시 입력해 주세요")
            stackView.indicator.stopActivityIndicator()
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Failed to create user with error", error.localizedDescription)
                self.alertNormal(title: "회원가입 오류", message: "중복된 email이거나 형식이 잘못되었습니다") { (_) in
                    self.stackView.indicator.stopActivityIndicator()
                }
            }
            
            guard let uid = user?.user.uid else {return}
            let dictionaryValues = [ "nickName": nickName, "profileImageUrl": " "]
            let values = [uid: dictionaryValues]
            
            self.db.child("users").updateChildValues(values) { (error, ref) in
                self.stackView.indicator.stopActivityIndicator()
                self.whenSucessSignUp()
                self.alertNormal(title: "회원가입 성공", message: "wassup.\(nickName)") { (_) in
                    self.signUpCompletionDelegate?.ScrollToFirst()
                }
                print("successfully created user and saved information to database")
            }
            self.firebaseService.signOut()
        }
    }
    
    // MARK: Helpers
    private func whenSucessSignUp() {
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        self.nickNameTextField.text = ""
        self.view.endEditing(true)
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        view.backgroundColor = .white
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}


