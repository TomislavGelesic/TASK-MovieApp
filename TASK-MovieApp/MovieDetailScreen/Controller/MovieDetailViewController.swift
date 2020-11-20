//
//  MovieDetailsViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit
import SnapKit
import Kingfisher
import Alamofire

class MovieDetailViewController: UIViewController {
    
    var screenData: DetailScreenData
    
    var movieID: Int64
    
    var favouriteFlag: Bool = false
    
    var watchedFlag: Bool = false    
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        return tableView
    }()
    
    //MARK: init
    
    init(_ movie: Movie) {
        movieID = movie.id
        favouriteFlag = movie.favourite
        watchedFlag = movie.watched
        screenData = DetailScreenData(rowData: [MovieDetailScreenRowData<MovieDetailScreenRowTypes, String>](), watched: false, favourite: false, id: -1)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        setupTableView()
        
        fetchMovieDetailsJSONModel(spinnerOn: true) {
            self.tableView.reloadData()
            self.hideSpinner()
        }
    }
}

extension MovieDetailViewController {
    
    //MARK: Private Functions
    
    private func setupViewController() {
        
        view.backgroundColor = .darkGray
    }
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.dataSource = self
        
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
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func fetchMovieDetailsJSONModel(spinnerOn: Bool, completion: @escaping ()->()) {
       
        let url = Constants.MOVIE_API.BASE +
                  Constants.MOVIE_API.GET_DETAILS_ON +
                  "\(Int(movieID))" +
                  Constants.MOVIE_API.KEY
        
        guard let getMovieDetailsURL = URL(string: url) else { return }
        
        if spinnerOn { showSpinner() }
        
        Alamofire.request(getMovieDetailsURL)
            .validate()
            .response { (response) in
                if let error = response.error {
                    self.showAPIFailAlert()
                    print(error)
                }
                else if let data = response.data {
                    do{
                        let jsonData = try JSONDecoder().decode(MovieDetails.self, from: data)
                        
                        self.screenData = self.createScreenData(from: jsonData)
                        completion()
                    }
                    catch {
                        self.showAPIFailAlert()
                        print(error)
                    }
                }
                else {
                    self.showAPIFailAlert()
                }
            }
    }
    
    private func createScreenData(from movieDetails: MovieDetails) -> DetailScreenData {
        
        return DetailScreenData(rowData: createRowData(from: movieDetails), watched: watchedFlag, favourite: favouriteFlag, id: movieID)
    }
    
    private func createRowData(from movieDetails: MovieDetails) -> [MovieDetailScreenRowData<MovieDetailScreenRowTypes, String>] {
        
        var rowData = [MovieDetailScreenRowData<MovieDetailScreenRowTypes, String>]()
        
        if let imagePath = movieDetails.poster_path {
            rowData.append(MovieDetailScreenRowData.init(type: .image, value: imagePath))
        }
        
        rowData.append(MovieDetailScreenRowData.init(type: .title, value: movieDetails.title))
        rowData.append(MovieDetailScreenRowData.init(type: .genre, value: genresToString(movieDetails.genres)))
        rowData.append(MovieDetailScreenRowData.init(type: .quote, value: movieDetails.tagline))
        rowData.append(MovieDetailScreenRowData.init(type: .description, value: movieDetails.overview))
        
        return rowData
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
extension MovieDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return screenData.rowData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = screenData.rowData[indexPath.row]
        
        switch item.type {
        case .image:
            let cell: MovieDetailImageCell = tableView.dequeueReusableCell(for: indexPath)
            guard  let urlToImage = URL(string: Constants.MOVIE_API.IMAGE_BASE + Constants.MOVIE_API.IMAGE_SIZE +  item.value)
            else {
                cell.imageViewMovie.backgroundColor = .cyan
                return cell
            }
            cell.imageViewMovie.kf.setImage(with: urlToImage)
            cell.movieDetailImageCellDelegate = self
            cell.setButtonImage(on: .favourite, selected: screenData.favourite)
            cell.setButtonImage(on: .watched, selected: screenData.watched)
            return cell
            
        case .title:
            let cell: MovieDetailTitleCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with:  item.value)
            return cell
            
        case .genre:
            let cell: MovieDetailGenreCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with:  item.value)
            return cell
            
        case .quote:
            let cell: MovieDetailQuoteCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with:  item.value)
            return cell
            
        case .description:
            let cell: MovieDetailDescriptionCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: item.value)
            return cell
        }
    }
    
}


extension MovieDetailViewController: MovieDetailImageCellDelegate {
    
    func favouriteButtonTapped(on id: Int64) {
        
        CoreDataManager.sharedInstance.switchValueOnMovie(on: id, for: .favourite)
        
        tableView.reloadData()
    }
    
    func watchedButtonTapped(on id: Int64) {
        
        CoreDataManager.sharedInstance.switchValueOnMovie(on: id, for: .watched)
        
        tableView.reloadData()
    }
    
    
    func backButtonTapped() {
        
        dismiss(animated: true, completion: nil)
    }
}



