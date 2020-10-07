//
//  BottomFirstVC.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import Firebase

// MARK: ScrollToSignUpVCDelegate
protocol ScrollToSignUpVCDelegate: class {
    func ScrollToSignUpVC()
}
// MARK: SuccessSignUpDelegate
protocol SuccessSignInDelegate: class {
    func whenSuccessSignIn()
}

class BottomFirstVC: UIViewController {
    
    //  MARK: Properties
    private let emailTextField: EmailTextField = {
        let tf = EmailTextField()
        return tf
    }()
    
    private let passwordTextField: PasswordTextField = {
        let tf = PasswordTextField()
        return tf
    }()
    
    private lazy var loginButton: LogButton = {
        let button = LogButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        return button
    }()
    
    private let signUpButton: LogButton = {
        let button = LogButton(type: .system)
        button.setTitle("SignUp", for: .normal)
        button.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: BottomStackView = {
        let stackView = BottomStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, signUpButton])
        return stackView
    }()
    
    weak var scrollToSignUpVCDelegate: ScrollToSignUpVCDelegate?
    weak var successSignInDelegate: SuccessSignInDelegate?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: @Objc
    @objc func didTapSignInButton() {
        view.makeToastActivity(.center)
        guard let email = emailTextField.text, let password = passwordTextField.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Unable to sign user in with error", error.localizedDescription)
                self.alertNormal(title: "로그인 오류", message: "아이디와 비밀번호를 확인해주세요") { (_) in
                    self.view.hideToastActivity()
                }
                return
            }
            print("successfully signed user in")
            
            self.dismiss(animated: true) {
                self.view.hideToastActivity()
                self.successSignInDelegate?.whenSuccessSignIn()
            }
        }
    }
    
    @objc private func didTapSignUpButton() {
        scrollToSignUpVCDelegate?.ScrollToSignUpVC()
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


