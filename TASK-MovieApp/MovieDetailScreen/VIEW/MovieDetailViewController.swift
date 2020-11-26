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

protocol MovieDetailViewControllerDelegate: class {
    func reloadData()
}

class MovieDetailViewController: UIViewController {

    
    var movieID: Int64
    
    var movieDetailPresenter: MovieDetailPresenter?
    
    weak var movieDetailViewControllerDelegate: MovieDetailViewControllerDelegate?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        return tableView
    }()
    
    //MARK: init
    
    init(for movie: Movie, delegate: MovieDetailViewControllerDelegate) {
        
        movieID = movie.id
        movieDetailViewControllerDelegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        
        setupViewController()
        setupTableView()
        
        movieDetailPresenter = MovieDetailPresenter(delegate: self, for: movieID)
    
        
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
}


extension MovieDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = movieDetailPresenter?.screenData.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        switch indexPath.row {
        
        case 0:
            
            guard let data = movieDetailPresenter?.getDataValueForKey(.imageWithButtons) as? Dictionary<String, Any> else { return UITableViewCell() }
            
            let cell: MovieDetailImageCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: data)
            cell.movieDetailImageCellDelegate = self
            return cell
        
        case 1:
            
            let cell: MovieDetailTitleCell = tableView.dequeueReusableCell(for: indexPath)
            
            if let title = movieDetailPresenter?.getDataValueForKey(.title) as? String {
                
                cell.configure(with: title)
            }
            
            return cell
        
        case 2:
            
            let cell: MovieDetailGenreCell = tableView.dequeueReusableCell(for: indexPath)
           
            if let genres = movieDetailPresenter?.getDataValueForKey(.genre) as? String {
                cell.configure(with: genres)
            }
            return cell
            
        case 3:
            
            let cell: MovieDetailQuoteCell = tableView.dequeueReusableCell(for: indexPath)
            
            if let quote = movieDetailPresenter?.getDataValueForKey(.quote) as? String {
                cell.configure(with: quote)
            }
            
            return cell
            
        default:
            
            let cell: MovieDetailDescriptionCell = tableView.dequeueReusableCell(for: indexPath)
            
            if let description = movieDetailPresenter?.getDataValueForKey(.description) as? String {
                cell.configure(with: description)
            }
            
            return cell
        }
    }    
}


extension MovieDetailViewController: MovieDetailImageCellDelegate {
    
    func buttonTapped(type: ButtonType) {

        movieDetailPresenter?.buttonTapped(id: movieID, type: type)
    }
    
    func backButtonTapped() {
        
        movieDetailViewControllerDelegate?.reloadData()
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
    
    func showAlertView() {
        showAPIFailedAlert()
    }
    
    func reloadTableView() {
        
        tableView.reloadData()
    }
}



