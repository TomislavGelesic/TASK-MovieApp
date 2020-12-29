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
    
    var movieDetailViewModel: MovieDetailViewModel
    
    private var disposeBag = Set<AnyCancellable>()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.register(ImageCellMovieDetail.self, forCellReuseIdentifier: ImageCellMovieDetail.reuseIdentifier)
        tableView.register(TitleCellMovieDetail.self, forCellReuseIdentifier: TitleCellMovieDetail.reuseIdentifier)
        tableView.register(GenreCellMovieDetail.self, forCellReuseIdentifier: GenreCellMovieDetail.reuseIdentifier)
        tableView.register(QuoteCellMovieDetail.self, forCellReuseIdentifier: QuoteCellMovieDetail.reuseIdentifier)
        tableView.register(DescriptionCellMovieDetail.self, forCellReuseIdentifier: DescriptionCellMovieDetail.reuseIdentifier)
        tableView.register(SimilarMoviesCellMovieDetail.self, forCellReuseIdentifier: SimilarMoviesCellMovieDetail.reuseIdentifier)
        return tableView
    }()
    
    
    //MARK: init
    
    init(viewModel: MovieDetailViewModel) {
        
        movieDetailViewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        setupTableView()
        
        setupSubscribers()
        
        movieDetailViewModel.getNewScreenDataSubject.send(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}

extension MovieDetailViewController {
    
    
    private func setupNavigationBar() {
        
        let backButton: UIBarButtonItem = {
            let buttonImage = UIImage(named: "arrow-left")?.withConfiguration(UIImage.SymbolConfiguration(scale: .large))
            let button = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(backButtonPressed))
            button.tintColor = .white
            return button
        }()
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        
        navigationController?.navigationBar.standardAppearance = coloredAppearance
        navigationController?.navigationBar.compactAppearance = coloredAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = coloredAppearance
        
        navigationItem.setLeftBarButton(backButton, animated: true)
        navigationController?.navigationBar.barStyle = .black
    }
    
    @objc func backButtonPressed() {
        
        navigationController?.popViewController(animated: true)
    }
    
    private func setupTableView() {
        
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
        view.addSubview(tableView)
        
        tableViewConstraints()
    }
    
    private func tableViewConstraints(){
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setupSubscribers() {
        
        movieDetailViewModel.initializeScreenData(with: self.movieDetailViewModel.getNewScreenDataSubject.eraseToAnyPublisher())
            .store(in: &disposeBag)
        
        
        movieDetailViewModel.initializeMoviePreferanceChangeSubject(with: self.movieDetailViewModel.moviePreferenceChangeSubject.eraseToAnyPublisher())
            .store(in: &disposeBag)
        
        
        movieDetailViewModel.spinnerSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] (isVisible) in
                
                isVisible ? self.showSpinner() : self.hideSpinner()
            })
            .store(in: &disposeBag)
        
        movieDetailViewModel.alertSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] (errorMessage) in
                self.showAPIFailedAlert(for: errorMessage) { [unowned self] in
                    self.backButtonPressed()
                }
            })
            .store(in: &disposeBag)
        
        movieDetailViewModel.refreshScreenDataSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] (position) in
                
                self.reloadTableView(at: position)
            })
            .store(in: &disposeBag)
    }
    
    private func reloadTableView(at position: RowUpdateState) {
        
        switch (position) {
        case .all:
            tableView.reloadData()
            break
        case .cellWith(let indexPath):
            tableView.reloadRows(at: [indexPath], with: .automatic)
            break
        }
    }
}


extension MovieDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movieDetailViewModel.screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = movieDetailViewModel.screenData[indexPath.row]
        
        switch item.type {
        
        case .imagePath:
            
            let cell: ImageCellMovieDetail = tableView.dequeueReusableCell(for: indexPath)
            
            guard let data = item.value as? (String, Bool, Bool) else { return UITableViewCell() }
            
            cell.configure(with: data.0, isFavourite: data.1, isWatched: data.2)
            
            cell.preferenceChanged = { [unowned self] (preferenceType, value) in
                
                self.movieDetailViewModel.moviePreferenceChangeSubject.send((preferenceType, value))
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




