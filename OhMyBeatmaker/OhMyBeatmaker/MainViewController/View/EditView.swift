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

// MARK: DidTapEdiViewTableCellDelegate
protocol DidTapEdiViewTableCellDelegate: class {
    func didTapEdiViewTableCell(section: Int, row: Int)
}

// MARK: DidTapPlusPhotoButtonDelegate
protocol DidTapLoginButtonDelegate: class {
    func prsentLoginVC()
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
    
    lazy var loginButton: LoginButton = {
        let button = LoginButton()
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return button
    }()
    
    private let dissmissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "multiply.circle"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(dissmissEditView), for: .touchUpInside)
        return button
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .clear
        return tableView
    }()
    
    private lazy var sections: [String] = rows.keys.sorted()
    private let rows = ["내 계정": ["내정보", "유저 찾기", "로그아웃"], "앱 소개": ["OMB"]]

    
    weak var didTapBackgroundDelegate: DidTapBackgroundDelegate?
    weak var didTapEdiViewTableCellDelegate: DidTapEdiViewTableCellDelegate?
    weak var didTapLoginButtonDelegate: DidTapLoginButtonDelegate?
    
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
        didTapBackgroundDelegate?.moveToOut()
    }
    
    @objc private func didTapBackgraound() {
        didTapBackgroundDelegate?.moveToOut()
    }
    
    @objc private func didTapLoginButton() {
        didTapLoginButtonDelegate?.prsentLoginVC()
    }
    
    // MARK: Configure
    private func configure() {
        leftView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackgraound)))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableView.editTableCellID)
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
        
        [loginButton, dissmissButton].forEach {
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        loginButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        loginButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        dissmissButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        dissmissButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        
        rightView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: rightView.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightView.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: rightView.bottomAnchor).isActive = true
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension EditView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = EditTableHeaderView()
        switch section {
        case section:
            headerView.headerTitle.text = sections[section]
        case section:
            headerView.headerTitle.text = sections[section]
        default:
            fatalError()
        }
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        private lazy var sections: [String] = rows.keys.sorted()
//        private let rows = ["내 계정": ["로그아웃", "내정보"], "앱 소개": ["OMB"]]
        rows[sections[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableView.editTableCellID, for: indexPath)
        let arr = rows[sections[indexPath.section]]
        cell.textLabel?.text = arr![indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                didTapEdiViewTableCellDelegate?.didTapEdiViewTableCell(section: indexPath.section, row: indexPath.row)
            case 1:
                didTapEdiViewTableCellDelegate?.didTapEdiViewTableCell(section: indexPath.section, row: indexPath.row)
            case 2:
                didTapEdiViewTableCellDelegate?.didTapEdiViewTableCell(section: indexPath.section, row: indexPath.row)
            default:
                break
            }
        } else {
            didTapEdiViewTableCellDelegate?.didTapEdiViewTableCell(section: indexPath.section, row: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
