//
//  FavouriteMoviesViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 04/11/2020.
//

import UIKit

class FavouriteMoviesViewController: UIViewController {
    
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
        let cell: FavouriteMoviesFeedCell = tableView.dequeueReusableCell(for: indexPath)
        cell.fill(with: screenData[indexPath.row])
        cell.controllerDelegate = self
        return cell
    }
    
}

extension FavouriteMoviesViewController: ControllerDelegate {
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





