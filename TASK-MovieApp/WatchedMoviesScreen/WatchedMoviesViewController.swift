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
    
    //MARK: Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
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
        
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.register(MovieListTableViewCell.self, forCellReuseIdentifier: MovieListTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 170
        
        moviesTableViewConstraints()
    }
    
    private func moviesTableViewConstraints () {
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
}

extension WatchedMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return watchedMoviesPresenter?.screenData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MovieListTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        guard let movie = watchedMoviesPresenter?.screenData[indexPath.row] else { return UITableViewCell() }
                
        cell.configure(with: movie)
        cell.movieListTableViewCellDelegate = self
        
        return cell
    }
}

extension WatchedMoviesViewController: MovieListTableViewCellDelegate {
    
    func buttonTapped(cell: MovieListTableViewCell, type: ButtonType) {
        
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





