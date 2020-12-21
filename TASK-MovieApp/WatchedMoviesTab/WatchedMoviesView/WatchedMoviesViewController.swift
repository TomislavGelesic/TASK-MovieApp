//
//  WatchedMoviesViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 04/11/2020.
//

import UIKit
import SnapKit
import Combine

class WatchedMoviesViewController: UIViewController {
    
    //MARK: Properties
    
    private var watchedMoviesViewModel = MovieListWithPreferenceViewModel(preferenceType: .watched)
    
    private var disposeBag = Set<AnyCancellable>()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .darkGray
        return tableView
    }()
    
    private let pullToRefreshControl: UIRefreshControl = {
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
        
        setupViewSubscribers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        watchedMoviesViewModel.getNewScreenDataSubject.send()
            
    }
}

extension WatchedMoviesViewController {
    
    //MARK: Private Functions
    
    private func setupTableView() {
        
        
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 170
        
        
        tableView.addSubview(pullToRefreshControl)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setupViewSubscribers() {
        
        watchedMoviesViewModel.initializeScreenDataSubject(with: self.watchedMoviesViewModel.getNewScreenDataSubject.eraseToAnyPublisher())
            .store(in: &disposeBag)
        
        watchedMoviesViewModel.initializeMoviePreferenceSubject(with: self.watchedMoviesViewModel.movieReferenceSubject.eraseToAnyPublisher())
            .store(in: &disposeBag)
        
        watchedMoviesViewModel.refreshScreenDataSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (rowUpdateType) in
                switch (rowUpdateType) {
                case .all:
                    self.tableView.reloadData()
                    break
                case .cellWith(let indexPath):
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    break
                }
                self.pullToRefreshControl.endRefreshing()
            }
            .store(in: &disposeBag)
    }
    
    private func setupPullToRefreshControl() {
        
        pullToRefreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
    }
    
    @objc func refreshMovies() {
        
        watchedMoviesViewModel.getNewScreenDataSubject.send()
    }
}

extension WatchedMoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return watchedMoviesViewModel.screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MovieTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.configure(with: watchedMoviesViewModel.screenData[indexPath.row], enable: [.watched])
        
        cell.preferenceChanged = { [unowned self] (buttonType, value) in
            
            let id = self.watchedMoviesViewModel.screenData[indexPath.row].id
            
            self.watchedMoviesViewModel.movieReferenceSubject.send((id, buttonType, value))
        }
        
        return cell
    }
}





