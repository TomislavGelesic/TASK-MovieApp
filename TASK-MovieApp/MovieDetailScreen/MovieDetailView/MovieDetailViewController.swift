//
//  MovieDetailsViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit
import SnapKit
import Combine

class MovieDetailViewController: UIViewController {
    
    var movieDetailViewModel: MovieDetailViewModel?
    
    var disposeBag = Set<AnyCancellable>()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        return tableView
    }()
    
    //MARK: init
    
    init(for movie: MovieRowItem) {
        
        movieDetailViewModel = MovieDetailViewModel(movie: movie)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    #warning("do i need this??")
    deinit {
        for cancellable in disposeBag {
            cancellable.cancel()
        }
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        
        setupTableView()
        
        setupDetailViewModelSubscribers()
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
    
    private func setupDetailViewModelSubscribers() {
        
        movieDetailViewModel?.spinnerSubject
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] (isVisible) in
                
                switch (isVisible) {
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
        
        movieDetailViewModel?.updateScreenDataSubject
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] _ in
                
                self.tableView.reloadData()
            })
            .store(in: &disposeBag)
        
        movieDetailViewModel?.fetchScreenData()
            .store(in: &disposeBag)
        
        
    }
    
    private func returnToNowPlayingTab (_ value: Bool) {
        
        dismiss(animated: true, completion: nil)
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
            }
            
            cell.buttonTappedPublisher
                .receive(on: RunLoop.main)
                .sink { [unowned self] (buttonType) in
                    
                    switch buttonType {
                    case .favourite, .watched:
                        self.movieDetailViewModel?.switchValue(at: indexPath, on: buttonType)
                        break
                        
                    case .back:
                        self.dismiss(animated: true, completion: nil)
                        break
                    }
                }
                .store(in: &disposeBag)
        
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




