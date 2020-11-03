//
//  MovieDetailsViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var screenData: [RowData]
    var movieID: Int
    var movieDetails: MovieDetails
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        return tableView
    }()
    
    let favouriteBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "star_unfilled")
        return button
    }()
    
    let watchedBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "watched_unfilled")
        return button
    }()
    
    //MARK: init
    init(for id: Int) {
        self.movieID = id
        self.screenData = [RowData]()
        self.movieDetails = MovieDetails()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupViewController()
        setupTableView()
        fetchMovieDetails(spinnerOn: true) {
            DispatchQueue.main.async {
                self.screenData = self.createScreenData(from: self.movieDetails)
                self.tableView.reloadData()
                self.hideSpinner()
            }
        }
        
    }
}

extension MovieDetailViewController {
    //MARK: Private Functions
    
    private func setupNavigationController() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationItem.setRightBarButtonItems([watchedBarButtonItem, favouriteBarButtonItem], animated: true)
    }
    
    private func setupViewController() {
        view.backgroundColor = .white
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(MovieDetailImageCell.self, forCellReuseIdentifier: MovieDetailImageCell.reuseIdentifier)
        tableView.register(MovieDetailTitleCell.self, forCellReuseIdentifier: MovieDetailTitleCell.reuseIdentifier)
        tableView.register(MovieDetailGenreCell.self, forCellReuseIdentifier: MovieDetailGenreCell.reuseIdentifier)
        tableView.register(MovieDetailQuoteCell.self, forCellReuseIdentifier: MovieDetailQuoteCell.reuseIdentifier)
        tableView.register(MovieDetailDescriptionCell.self, forCellReuseIdentifier: MovieDetailDescriptionCell.reuseIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        
        tableViewConstraints()
    }
    
    private func tableViewConstraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    //MARK: fetchData
    private func fetchMovieDetails(spinnerOn: Bool, completion: @escaping ()->()) {
        guard let url = URL(string: Constants.MOVIE_API.BASE +
                                Constants.MOVIE_API.GET_DETAILS_ON + "\(movieID)" +
                                Constants.MOVIE_API.KEY
        ) else { return }
        
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
                        let json = try JSONDecoder().decode(MovieDetails.self, from: data)
                        self.movieDetails = json
                        completion()
                    }
                    catch {
                        self.showAPIFailAlert()
                        print(error)
                    }
                }
            }
        }.resume()
    }
    
    
    private func createScreenData(from details: MovieDetails) -> [RowData] {
        var row = [RowData]()
        if let imagePath = details.poster_path {
            row.append(RowData.init(type: .image, string: imagePath))
        }
        else {
            row.append(RowData.init(type: .image, string: ""))
        }
        row.append(RowData.init(type: .title, string: details.title))
        row.append(RowData.init(type: .genre, string: genresToString(details.genres)))
        row.append(RowData.init(type: .quote, string: details.tagline))
        row.append(RowData.init(type: .description, string: details.overview))
        return row
    }
    
    private func genresToString (_ genres: [Genre]) -> String {
        var names = String()
        var i = 0
        while i < genres.count {
            if i + 1 >= genres.count {
                names.append(genres[i].name.lowercased())
            } else {
                if i == 0 {
                    names.append(genres[i].name.capitalized + ", ")
                } else {
                    names.append(genres[i].name.lowercased() + ", ")
                }
            }
            i += 1
        }
        return names
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


//MARK: TableView Delegates
extension MovieDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = screenData[indexPath.row]
        
        switch item.type {
        case .image:
            let cell: MovieDetailImageCell = tableView.dequeueReusableCell(for: indexPath)
            guard let image = UIImage(url: URL(string: Constants.MOVIE_API.IMAGE_BASE + Constants.MOVIE_API.IMAGE_SIZE + item.value))
            else {
                cell.imageViewMovie.backgroundColor = .cyan
                return cell
            }
            cell.fill(with: image)
            return cell
        case .title:
            let cell: MovieDetailTitleCell = tableView.dequeueReusableCell(for: indexPath)
            cell.fill(with: item.value)
            return cell
        case .genre:
            let cell: MovieDetailGenreCell = tableView.dequeueReusableCell(for: indexPath)
            cell.fill(with: item.value)
            return cell
        case .quote:
            let cell: MovieDetailQuoteCell = tableView.dequeueReusableCell(for: indexPath)
            cell.fill(with: item.value)
            return cell
        case .description:
            let cell: MovieDetailDescriptionCell = tableView.dequeueReusableCell(for: indexPath)
            cell.fill(with: item.value)
            return cell
        }
    }
    
    
    
}
