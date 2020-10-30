//
//  MovieFeedViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit

class MovieFeedViewController: UIViewController {
    
    var movies = [Movie]()
    
    //MARK: Properties
    let moviesTableView: UITableView = {
        let tableView = UITableView()
                tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let pullToRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.attributedTitle = NSAttributedString(string: "Pull to refresh")
        return control
    }()
    
    //MARK: Life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        setupTableView()
        setupPullToRefreshControl()
        fetchData(spinnerOn: true)
        
    }
    
}

extension MovieFeedViewController {
    //MARK: Private Functions
    
    
    private func setupPullToRefreshControl() {
        moviesTableView.addSubview(pullToRefreshControl)
        pullToRefreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    //MARK: fetchData
    private func fetchData(spinnerOn: Bool) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=7641bf39b204ff74468bc996eaad0b04") else { return }
        
        if spinnerOn {
            showSpinner()
        }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.showAPIFailAlert()
                print(error)
            }
            else {
                if let data = data {
                    
                    do{
                        let json = try JSONDecoder().decode(MoviePOJO.self, from: data)
                        self.movies = json.results
                        DispatchQueue.main.async {
                            self.moviesTableView.reloadData()
                            self.pullToRefreshControl.endRefreshing()
                            self.hideSpinner()
                        }
                    }
                    catch {
                        self.showAPIFailAlert()
                        print(error)
                    }
                }
            }
        }.resume()
    }
    
    @objc func refreshNews() {
        print("Retrieving update on news...")
        fetchData(spinnerOn: false)
    }
    
    
    private func showAPIFailAlert(){
        let alert = UIAlertController(title: "Error", message: "Ups, error occured!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        DispatchQueue.main.async {
            self.hideSpinner()
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
}
extension MovieFeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func setupTableView() {
        view.addSubview(moviesTableView)
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        moviesTableView.register(MovieFeedTableViewCell.self, forCellReuseIdentifier: "MovieFeedTableViewCell")
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
        let cell: MovieFeedTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.fillCell(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailScreen = MovieDetailViewController(movie: movies[indexPath.row])
        movieDetailScreen.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(movieDetailScreen, animated: true)
    }
    
    
    
}
