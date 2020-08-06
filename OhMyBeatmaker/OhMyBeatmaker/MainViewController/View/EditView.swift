//
//  EditView.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

// MARK: DidTapBackgroundDelegate
protocol DidTapBackgroundDelegate: class {
    func moveToOut()
}

class EditView: UIView {
    
    // MARK: Properties
    private let leftView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let rightView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let dissmissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "multiply.circle"), for: .normal)
        button.addTarget(self, action: #selector(dissmissEditView), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: DidTapBackgroundDelegate?
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: @Objc
    @objc private func dissmissEditView() {
        delegate?.moveToOut()
    }
    
    @objc private func didTapBackgraound() {
        delegate?.moveToOut()
    }
    
    // MARK: Configure
    private func configure() {
        leftView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackgraound)))
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        backgroundColor = .clear
        
        [leftView, rightView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        leftView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        leftView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        leftView.rightAnchor.constraint(equalTo: centerXAnchor).isActive = true
        leftView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        rightView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        rightView.leftAnchor.constraint(equalTo: centerXAnchor).isActive = true
        rightView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        rightView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        rightView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: rightView.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        containerView.addSubview(dissmissButton)
        dissmissButton.translatesAutoresizingMaskIntoConstraints = false
        dissmissButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        dissmissButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
    }
}

