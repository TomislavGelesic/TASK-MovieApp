//
//  FavouriteMoviesViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 04/11/2020.
//

import UIKit
import SnapKit

class FavouriteMoviesViewController: UIViewController {
    
    //MARK: Properties
    
    var favouriteMoviesPresenter: FavouriteMoviesPresenter?
    
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
        
        favouriteMoviesPresenter = FavouriteMoviesPresenter(delegate: self)
        
        setupTableView()
        setupPullToRefreshControl()
        
        favouriteMoviesPresenter?.getNewScreenData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        favouriteMoviesPresenter?.getNewScreenData()
    }
}

extension FavouriteMoviesViewController {
    
    //MARK: Private Functions
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.register(MovieListTableViewCell.self, forCellReuseIdentifier: MovieListTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 170
        
        setTableViewConstraints()
    }
    
    private func setTableViewConstraints() {
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setupPullToRefreshControl() {
        
        tableView.addSubview(pullToRefreshControl)
        
        pullToRefreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
    }
    
    @objc func refreshMovies() {
        
        favouriteMoviesPresenter?.getNewScreenData()
        
        self.pullToRefreshControl.endRefreshing()
    }
}

extension FavouriteMoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favouriteMoviesPresenter?.screenData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MovieListTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        if let movie = favouriteMoviesPresenter?.screenData[indexPath.row] {
            cell.configure(with: movie)
        }
        
        cell.movieListTableViewCellDelegate = self
        
        return cell
    }    
}

extension FavouriteMoviesViewController: MovieListTableViewCellDelegate {
    
    func buttonTapped(cell: MovieListTableViewCell, type: ButtonType) {
        
        guard let id = cell.movie?.id else { return }
        
        favouriteMoviesPresenter?.buttonTapped(for: id, type: type)
    }
}

extension FavouriteMoviesViewController: FavouriteMoviesPresenterDelegate {
    
    func showAlertView() {
        
        showSpinner()
    }
    
    func reloadTableView() {
        
        tableView.reloadData()
    }
    
    
}





