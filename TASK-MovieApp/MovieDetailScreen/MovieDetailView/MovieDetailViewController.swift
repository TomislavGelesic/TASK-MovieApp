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
    
    var updatePreferenceSubject = PassthroughSubject<ButtonType, Never>()
    
    var disposeBag = Set<AnyCancellable>()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        return tableView
    }()
    
    let favouriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "star_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(UIImage(named: "star_filled")?.withRenderingMode(.alwaysOriginal), for: .selected)
        return button
    }()
    
    let watchedButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "watched_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(UIImage(named: "watched_filled")?.withRenderingMode(.alwaysOriginal), for: .selected)
        return button
    }()
    
    //MARK: init
    
    init(for movie: MovieRowItem) {
        
        movieDetailViewModel = MovieDetailViewModel(id: movie.id)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        
        setupTableView()
        
        setupSubscribers()
        
        #warning("coerced unwrapping")
        movieDetailViewModel?.initializeScreenData(with: (self.movieDetailViewModel!.getNewScreenDataSubject.eraseToAnyPublisher()))
            .store(in: &disposeBag)
        
        if let exists = movieDetailViewModel?.getMoviePreferences(on: .favourite) {
            favouriteButton.isSelected = exists
            
        }
        setupNavigationBarButtons()
        
    }
}

extension MovieDetailViewController {
    //MARK: Functions
    
    private func setupViewController() {
        view.backgroundColor = .darkGray
    }
    
    private func setupNavigationBarButtons() {
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: favouriteButton), UIBarButtonItem(customView: watchedButton)]
        
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        
        watchedButton.addTarget(self, action: #selector(watchedButtonTapped), for: .touchUpInside)
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
    
    private func setupSubscribers() {
        
        movieDetailViewModel?.spinnerSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] (isVisible) in
                
                isVisible ? self.showSpinner() : self.hideSpinner()
            })
            .store(in: &disposeBag)
        
        movieDetailViewModel?.alertSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { _ in
                self.showAPIFailedAlert()
            })
            .store(in: &disposeBag)
        
        movieDetailViewModel?.setMoviePreferenceSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] (buttonType) in
                
                self.switchButtonImage(buttonType: buttonType)
            })
            .store(in: &disposeBag)
        
        movieDetailViewModel?.refreshScreenDataSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] (_) in
                    self.tableView.reloadData()
                    
            })
            .store(in: &disposeBag)
    }
    
    @objc func favouriteButtonTapped() {
        print("favourite tapped")
        movieDetailViewModel?.setMoviePreferenceSubject.send(.favourite)
    }
    
    @objc func watchedButtonTapped() {
        print("watched tapped")
        movieDetailViewModel?.setMoviePreferenceSubject.send(.watched)
    }
    
    private func switchButtonImage(buttonType: ButtonType){
        
        switch buttonType {
        case .favourite:
            favouriteButton.isSelected = !favouriteButton.isSelected
            break
        case .watched:
            watchedButton.isSelected = !watchedButton.isSelected
            break
        }
    }
}


extension MovieDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movieDetailViewModel?.screenData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let item = movieDetailViewModel?.screenData[indexPath.row] else { return UITableViewCell() }
        
        switch item.type {
        
        case .imagePath:
            
            let cell: MovieDetailImageCell = tableView.dequeueReusableCell(for: indexPath)
            
            if let imagePath = item.value as? String {
                cell.configure(with: imagePath)
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




