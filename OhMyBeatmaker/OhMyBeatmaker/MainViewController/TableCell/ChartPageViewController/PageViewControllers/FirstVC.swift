//
//  FirstVC.swift
//  OhMyBeatmaker
//
//  Created by 김동현 on 2020/08/09.
//  Copyright © 2020 김동현. All rights reserved.
//

import UIKit

class FirstVC: UIViewController {
    
    // MARK: Properties
    private let top10TitleView: ChartHeaderView = {
        let view = ChartHeaderView()
        return view
    }()
    
    let firstChartView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .orange
//        view.isScrollEnabled = false
        return view
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureViews()
    }
    
    // MARK: Configure
    private func configure() {
        firstChartView.delegate = self
        firstChartView.dataSource = self
        firstChartView.register(ChartCell.self, forCellReuseIdentifier: UITableView.chartCellID)
    }
    
    // MARK: ConfigureViews
    func configureViews() {
        view.backgroundColor = .clear
        
        [top10TitleView, firstChartView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        top10TitleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        top10TitleView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        top10TitleView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        top10TitleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        firstChartView.topAnchor.constraint(equalTo: top10TitleView.bottomAnchor).isActive = true
        firstChartView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        firstChartView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        firstChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
    }
    
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension FirstVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let chartCell = firstChartView.dequeueReusableCell(withIdentifier: UITableView.chartCellID, for: indexPath) as? ChartCell else {fatalError()}
        return chartCell
    }
}
