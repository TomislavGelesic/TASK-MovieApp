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
    
    var favouriteMoviesViewModel: FavouriteMoviesViewModel?
    
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
        
        favouriteMoviesViewModel = FavouriteMoviesViewModel(delegate: self)
        
        setupTableView()
        setupPullToRefreshControl()
        
        favouriteMoviesViewModel?.getNewScreenData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        favouriteMoviesViewModel?.getNewScreenData()
    }
}

extension FavouriteMoviesViewController {
    
    //MARK: Private Functions
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
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
        
        pullToRefreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        
        tableView.addSubview(pullToRefreshControl)        
    }
    
    @objc func refreshMovies() {
        
        favouriteMoviesViewModel?.getNewScreenData()
        
        self.pullToRefreshControl.endRefreshing()
    }
}

extension FavouriteMoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favouriteMoviesViewModel?.screenData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MovieTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        if let movie = favouriteMoviesViewModel?.screenData[indexPath.row] {
            cell.configure(with: movie)
        }
        
        cell.movieListTableViewCellDelegate = self
        
        return cell
    }    
}

extension FavouriteMoviesViewController: MovieTableViewCellDelegate {
    
    func cellButtonTapped(cell: MovieTableViewCell, type: ButtonType) {
        
        guard let id = cell.movie?.id else { return }
        
        favouriteMoviesViewModel?.buttonTapped(for: id, type: type)
    }
}

extension FavouriteMoviesViewController: FavouriteMoviesViewModelDelegate {
    
    func showAlertView() {
        
        showSpinner()
    }
    
    func reloadTableView() {
        
        tableView.reloadData()
    }
    
    
}




