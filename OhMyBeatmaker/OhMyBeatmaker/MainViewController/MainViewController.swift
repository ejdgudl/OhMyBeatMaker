//
//  ViewController.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit
import SafariServices
import Firebase

class MainViewController: UIViewController {
    
    // MARK: Properties
    private lazy var topView: TopView = {
        let view = TopView()
        view.editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var editView: EditView = {
        let view = EditView()
        return view
    }()
    
    private lazy var bottomButton: BottomButton = {
        let button = BottomButton()
        button.addTarget(self, action: #selector(didTapBottomButton), for: .touchUpInside)
        return button
    }()
    
    private var constraintX: NSLayoutConstraint?
    
    private let webService = WebService()
    private let firebseService = FirebaseService()
    private let db = Database.database().reference()
    
    private let playerVC = PlayerViewController()
    
    let pageVC = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    var user: User? {
        didSet {
            guard let user = user else {return}
            self.editView.loginButton.setTitle(user.nickName, for: .normal)
            guard let imageUrl = URL(string: user.profileImageUrl) else {return}
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                guard error == nil else {return}
                guard let data = data else {return}
                DispatchQueue.main.async {
                    self.editView.loginButton.setImage(UIImage(data: data), for: .normal)
                }
            }.resume()
        }
    }
    
    var new5Array: [String]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAll()
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: @Objc
    @objc func didTapEditButton() {
        moveToEditView(priority: .defaultHigh)
    }
    
    @objc private func didTapBottomButton() {
        present(playerVC, animated: true)
    }
    
    // MARK: Helpers
    func fetchAll() {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        db.child("users").child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {return}
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            self.user = user
            self.editView.loginButton.isEnabled = false
        }
        db.child("New5").observeSingleEvent(of: .value) { (snapshot) in
            guard let new5Array = snapshot.value as? [String] else {return}
            self.new5Array = new5Array
        }
    }
    
    private func moveToEditView(priority: UILayoutPriority) {
        UIView.animate(withDuration: 1) {
            self.constraintX?.priority = priority
            self.constraintX?.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: Configure
    private func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(BannerTableCell.self, forCellReuseIdentifier: UITableView.bannerTableCellID)
        tableView.register(NewMusicTitleTableCell.self, forCellReuseIdentifier: UITableView.newMusicTitleTableCellID)
        tableView.register(NewMusicCoverTableCell.self, forCellReuseIdentifier: UITableView.newMusicCoverTableCellID)
        tableView.register(MusicListTitleTableCell.self, forCellReuseIdentifier: UITableView.musicTitleCellID)
        tableView.register(MusicListTableCell.self, forCellReuseIdentifier: UITableView.musicTableCellID)
        
        editView.didTapEdiViewTableCellDelegate = self
        editView.didTapBackgroundDelegate = self
        editView.didTapLoginButtonDelegate = self
        
        addChild(pageVC)
    }
    
    // MARK: ConfigureViews
    private func configureViews() {
        view.backgroundColor = .white
        
        [topView, tableView, editView, bottomButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        tableView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        editView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        editView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        editView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        editView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        let defaultConstraintX = editView.leftAnchor.constraint(equalTo: view.rightAnchor)
        defaultConstraintX.priority = UILayoutPriority(500)
        defaultConstraintX.isActive = true
        constraintX = editView.leftAnchor.constraint(equalTo: view.leftAnchor)
        constraintX?.priority = .defaultLow
        constraintX?.isActive = true
        
        bottomButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let bannerTableCell = tableView.dequeueReusableCell(withIdentifier: UITableView.bannerTableCellID, for: indexPath) as? BannerTableCell else {return UITableViewCell()}
            bannerTableCell.touchedBannerCellDelegate = self
            return bannerTableCell
        case 1:
            guard let newMusicTitleCell = tableView.dequeueReusableCell(withIdentifier: UITableView.newMusicTitleTableCellID, for: indexPath) as? NewMusicTitleTableCell else {return UITableViewCell()}
            return newMusicTitleCell
        case 2:
            guard let newMusicCoverCell = tableView.dequeueReusableCell(withIdentifier: UITableView.newMusicCoverTableCellID, for: indexPath) as? NewMusicCoverTableCell else {fatalError()}
            newMusicCoverCell.delegate = self
            newMusicCoverCell.new5Array = self.new5Array
            return newMusicCoverCell
        case 3:
            guard let musicListTitleCell = tableView.dequeueReusableCell(withIdentifier: UITableView.musicTitleCellID, for: indexPath) as? MusicListTitleTableCell else {fatalError()}
            return musicListTitleCell
        case 4:
            guard let musicTableCell = tableView.dequeueReusableCell(withIdentifier: UITableView.musicTableCellID, for: indexPath) as? MusicListTableCell else {fatalError()}
            musicTableCell.pageView.addSubview(pageVC.view)
            pageVC.sendDelegate = self
            pageVC.view.frame = musicTableCell.pageView.frame
            return musicTableCell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 130
        case 1:
            return 50
        case 2:
            return 140
        case 3:
            return 50
        case 4:
            return 400
        default:
            break
        }
        return 0
    }
}

// MARK: TouchedBannerCellDelegate
extension MainViewController: TouchedBannerCellDelegate {
    func openBannerWeb(indexPatRow: Int) {
        let site = webService.openWeb(row: indexPatRow)
        present(site, animated: true)
    }
}

// MARK: DidTapPlayButtonSecondDelegate
extension MainViewController: DidTapPlayButtonSecondDelegate {
    func didTapPlayButton(newMusic: String) {
        playerVC.newMusic = newMusic
        bottomButton.newMusic = newMusic
        bottomButton.playButton.setImage(UIImage(named: "pause"), for: .normal)
        present(playerVC, animated: true)
    }
}

extension MainViewController: PageViewControllerDelegate {
    func sendMusicTitle(musicTitle: String) {
        playerVC.newMusic = musicTitle
        bottomButton.newMusic = musicTitle
        bottomButton.playButton.setImage(UIImage(named: "pause"), for: .normal)
        present(playerVC, animated: true)
    }
}


// MARK: DidTapBackgroundDelegate
extension MainViewController: DidTapBackgroundDelegate {
    func moveToOut() {
        moveToEditView(priority: .defaultLow)
    }
}

// MARK: DidTapEdiViewTableCellDelegate
extension MainViewController: DidTapEdiViewTableCellDelegate {
    func didTapEdiViewTableCell(section: Int, row: Int) {
        if section == 0 {
            let currentUser = Auth.auth().currentUser
            switch row {
            case 0:
                guard currentUser != nil else {
                    alertNormal(title: "로그인을 해주세요", message: "사용자의 정보가 없습니다")
                    return
                }
                let myAccontVC = MyAccountViewController()
                myAccontVC.user = self.user
                navigationController?.pushViewController(myAccontVC, animated: true)
            case 1:
                print("zzz")
            case 2:
                guard currentUser != nil else {
                    alertNormal(title: "로그인을 해주세요", message: "사용자의 정보가 없습니다")
                    return
                }
                alertAddAction(title: "로그아웃", message: "로그아웃 하시겠습니까?") { (_) in
                    self.firebseService.signOut()
                    self.editView.loginButton.isEnabled = true
                    self.editView.loginButton.setImage(UIImage(named: " "), for: .normal)
                    self.editView.loginButton.setTitle("로그인", for: .normal)
                }
            default:
                break
            }
        } else {
            let appIntroVC = AppIntroViewController()
            navigationController?.pushViewController(appIntroVC, animated: true)
        }
    }
}

// MARK: DidTapLoginButtonDelegate
extension MainViewController: DidTapLoginButtonDelegate {
    func prsentLoginVC() {
        let loginVC = LoginViewController()
        loginVC.bottomLoginPageViewController.firstVC.successSignInDelegate = self
        present(loginVC, animated: true)
    }
}

// MARK: SuccessSignInDelegate
extension MainViewController: SuccessSignInDelegate {
    func whenSuccessSignIn() {
        self.fetchAll()
        
        UIView.animate(withDuration: 0.5) {
            self.constraintX?.priority = .defaultLow
            self.constraintX?.isActive = true
            self.view.layoutIfNeeded()
        }
    }
}
