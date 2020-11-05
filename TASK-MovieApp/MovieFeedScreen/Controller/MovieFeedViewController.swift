//
//  MovieFeedViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit

class MovieFeedViewController: UIViewController {
    
    //MARK: Properties
    let tableViewMovieFeed: UITableView = {
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
    
    var moviesJSONModel = [MovieJSONModel]()
    
    var screenData = [MovieFeedScreenDatum]()
    
    //MARK: Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController()
        setupTableView()
        setupPullToRefreshControl()
        fetchData(spinnerOn: true) {
            self.createScreenData()
            self.tableViewMovieFeed.reloadData()
            self.hideSpinner()
        }
    }
}

extension MovieFeedViewController {
    
    //MARK: Private Functions
    
    private func setViewController() {
        view.backgroundColor = .darkGray
    }
    
    private func setupPullToRefreshControl() {
        tableViewMovieFeed.addSubview(pullToRefreshControl)
        pullToRefreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    private func fetchData(spinnerOn: Bool, completion: @escaping () -> ()) {
        guard let url = URL(string: "\(Constants.MOVIE_API.BASE)\(Constants.MOVIE_API.GET_NOW_PLAYING)\(Constants.MOVIE_API.KEY)") else { return }
        
        if spinnerOn { showSpinner() }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.showAPIFailAlert()
                print(error)
            }
            else {
                if let data = data {
                    do{
                        let json = try JSONDecoder().decode(MovieResponseJSONModel.self, from: data)
                        self.moviesJSONModel = json.results
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                    catch {
                        DispatchQueue.main.async {
                            self.showAPIFailAlert()
                            print(error)
                        }
                    }
                }
            }
        }.resume()
    }
    
    private func createScreenData() {
        for movie in moviesJSONModel {
            screenData.append( MovieFeedScreenDatum(id: movie.id,
                                                    poster_path: movie.poster_path,
                                                    title: movie.title,
                                                    release_date: movie.release_date,
                                                    overview: movie.overview,
                                                    genre_ids: movie.genre_ids,
                                                    favourite: false,
                                                    watched: false)
            )
        }
    }
    
    private func updateMyMovieDataBase() {
        //MARK: Do this here
    }
    
    private func showAPIFailAlert(){
        let alert = UIAlertController(title: "Error", message: "Ups, error occured!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        DispatchQueue.main.async {
            self.hideSpinner()
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func refreshNews() {
        print("Retrieving update on movies...")
        fetchData(spinnerOn: false) {
                self.createScreenData()
                self.tableViewMovieFeed.reloadData()
                self.pullToRefreshControl.endRefreshing()
        }
    }
}


extension MovieFeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func setupTableView() {
        view.addSubview(tableViewMovieFeed)
        tableViewMovieFeed.delegate = self
        tableViewMovieFeed.dataSource = self
        tableViewMovieFeed.register(MovieFeedTableViewCell.self, forCellReuseIdentifier: MovieFeedTableViewCell.reuseIdentifier)
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
        let cell: MovieFeedTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.fill(with: screenData[indexPath.row])
        cell.movieFeedTableViewCellDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailScreen = MovieDetailViewController(for: screenData[indexPath.row].id)
        movieDetailScreen.modalPresentationStyle = .fullScreen
        self.present(movieDetailScreen, animated: true, completion: nil)
    }
    
}

extension MovieFeedViewController: MovieFeedTableViewCellDelegate {
    
    
    func buttonTapped(button: ButtonSelection, id: Int) {
        CoreDataManager.sharedManager.buttonTapped(button: button, id: id)
        updateScreenDataWithCoreData()
        tableViewMovieFeed.reloadData()
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


