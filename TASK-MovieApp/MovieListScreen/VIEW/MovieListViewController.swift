//
//  MovieFeedViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit
import SnapKit
import Alamofire
import Combine

class MovieListViewController: UIViewController {
    
    //MARK: Properties
    
    private var movieListViewModel = MovieListViewModel()
    
    private var disposeBag = Set<AnyCancellable>()
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }()
    
    private let movieCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .darkGray
        return collectionView
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
        
        setupCollectionView()
        
        setupPullToRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //subscriber to spinnerPublisher saved in disposeBag
        movieListViewModel.spinnerPublisher.sink(receiveValue: { (value) in
            switch (value) {
            case true:
                self.showSpinner()
            case false:
                self.hideSpinner()
            }
        }).store(in: &disposeBag)
        
        movieListViewModel.refreshMovieList().store(in: &disposeBag)
        
        movieListViewModel.screenDataPublisher.sink { (value) in
            self.reloadData()
        }.store(in: &disposeBag)
        
        movieListViewModel.alertPublisher.sink { (value) in
            self.showAPIFailedAlert()
        }.store(in: &disposeBag)
    }
    
}

extension MovieListViewController {
    
    //MARK: Functions
    
    private func setupCollectionView() {
        
        movieCollectionView.collectionViewLayout = flowLayout
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: MovieListCollectionViewCell.reuseIdentifier)
        
        view.addSubview(movieCollectionView)
        
        movieCollectionViewConstraints()
    }
    
    private func movieCollectionViewConstraints () {
        
        movieCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setupPullToRefreshControl() {
        
        pullToRefreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        
        movieCollectionView.addSubview(pullToRefreshControl)
    }
    
    @objc func refreshMovies() {
        
        movieListViewModel.refreshMovieList().store(in: &disposeBag)
        
        self.pullToRefreshControl.endRefreshing()
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movieListViewModel.screenData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MovieListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
    
        cell.configure(with: movieListViewModel.screenData[indexPath.row])
        
        cell.buttonTapPublisher.sink { [unowned self] (action) in
            switch action {
            case .favouriteTapped(let id):
                movieListViewModel.buttonTapped(for: id, type: .favourite)
            case .watchedTapped(let id):
                movieListViewModel.buttonTapped(for: id, type: .favourite)
            }
        }.store(in: &disposeBag)
        
        return cell
    }
    
}

extension MovieListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let movieDetailScreen = MovieDetailViewController(for: movieListViewModel.screenData[indexPath.row], delegate: self)
        
        movieDetailScreen.modalPresentationStyle = .fullScreen
        
        self.present(movieDetailScreen, animated: true, completion: nil)
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        let cellWidth = (movieCollectionView.frame.width - 30) / 2
        let cellHeight = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension MovieListViewController: MovieDetailViewControllerDelegate {
    
    func reloadData() {
        
        movieCollectionView.reloadData()
    }
}


