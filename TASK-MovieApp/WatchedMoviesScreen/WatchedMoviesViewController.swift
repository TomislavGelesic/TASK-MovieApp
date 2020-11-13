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
    
    let tableViewMovieFeed: UITableView = {
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
        tableViewMovieFeed.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        fetchScreenData()
        tableViewMovieFeed.reloadData()
    }
}

extension WatchedMoviesViewController {
    
    //MARK: Private Functions
    
    private func fetchScreenData() {
        
        if let data = CoreDataManager.sharedManager.getWatchedMovies(){
            self.screenData = data
        }
    }
}


extension WatchedMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func setupTableView() {
        
        view.addSubview(tableViewMovieFeed)
        tableViewMovieFeed.delegate = self
        tableViewMovieFeed.dataSource = self
        tableViewMovieFeed.register(WatchedMoviesListCell.self, forCellReuseIdentifier: WatchedMoviesListCell.reuseIdentifier)
        tableViewMovieFeed.rowHeight = UITableView.automaticDimension
        tableViewMovieFeed.estimatedRowHeight = 170
        moviesTableViewConstraints()
    }
    
    private func moviesTableViewConstraints () {
        
        tableViewMovieFeed.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(50)
            make.bottom.leading.trailing.equalTo(view)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: WatchedMoviesListCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.fill(with: screenData[indexPath.row])
        cell.watchedMoviesListCellDelegate = self
        
        return cell
    }
    
}

extension WatchedMoviesViewController: WatchedMoviesListCellDelegate {
    
    func favouriteButtonTapped(cell: WatchedMoviesListCell) {
        
        guard let id = cell.movie?.id else { return }
        
        CoreDataManager.sharedManager.switchForId(type: .favourite, for: Int64(id))
        
        fetchScreenData()
        
        tableViewMovieFeed.reloadData()
    }
    
    func watchedButtonTapped(cell: WatchedMoviesListCell) {
        
        guard let id = cell.movie?.id else { return }
        
        CoreDataManager.sharedManager.switchForId(type: .watched, for: Int64(id))
        
        fetchScreenData()
        
        tableViewMovieFeed.reloadData()
    }
}





