//
//  MovieFeedViewController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit
import SnapKit
import Alamofire

class MovieListViewController: UIViewController {
    
    //MARK: Properties
    
    private var movieListPresenter: MovieListPresenter?
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
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
        
        movieListPresenter = MovieListPresenter(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        movieListPresenter?.getNewScreenData()
    }
}

extension MovieListViewController {
    
    //MARK: Functions
    
    private func setupCollectionView() {
        
        view.addSubview(movieCollectionView)
        
        movieCollectionView.collectionViewLayout = flowLayout
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: MovieListCollectionViewCell.reuseIdentifier)
        
        movieCollectionViewConstraints()
    }
    
    private func movieCollectionViewConstraints () {
        
        movieCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setupPullToRefreshControl() {
        
        movieCollectionView.addSubview(pullToRefreshControl)
        
        pullToRefreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
    }
    
    @objc func refreshMovies() {
        
        movieListPresenter?.getNewScreenData()
        
        self.pullToRefreshControl.endRefreshing()
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movieListPresenter?.screenData.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MovieListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        if let movie = movieListPresenter?.screenData[indexPath.row] {
            cell.configure(with: movie)
        }
        
        cell.cellButtonDelegate = self
        
        return cell
    }
    
}

extension MovieListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let movie = movieListPresenter?.screenData[indexPath.row] else { return }
        
        let movieDetailScreen = MovieDetailViewController(for: movie, delegate: self)
        
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

extension MovieListViewController: CellButtonDelegate {
    
    func cellButtonTapped(on cell: MovieListCollectionViewCell, type: ButtonType) {
        
        guard let id = cell.movieID else { return }
        
        movieListPresenter?.buttonTapped(for: id, type: type)
        
    }
}

extension MovieListViewController: MovieListPresenterDelegate {
    
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


