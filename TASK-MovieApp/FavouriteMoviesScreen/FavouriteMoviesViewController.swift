//
//  FavouriteMoviesViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 04/11/2020.
//

import UIKit
import SnapKit

class FavouriteMoviesViewController: UIViewController {
    
    //MARK: Properties
    
    var screenData = [Movie]()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .darkGray
        return tableView
    }()
    
    //MARK: Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchScreenData()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        fetchScreenData()
        tableView.reloadData()
    }
}

extension FavouriteMoviesViewController {
    
    //MARK: Private Functions
    
    private func fetchScreenData() {
        
        if let data = CoreDataManager.sharedManager.getFavouriteMovies(){
            self.screenData = data
            return
        }
        print("Unable to create screen data")
    }
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.register(MovieCard.self, forCellReuseIdentifier: MovieCard.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 170
        
        setTableViewConstraints()
    }
    
    private func setTableViewConstraints() {
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(50)
            make.bottom.leading.trailing.equalTo(view)
        }
    }
}

extension FavouriteMoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MovieCard = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: screenData[indexPath.row])
        cell.movieCardDelegate = self
        return cell
    }
    
}

extension FavouriteMoviesViewController: MovieCardDelegate {
    
    func favouriteButtonTapped(cell: MovieCard) {
        
        guard let id = cell.movie?.id else { return }
        
        CoreDataManager.sharedManager.switchForId(type: .favourite, for: Int64(id))
        
        fetchScreenData()
        tableView.reloadData()
    }
    
    func watchedButtonTapped(cell: MovieCard) {
        
        guard let id = cell.movie?.id else { return }
        
        CoreDataManager.sharedManager.switchForId(type: .favourite, for: Int64(id))
        
        fetchScreenData()
        
        tableView.reloadData()
        
    }
}





