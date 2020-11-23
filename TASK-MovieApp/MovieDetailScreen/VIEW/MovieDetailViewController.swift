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
    
    var screenData: DetailScreenData = DetailScreenData(rowData: [MovieDetailScreenRowData<MovieDetailScreenRowTypes, String>](), watched: false, favourite: false, id: -1)
    
    var movieID: Int64
    
    var movieDetailPresenter: MovieDetailPresenter?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        return tableView
    }()
    
    //MARK: init
    
    init(_ movie: Movie) {
        
        movieID = movie.id
        
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
        
        movieDetailPresenter = MovieDetailPresenter(delegate: self, for: movieID)
        
        if let data = movieDetailPresenter?.getNewScreenData() {
            screenData = data
        }
        
        tableView.reloadData()
        
    }
}

extension MovieDetailViewController {
    
    //MARK: Functions
    
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
    
    func showAPIFailAlert(){
        
        let alert = UIAlertController(title: "Error", message: "Ups, error occured!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        DispatchQueue.main.async {
            self.hideSpinner()
            self.present(alert, animated: true, completion: nil)
        }
    }
}


extension MovieDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return screenData.rowData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = screenData.rowData[indexPath.row]
        
        switch item.type {
        case .image:
            let cell: MovieDetailImageCell = tableView.dequeueReusableCell(for: indexPath)
            let urlToImage = URL(string: Constants.MOVIE_API.IMAGE_BASE + Constants.MOVIE_API.IMAGE_SIZE +  item.value)
            
            cell.imageViewMovie.setImage(url: urlToImage)
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
    
    func buttonTapped(on cell: MovieDetailImageCell, type: ButtonType) {
        
        switch type {
        
        case .favourite:
            
            movieDetailPresenter?.buttonTapped(id: movieID, type: .favourite)
            
            if let movie = movieDetailPresenter?.coreDataManager.getMovie(for: movieID) {
                cell.setButtonImage(on: .favourite, selected: movie.favourite)
            }
            
        case .watched:
            
            movieDetailPresenter?.buttonTapped(id: movieID, type: .watched)
            
            if let movie = movieDetailPresenter?.coreDataManager.getMovie(for: movieID) {
                cell.setButtonImage(on: .watched, selected: movie.watched)
            }
        }
    }
    
    func backButtonTapped() {
        
        dismiss(animated: true, completion: nil)
    }
}

extension MovieDetailViewController: MovieDetailPresenterDelegate {
    
    func startSpinner() {
        showSpinner()
    }
    
    func stopSpinner() {
        hideSpinner()
    }
    
    func showAlert() {
        showAPIFailAlert()
    }
    
    
}



