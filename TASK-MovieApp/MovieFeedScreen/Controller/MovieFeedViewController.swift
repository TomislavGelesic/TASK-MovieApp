//
//  MovieFeedViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit

let USER_DATA_KEY: String = "USER_DATA_KEY"

class MovieFeedViewController: UIViewController {
    
    //MARK: Properties
    let moviesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let pullToRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.attributedTitle = NSAttributedString(string: "Pull to refresh")
        return control
    }()
    
    var movies = [Movie]()
    
    let userDefaults = UserDefaults.standard
    
    //MARK: Life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        setViewController()
        setupTableView()
        setupPullToRefreshControl()
        fetchData(spinnerOn: true)
    }
}

extension MovieFeedViewController {
    
    //MARK: Private Functions
    private func setNavigationController() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setViewController() {
        view.backgroundColor = .darkGray
    }
    
    private func setupPullToRefreshControl() {
        moviesTableView.addSubview(pullToRefreshControl)
        pullToRefreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }

    private func fetchData(spinnerOn: Bool) {
        let tomislav = "\(Constants.MOVIE_API.BASE)\(Constants.MOVIE_API.GET_NOW_PLAYING)\(Constants.MOVIE_API.KEY)"
        guard let url = URL(string: tomislav) else { return }
        
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
                        let json = try JSONDecoder().decode(MovieJSON.self, from: data)
                        self.movies = json.results
                        DispatchQueue.main.async {
                            self.moviesTableView.reloadData()
                            self.pullToRefreshControl.endRefreshing()
                            self.hideSpinner()
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
        fetchData(spinnerOn: false) 
    }
}

//MARK: UITABLE DELEGATE
extension MovieFeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func setupTableView() {
        view.addSubview(moviesTableView)
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        moviesTableView.register(MovieFeedTableViewCell.self, forCellReuseIdentifier: MovieFeedTableViewCell.reuseIdentifier)
        moviesTableView.rowHeight = UITableView.automaticDimension
        moviesTableView.estimatedRowHeight = 170
        moviesTableViewConstraints()
    }
    
    private func moviesTableViewConstraints () {
        NSLayoutConstraint.activate([
            moviesTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            moviesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            moviesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        let cell: MovieFeedTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.fill(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailScreen = MovieDetailViewController(for: movies[indexPath.row].id)
        navigationController?.pushViewController(movieDetailScreen, animated: true)
    }
    
}

