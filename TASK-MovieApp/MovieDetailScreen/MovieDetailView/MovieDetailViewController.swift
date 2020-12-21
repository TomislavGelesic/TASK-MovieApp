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
        tableView.backgroundColor = .darkGray
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
        
        setupNavigationBarButtons()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        movieDetailViewModel?.getNewScreenDataSubject.send()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        navigationController?.navigationBar.backgroundColor = .clear
        
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: favouriteButton), UIBarButtonItem(customView: watchedButton)]
        
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        
        watchedButton.addTarget(self, action: #selector(watchedButtonTapped), for: .touchUpInside)
    }
    
    private func setupTableView() {
        
        tableView.dataSource = self
        
        tableView.register(ImageCellMovieDetail.self, forCellReuseIdentifier: ImageCellMovieDetail.reuseIdentifier)
        tableView.register(TitleCellMovieDetail.self, forCellReuseIdentifier: TitleCellMovieDetail.reuseIdentifier)
        tableView.register(GenreCellMovieDetail.self, forCellReuseIdentifier: GenreCellMovieDetail.reuseIdentifier)
        tableView.register(QuoteCellMovieDetail.self, forCellReuseIdentifier: QuoteCellMovieDetail.reuseIdentifier)
        tableView.register(DescriptionCellMovieDetail.self, forCellReuseIdentifier: DescriptionCellMovieDetail.reuseIdentifier)
        tableView.register(SimilarMoviesCellMovieDetail.self, forCellReuseIdentifier: SimilarMoviesCellMovieDetail.reuseIdentifier)
        
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
        
        movieDetailViewModel?.initializeScreenData(with: self.movieDetailViewModel!.getNewScreenDataSubject.eraseToAnyPublisher())
            .store(in: &disposeBag)
        
        
        movieDetailViewModel?.initializeMoviePreferanceSubject(with: self.movieDetailViewModel!.moviePreferenceSubject.eraseToAnyPublisher())
            .store(in: &disposeBag)
        
        
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
            .sink(receiveValue: { [unowned self] (errorMessage) in
                self.showAPIFailedAlert(for: errorMessage)
            })
            .store(in: &disposeBag)
        
        movieDetailViewModel?.moviePreferenceSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] (buttonType, value) in
                
                self.switchButtonImage(buttonType: buttonType, value: value)
            })
            .store(in: &disposeBag)
        
        movieDetailViewModel?.refreshScreenDataSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] (rowUpdateState) in
                
                switch (rowUpdateState) {
                case .all:
                    self.tableView.reloadData()
                    break
                case .cellWith(_):
                    break
                }
            })
            .store(in: &disposeBag)
        
    }
    
    @objc func favouriteButtonTapped() {
        
        favouriteButton.isSelected = !favouriteButton.isSelected
        
        movieDetailViewModel?.moviePreferenceSubject.send((.favourite, favouriteButton.isSelected))
    }
    
    @objc func watchedButtonTapped() {
        
        watchedButton.isSelected = !watchedButton.isSelected
        
        movieDetailViewModel?.moviePreferenceSubject.send((.watched, watchedButton.isSelected))
    }
    
    private func switchButtonImage(buttonType: PreferenceType, value: Bool){
        
        switch buttonType {
        case .favourite:
            favouriteButton.isSelected = value
            break
        case .watched:
            watchedButton.isSelected = value
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
            
            let cell: ImageCellMovieDetail = tableView.dequeueReusableCell(for: indexPath)
            if let imagePath = item.value as? String {
                cell.configure(with: imagePath)
            }
            return cell
            
        case .title:
            
            let cell: TitleCellMovieDetail = tableView.dequeueReusableCell(for: indexPath)
            if let title = item.value as? String {
                cell.configure(with: title)
            }
            return cell
            
        case .genre:
            
            let cell: GenreCellMovieDetail = tableView.dequeueReusableCell(for: indexPath)
            if let genres = item.value as? String {
                cell.configure(with: genres)
            }
            return cell
            
        case .quote:
            
            let cell: QuoteCellMovieDetail = tableView.dequeueReusableCell(for: indexPath)
            if let quote = item.value as? String {
                cell.configure(with: quote)
            }
            return cell
            
        case .description:
            
            let cell: DescriptionCellMovieDetail = tableView.dequeueReusableCell(for: indexPath)
            if let description = item.value as? String {
                cell.configure(with: description)
            }
            return cell
            
        case .similarMovies:
            
            let cell: SimilarMoviesCellMovieDetail = tableView.dequeueReusableCell(for: indexPath)
            if let similarMovies = item.value as? [MovieRowItem] {
                cell.configure(with: similarMovies)
            }
            return cell
            
        }
    }
}




