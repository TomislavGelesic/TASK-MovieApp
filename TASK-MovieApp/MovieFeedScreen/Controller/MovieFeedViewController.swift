//
//  MovieFeedViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit

class MovieFeedViewController: UIViewController {
    
    //MARK: Properties
    
    var moviesJSONModel = [MovieJSONModel]()
    
    var screenData = [Movie]()
    
    let tableViewMovieFeed: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .darkGray
        return tableView
    }()
    
    let pullToRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .white
        control.backgroundColor = .darkGray
        control.attributedTitle = NSAttributedString(string: "Pull to refresh")
        return control
    }()
    
    //MARK: Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupPullToRefreshControl()
        fetchData(spinnerOn: true) {
            self.saveToCoreData(self.moviesJSONModel)
            self.fetchScreenData()
            self.tableViewMovieFeed.reloadData()
            self.hideSpinner()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewMovieFeed.reloadData()
    }
}

extension MovieFeedViewController {
    
    //MARK: Private Functions
    
    
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
    
    private func saveToCoreData(_ jsonModel: [MovieJSONModel]) {
        for movie in jsonModel {
            CoreDataManager.sharedManager.saveJSONModel(movie)
        }
    }
    
    private func fetchScreenData() {
        
        if let data = CoreDataManager.sharedManager.getAllMovies(){
            self.screenData = data
            return
        }
        print("Unable to create screen data")
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
                self.fetchScreenData()
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
        tableViewMovieFeed.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(50)
            make.bottom.leading.trailing.equalTo(view)
        }
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
        let movieDetailScreen = MovieDetailViewController(for: Int(screenData[indexPath.row].id))
        movieDetailScreen.modalPresentationStyle = .fullScreen
        self.present(movieDetailScreen, animated: true, completion: nil)
        
    }
    
}

extension MovieFeedViewController: MovieFeedTableViewCellDelegate {
    func favouriteButtonTapped(cell: MovieFeedTableViewCell) {
        guard let id = cell.movie?.id else { return }
        CoreDataManager.sharedManager.switchForId(type: .favourite, for: Int64(id))
        fetchScreenData()
        tableViewMovieFeed.reloadData()
    }
    
    func watchedButtonTapped(cell: MovieFeedTableViewCell) {
        guard let id = cell.movie?.id else { return }
        CoreDataManager.sharedManager.switchForId(type: .watched, for: Int64(id))
        fetchScreenData()
        tableViewMovieFeed.reloadData()
    }
    
    
}


