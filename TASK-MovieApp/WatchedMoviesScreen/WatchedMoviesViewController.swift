//
//  WatchedMoviesViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 04/11/2020.
//

import UIKit

class WatchedMoviesViewController: UIViewController {
    
    //MARK: Properties
    let tableViewMovieFeed: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .darkGray
        return tableView
    }()
    
    var screenData = [Movie]()
    
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
            return
        }
        print("Unable to create screen data")
    }
}


extension WatchedMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func setupTableView() {
        view.addSubview(tableViewMovieFeed)
        tableViewMovieFeed.delegate = self
        tableViewMovieFeed.dataSource = self
        tableViewMovieFeed.register(WatchedMoviesFeedCell.self, forCellReuseIdentifier: WatchedMoviesFeedCell.reuseIdentifier)
        tableViewMovieFeed.rowHeight = UITableView.automaticDimension
        tableViewMovieFeed.estimatedRowHeight = 170
        moviesTableViewConstraints()
    }
    
    private func moviesTableViewConstraints () {
        NSLayoutConstraint.activate([
            tableViewMovieFeed.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            tableViewMovieFeed.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableViewMovieFeed.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewMovieFeed.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WatchedMoviesFeedCell = tableView.dequeueReusableCell(for: indexPath)
        cell.fill(with: screenData[indexPath.row])
        cell.controllerDelegate = self
        return cell
    }
    
}

extension WatchedMoviesViewController: ControllerDelegate {
    func favouriteButtonTapped(on movie: Movie) {
        if movie.favourite == true {
            CoreDataManager.sharedManager.deleteMovie(movie)
            fetchScreenData()
            tableViewMovieFeed.reloadData()
        }
        else {
            CoreDataManager.sharedManager.switchForId(type: .favourite, for: movie.id)
            fetchScreenData()
            tableViewMovieFeed.reloadData()
        }
    }
    
    func watchedButtonTapped(on movie: Movie) {
        if movie.favourite == true {
            CoreDataManager.sharedManager.deleteMovie(movie)
            fetchScreenData()
            tableViewMovieFeed.reloadData()
        }
        else {
            CoreDataManager.sharedManager.switchForId(type: .watched, for: movie.id)
            fetchScreenData()
            tableViewMovieFeed.reloadData()
        }
    }
}





