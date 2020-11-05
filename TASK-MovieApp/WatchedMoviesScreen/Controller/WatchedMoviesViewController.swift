//
//  WatchedMoviesViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 04/11/2020.
//

import UIKit

class WatchedMoviesViewController: UIViewController {
    
    //MARK: Properties
    let tableViewMovieWatched: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let pullToRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .white
        control.backgroundColor = .darkGray
        control.attributedTitle = NSAttributedString(string: "Pull to refresh")
        return control
    }()
    
    
    var screenData = [MovieFeedScreenDatum]()
    
    //MARK: Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController()
        setupTableView()
        setupPullToRefreshControl()
    }
}

extension WatchedMoviesViewController {
    
    //MARK: Private Functions
    
    private func setViewController() {
        view.backgroundColor = .darkGray
    }
    
    private func setupPullToRefreshControl() {
        tableViewMovieWatched.addSubview(pullToRefreshControl)
        pullToRefreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    
    
    private func createScreenData() {
        
    }
    
    private func updateMyMovieDataBase() {
        
    }
    
    
    @objc func refreshNews() {
        print("Retrieving update on movies...")
        
    }
}


extension WatchedMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func setupTableView() {
        view.addSubview(tableViewMovieWatched)
        tableViewMovieWatched.delegate = self
        tableViewMovieWatched.dataSource = self
        tableViewMovieWatched.register(MovieWatchedTableViewCell.self, forCellReuseIdentifier: MovieWatchedTableViewCell.reuseIdentifier)
        tableViewMovieWatched.rowHeight = UITableView.automaticDimension
        tableViewMovieWatched.estimatedRowHeight = 170
        moviesTableViewConstraints()
    }
    
    private func moviesTableViewConstraints () {
        NSLayoutConstraint.activate([
            tableViewMovieWatched.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            tableViewMovieWatched.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableViewMovieWatched.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewMovieWatched.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieWatchedTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.fill(with: screenData[indexPath.row])
        cell.movieWatchedTableViewCellDelegate = self
        return cell
    }
    
}

extension WatchedMoviesViewController: MovieWatchedTableViewCellDelegate {
    
    
    func buttonTapped(button: ButtonSelection, id: Int) {
        CoreDataManager.sharedManager.buttonTapped(button: button, id: id)
        updateScreenDataWithCoreData()
        tableViewMovieWatched.reloadData()
    }
    
    
    private func updateScreenDataWithCoreData() {
        
        guard let savedMovies = CoreDataManager.sharedManager.fetchAllCoreDataMovies() else { return }
        
        for (index, movie) in savedMovies.enumerated() {
            if screenData[index].id == movie.id {
                screenData[index].favourite = movie.favourite
                screenData[index].watched = movie.watched
            }
        }
    }
    
    
}



