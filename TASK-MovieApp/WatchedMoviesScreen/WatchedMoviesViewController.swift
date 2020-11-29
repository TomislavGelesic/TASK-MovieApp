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
    
    var screenData = [Movie]()
    
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
        fetchScreenData()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        fetchScreenData()
        tableView.reloadData()
    }
}

extension WatchedMoviesViewController {
    
    //MARK: Private Functions
    
    private func fetchScreenData() {
        
        if let data = CoreDataManager.sharedInstance.getWatchedMovies(){
            self.screenData = data
        }
    }
    
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
        
        return screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MovieListTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.configure(with: screenData[indexPath.row])
        cell.movieListTableViewCellDelegate = self
        
        return cell
    }
}

extension WatchedMoviesViewController: MovieListTableViewCellDelegate {
    
    func favouriteButtonTapped(cell: MovieListTableViewCell) {
        
        guard let id = cell.movie?.id else { return }
        
        CoreDataManager.sharedInstance.switchForId(type: .favourite, for: Int64(id))
        
        fetchScreenData()
        
        tableView.reloadData()
    }
    
    func watchedButtonTapped(cell: MovieListTableViewCell) {
        
        guard let id = cell.movie?.id else { return }
        
        CoreDataManager.sharedInstance.switchForId(type: .watched, for: Int64(id))
        
        fetchScreenData()
        
        tableView.reloadData()
    }
}





