//
//  MovieDetailsViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var rowData: [RowData]
    var movie: Movie
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    //MARK: init
    init(movie: Movie) {
        self.movie = movie
        self.rowData = [RowData]()
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
    }
}

extension MovieDetailViewController {
    //MARK: Private Functions
    
    private func setupViewController() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
    }
}

extension MovieDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = rowData[indexPath.row]
        
        switch item.type {
        case .image:
            let cell: MovieDetailImageCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case .title:
            let cell: MovieDetailTitleCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case .genre:
            let cell: MovieDetailImageCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case .quote:
            let cell: MovieDetailTitleCell = tableView.dequeueReusableCell(for: indexPath)
            
            return cell
        case .description:
            let cell: MovieDetailImageCell = tableView.dequeueReusableCell(for: indexPath)
            
            return cell
        }
    }
    
    
    
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(MovieDetailImageCell.self, forCellReuseIdentifier: "MovieDetailImageCell")
        tableView.register(MovieDetailTitleCell.self, forCellReuseIdentifier: "MovieDetailTitleCell")
        tableView.register(MovieDetailGenreCell.self, forCellReuseIdentifier: "MovieDetailGenreCell")
        tableView.register(MovieDetailQuoteCell.self, forCellReuseIdentifier: "SingleNewsImageCell")
        tableView.register(MovieDetailDescriptionCell.self, forCellReuseIdentifier: "MovieDetailDescriptionCell")
        tableView.rowHeight = UITableView.automaticDimension
        
        tableViewConstraints()
    }
    
    private func tableViewConstraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}
