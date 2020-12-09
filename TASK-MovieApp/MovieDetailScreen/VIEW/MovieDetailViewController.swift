//
//  MovieDetailsViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit
import SnapKit
import Combine

protocol MovieDetailViewControllerDelegate: class {
    
    func reloadData()
}

class MovieDetailViewController: UIViewController {
    
    var movieDetailViewModel: MovieDetailViewModel?
    
    var disposeBag = Set<AnyCancellable>()
    
    weak var movieDetailViewControllerDelegate: MovieDetailViewControllerDelegate?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        return tableView
    }()
    
    //MARK: init
    
    init(for id: Int64, delegate: MovieDetailViewControllerDelegate) {
        
        movieDetailViewModel = MovieDetailViewModel(movieID: id)
        movieDetailViewControllerDelegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        for item in disposeBag {
            item.cancel()
        }
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        
        setupTableView()
        
        setupDetailViewModelSubscribers()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        movieDetailViewModel?.screenDataSubject.send(true)
    }
}

extension MovieDetailViewController {
    
    //MARK: Functions
    
    private func setupViewController() {
        
        view.backgroundColor = .darkGray
    }
    
    private func setupTableView() {
        
        tableView.dataSource = self
        
        tableView.register(MovieDetailImageCell.self, forCellReuseIdentifier: MovieDetailImageCell.reuseIdentifier)
        tableView.register(MovieDetailTitleCell.self, forCellReuseIdentifier: MovieDetailTitleCell.reuseIdentifier)
        tableView.register(MovieDetailGenreCell.self, forCellReuseIdentifier: MovieDetailGenreCell.reuseIdentifier)
        tableView.register(MovieDetailQuoteCell.self, forCellReuseIdentifier: MovieDetailQuoteCell.reuseIdentifier)
        tableView.register(MovieDetailDescriptionCell.self, forCellReuseIdentifier: MovieDetailDescriptionCell.reuseIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        
        view.addSubview(tableView)
        
        tableViewConstraints()
    }
    
    private func tableViewConstraints(){
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    func setupDetailViewModelSubscribers() {
        
        movieDetailViewModel?.spinnerSubject
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] (action) in
                
                switch (action) {
                case true:
                    self.showSpinner()
                    break
                case false:
                    self.hideSpinner()
                    break
                }
            })
            .store(in: &disposeBag)
        
        movieDetailViewModel?.alertSubject
            .receive(on: RunLoop.main)
            .sink(receiveValue: { _ in
                self.showAPIFailedAlert()
            })
            .store(in: &disposeBag)
        
        movieDetailViewModel?.screenDataSubject
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] (value) in
                self.tableView.reloadData()
            })
            .store(in: &disposeBag)
    }
}


extension MovieDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movieDetailViewModel?.screenData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let item = movieDetailViewModel?.screenData[indexPath.row] else { return UITableViewCell() }
        
        switch item.type {
        
        case .imagePathWithButtonState:
            
            let cell: MovieDetailImageCell = tableView.dequeueReusableCell(for: indexPath)
            
            if let info = item.value as? MovieDetailInfo {
                cell.configure(with: info)
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
        
        if let id = movieDetailViewModel?.movieID {
            
            movieDetailViewModel?.buttonTapped(for: id, type: type)
            
            movieDetailViewModel?.getNewScreenData()
        }
    }
    
    func backButtonTapped() {
        
        movieDetailViewControllerDelegate?.reloadData()
        dismiss(animated: true, completion: nil)
    }
}



