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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        movieDetailPresenter?.getNewScreenData()
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

        //how to return exactly that?!?!
        
        guard let item = movieDetailPresenter?.screenData[indexPath.row] else { return UITableViewCell() }
        
        switch item.type {
        
        case .imageWithButtons:
            
            let cell: MovieDetailImageCell = tableView.dequeueReusableCell(for: indexPath)
            
            if let value = item.value as? Dictionary<String, Any> {
                cell.configure(with: value)
                cell.movieDetailImageCellDelegate = self
            }
            
            return cell
        
        case .title:
            
            let cell: MovieDetailTitleCell = tableView.dequeueReusableCell(for: indexPath)
            
            if let title = item.value as? String {
                
                cell.configure(with: title)
            }
            
            return cell
        
        case .genre:
            
            let cell: MovieDetailGenreCell = tableView.dequeueReusableCell(for: indexPath)
           
            if let genres = item.value as? String {
                cell.configure(with: genres)
            }
            return cell
            
        case .quote:
            
            let cell: MovieDetailQuoteCell = tableView.dequeueReusableCell(for: indexPath)
            
            if let quote = item.value as? String {
                cell.configure(with: quote)
            }
            
            return cell
            
        case .description:
            
            let cell: MovieDetailDescriptionCell = tableView.dequeueReusableCell(for: indexPath)
            
            if let description = item.value as? String {
                cell.configure(with: description)
            }
            
            return cell
        }
    }    
}


extension MovieDetailViewController: MovieDetailImageCellDelegate {
    
    func buttonTapped(type: ButtonType) {

        movieDetailPresenter?.buttonTapped(id: movieID, type: type)
        
        movieDetailPresenter?.getNewScreenData()
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



