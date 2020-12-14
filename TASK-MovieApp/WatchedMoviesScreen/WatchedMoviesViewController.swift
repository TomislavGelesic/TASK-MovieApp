//
//  WatchedMoviesViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 04/11/2020.
//

import UIKit
import SnapKit

class WatchedMoviesViewController: UIViewController {
    
    //MARK: Properties
    
    var watchedMoviesPresenter: WatchedMoviesPresenter?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupPullToRefreshControl()
        
        view.addSubview(tableView)
        tableView.addSubview(pullToRefreshControl)
        
        moviesTableViewConstraints()
        
        watchedMoviesPresenter = WatchedMoviesPresenter(delegate: self)
        
        watchedMoviesPresenter?.getNewScreenData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        watchedMoviesPresenter?.getNewScreenData()
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
    
    private func setupPullToRefreshControl() {
        
        pullToRefreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        
    }
    
    @objc func refreshMovies() {
        
        watchedMoviesPresenter?.getNewScreenData()
        
        self.pullToRefreshControl.endRefreshing()
    }
}

extension WatchedMoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return watchedMoviesPresenter?.screenData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MovieTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        if let item = watchedMoviesPresenter?.screenData[indexPath.row] {
            cell.configure(with: item)
        }
        
        cell.movieListTableViewCellDelegate = self
        
        return cell
    }
}

extension WatchedMoviesViewController: MovieTableViewCellDelegate {
    
    func cellButtonTapped(cell: MovieTableViewCell, type: ButtonType) {
        
        guard let id = cell.movie?.id else { return }
        
        watchedMoviesPresenter?.buttonTapped(for: id, type: type)
    }
}

extension WatchedMoviesViewController: WatchedMoviesPresenterDelegate {
    
    func showAlertView() {
        
        showSpinner()
    }
    
    func reloadTableView() {
        
        tableView.reloadData()
    }
    
    
}





