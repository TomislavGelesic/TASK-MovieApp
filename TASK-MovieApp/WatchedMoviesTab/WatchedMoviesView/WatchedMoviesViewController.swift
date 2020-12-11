//
//  WatchedMoviesViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 04/11/2020.
//

import UIKit
import SnapKit
import Combine

class WatchedMoviesViewController: UIViewController {
    
    //MARK: Properties
    
    private var watchedMoviesViewModel = WatchedMoviesViewModel()
    
    private var disposeBag = Set<AnyCancellable>()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .darkGray
        return tableView
    }()
    
    private let pullToRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .white
        control.backgroundColor = .darkGray
        control.attributedTitle = NSAttributedString(string: "Pull to refresh")
        return control
    }()
    
    //MARK: Life-cycle
    deinit {
        for cancellable in disposeBag {
            cancellable.cancel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupPullToRefreshControl()
        
        view.addSubview(tableView)
        tableView.addSubview(pullToRefreshControl)
        
        moviesTableViewConstraints()
        
        setupViewModelSubscribers()
    }
}

extension WatchedMoviesViewController {
    
    //MARK: Private Functions
    
    private func setupTableView() {
        
        tableView.dataSource = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 170
    }
    
    private func moviesTableViewConstraints () {
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setupViewModelSubscribers() {
        watchedMoviesViewModel.getNewScreenData()
            .receive(on: RunLoop.main)
            .sink { [unowned self] (newScreenData) in
                self.watchedMoviesViewModel.screenData = newScreenData
                self.tableView.reloadData()
            }.store(in: &disposeBag)
    }
    
    private func setupPullToRefreshControl() {
        
        pullToRefreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        
    }
    
    @objc func refreshMovies() {
        
        #warning("UpdateScreenData")
        
        self.pullToRefreshControl.endRefreshing()
    }
}

extension WatchedMoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return watchedMoviesViewModel.screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MovieTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.configure(with: watchedMoviesViewModel.screenData[indexPath.row])
        
        return cell
    }
}





