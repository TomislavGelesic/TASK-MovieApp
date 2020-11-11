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

extension FavouriteMoviesViewController {
    
    //MARK: Private Functions
    
    private func fetchScreenData() {
        
        if let data = CoreDataManager.sharedManager.getFavouriteMovies(){
            self.screenData = data
            return
        }
        print("Unable to create screen data")
    }
}


extension FavouriteMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func setupTableView() {
        
        view.addSubview(tableViewMovieFeed)
        
        tableViewMovieFeed.delegate = self
        tableViewMovieFeed.dataSource = self
        tableViewMovieFeed.register(FavouriteMoviesFeedCell.self, forCellReuseIdentifier: FavouriteMoviesFeedCell.reuseIdentifier)
        tableViewMovieFeed.rowHeight = UITableView.automaticDimension
        tableViewMovieFeed.estimatedRowHeight = 170
        
        //MARK: Constraints tableView
        
        tableViewMovieFeed.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(50)
            make.bottom.leading.trailing.equalTo(view)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavouriteMoviesFeedCell = tableView.dequeueReusableCell(for: indexPath)
        cell.fill(with: screenData[indexPath.row])
        cell.favouriteMoviesFeedCellDelegate = self
        return cell
    }
    
}

extension FavouriteMoviesViewController: FavouriteMoviesFeedCellDelegate {
    
    func favouriteButtonTapped(cell: FavouriteMoviesFeedCell) {
        
        guard let id = cell.movie?.id else { return }
        
        CoreDataManager.sharedManager.switchForId(type: .favourite, for: Int64(id))
        
        fetchScreenData()
        tableViewMovieFeed.reloadData()
    }
    
    func watchedButtonTapped(cell: FavouriteMoviesFeedCell) {
        
        guard let id = cell.movie?.id else { return }
        
        CoreDataManager.sharedManager.switchForId(type: .favourite, for: Int64(id))
        
        fetchScreenData()
        
        tableViewMovieFeed.reloadData()
        
    }
}





