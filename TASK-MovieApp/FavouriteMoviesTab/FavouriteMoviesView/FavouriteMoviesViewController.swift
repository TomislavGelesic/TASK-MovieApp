//
//  FavouriteMoviesViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 04/11/2020.
//

import UIKit
import SnapKit
import Combine

class FavouriteMoviesViewController: UIViewController {
    
    //MARK: Properties
    
    private var favouriteMoviesViewModel = FavouriteMoviesViewModel()
    
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
    deinit {
        for cancellable in disposeBag {
            cancellable.cancel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        setupPullToRefreshControl()
        
        setupViewModelSubscribers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favouriteMoviesViewModel.getNewScreenData()
    }
}

extension FavouriteMoviesViewController {
    
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
    
    private func setupViewModelSubscribers() {
        
        favouriteMoviesViewModel.updateScreenDataSubject
            .receive(on: RunLoop.main)
            .sink { [unowned self] (_) in
                self.tableView.reloadData()
                self.pullToRefreshControl.endRefreshing()
            }
            .store(in: &disposeBag)
    }
    
    private func setupPullToRefreshControl() {
        
        pullToRefreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
    }
    
    @objc func refreshMovies() {
        
        favouriteMoviesViewModel.getNewScreenData()
    }
}

extension FavouriteMoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favouriteMoviesViewModel.screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MovieTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.configure(with: favouriteMoviesViewModel.screenData[indexPath.row])
        
        cell.buttonTappedSubject
            .receive(on: RunLoop.main)
            .sink { [unowned self] (buttonType) in
                
                self.favouriteMoviesViewModel.switchPreference(at: indexPath, on: buttonType)
            }
            .store(in: &disposeBag)
        
        return cell
    }    
}





