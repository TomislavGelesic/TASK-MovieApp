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
    
    private var movieListViewModel: MovieListViewModel?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        setupPullToRefreshControl()
        
        movieListViewModel = MovieListViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        movieListViewModel?.refreshMovieList()
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
        
        movieListViewModel?.refreshMovieList()
        
        self.pullToRefreshControl.endRefreshing()
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movieListViewModel?.screenData.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MovieListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        if let rowItem = movieListViewModel?.screenData[indexPath.row] {
            cell.configure(with: rowItem)
        }
        cell.buttonTapPublisher.sink { [unowned self] (action) in
            switch action {
            case .favouriteTapped(let id):
                movieListViewModel?.buttonTapped(for: id, type: .favourite)
            case .watchedTapped(let id):
                movieListViewModel?.buttonTapped(for: id, type: .favourite)
            }
        }.store(in: &disposeBag)
        
//        cell.cellButtonDelegate = self
        
        return cell
    }
    
}

extension MovieListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let rowItem = movieListViewModel?.screenData[indexPath.row] else { return }
        
        let movieDetailScreen = MovieDetailViewController(for: rowItem, delegate: self)
        
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

//extension MovieListViewController: CellButtonDelegate {
//
//    func cellButtonTapped(on cell: MovieListCollectionViewCell, type: ButtonType) {
//
//        guard let id = cell.movieID else { return }
//
//        movieListViewModel?.buttonTapped(for: id, type: type)
//
//    }
//}

extension MovieListViewController: MovieListViewModelDelegate {
    
    func startSpinner() {
        showSpinner()
    }
    
    func stopSpinner() {
        hideSpinner()
    }
    
    func showAlertView() {
        showAPIFailedAlert()
    }
    
    func reloadCollectionView() {
        
        movieCollectionView.reloadData()
    }
}

extension MovieListViewController: MovieDetailViewControllerDelegate {
    
    func reloadData() {
        
        movieCollectionView.reloadData()
    }
    
    
}


