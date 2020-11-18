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
    
    var screenData: [RowData] = [RowData]()
    
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
    
    init(for id: Int) {
        
        self.movieID = Int64(id)
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
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func fetchMovieDetailsJSONModel(spinnerOn: Bool, completion: @escaping ()->()) {
        guard let urlToGetMovieDetails = URL(string: Constants.MOVIE_API.BASE +
                                Constants.MOVIE_API.GET_DETAILS_ON + "\(movieID)" +
                                Constants.MOVIE_API.KEY
        ) else { return }
        
        if spinnerOn { showSpinner() }
        
        Alamofire.request(urlToGetMovieDetails)
            .validate()
            .response { (response) in
                if let error = response.error {
                    self.showAPIFailAlert()
                    print(error)
                }
                else if let data = response.data {
                    do{
                        let json = try JSONDecoder().decode(MovieDetails.self, from: data)
                        self.screenData = self.createScreenData(from: json)
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
    
    
    private func createScreenData(from details: MovieDetails) -> [RowData] {
        
        var row = [RowData]()
        
        if let imagePath = details.poster_path {
            row.append(RowData.init(type: .image, value: imagePath))
        }
        else {
            row.append(RowData.init(type: .image, value: ""))
        }
        
        row.append(RowData.init(type: .title, value: details.title))
        row.append(RowData.init(type: .genre, value: genresToString(details.genres)))
        row.append(RowData.init(type: .quote, value: details.tagline))
        row.append(RowData.init(type: .description, value: details.overview))
        
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
            guard  let urlToImage = URL(string: Constants.MOVIE_API.IMAGE_BASE + Constants.MOVIE_API.IMAGE_SIZE +  item.value)
            else {
                cell.imageViewMovie.backgroundColor = .cyan
                return cell
            }
            cell.imageViewMovie.kf.setImage(with: urlToImage)
            cell.movieDetailImageCellDelegate = self
            cell.updateButtonImage(for: movieID, and: .favourite)
            cell.updateButtonImage(for: movieID, and: .watched)
            return cell
            
        case .title:
            let cell: MovieDetailTitleCell = tableView.dequeueReusableCell(for: indexPath)
            cell.fill(with:  item.value)
            return cell
            
        case .genre:
            let cell: MovieDetailGenreCell = tableView.dequeueReusableCell(for: indexPath)
            cell.fill(with:  item.value)
            return cell
            
        case .quote:
            let cell: MovieDetailQuoteCell = tableView.dequeueReusableCell(for: indexPath)
            cell.fill(with:  item.value)
            return cell
            
        case .description:
            let cell: MovieDetailDescriptionCell = tableView.dequeueReusableCell(for: indexPath)
            cell.fill(with: item.value)
            return cell
        }
    }
    
}


extension MovieDetailViewController: MovieDetailImageCellDelegate {
    
    func favouriteButtonTapped(cell: MovieDetailImageCell) {
        
        CoreDataManager.sharedManager.switchForId(type: .favourite, for: movieID)
        
        guard let status = CoreDataManager.sharedManager.checkButtonStatus(for: movieID, and: .favourite) else { return }
        
        if status {
            cell.favouriteButton.setImage(UIImage(named: "star_filled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else {
            cell.favouriteButton.setImage(UIImage(named: "star_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        tableView.reloadData()
    }
    
    func watchedButtonTapped(cell: MovieDetailImageCell) {
        
        CoreDataManager.sharedManager.switchForId(type: .watched, for: movieID)
        
        guard let status = CoreDataManager.sharedManager.checkButtonStatus(for: movieID, and: .watched) else { return }
        
        if status {
            cell.watchedButton.setImage(UIImage(named: "watched_filled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else {
            cell.watchedButton.setImage(UIImage(named: "watched_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        tableView.reloadData()
    }
    
    
    func backButtonTapped() {
        
        dismiss(animated: true, completion: nil)
    }
}



