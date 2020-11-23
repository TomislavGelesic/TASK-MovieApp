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
    
    private var screenData = [Movie]()
    
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
        
        if let data = movieListPresenter?.getNewScreenData() {
            screenData = data
        }
        
        movieCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        movieCollectionView.reloadData()
    }
}

extension MovieListViewController {
    
    //MARK: Private Functions
    
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
        
        if let data = movieListPresenter?.getNewScreenData() {
            screenData = data
        }
        
        self.movieCollectionView.reloadData()
        
        self.pullToRefreshControl.endRefreshing()
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return screenData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MovieListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: screenData[indexPath.row])
        cell.cellButtonDelegate = self
        
        return cell
    }
    
}

extension MovieListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let movieDetailScreen = MovieDetailViewController(screenData[indexPath.row])
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
    func cellButtonTapped(on cell: MovieListCollectionViewCell, id: Int64, type: ButtonType) {
        movieListPresenter?.buttonTapped(on: id, type: type)
        
        switch type {
        case .favourite:
            if let value = movieListPresenter?.coreDataManager.getMovie(for: id)?.favourite{
                cell.setButtonImage(on: type, selected: value)
            }
        case .watched:
            
            if let value = movieListPresenter?.coreDataManager.getMovie(for: id)?.watched{
                cell.setButtonImage(on: type, selected: value)
            }
        }
        
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
    
    
    func buttonTapped(on id: Int64, type: ButtonType) {

        switch type {
        case .favourite:
            movieListPresenter?.buttonTapped(on: id, type: .favourite)

        case .watched:
            movieListPresenter?.buttonTapped(on: id, type: .watched)
        }

        if let data = movieListPresenter?.coreDataManager.getMovies(.all) {
            screenData = data
        }

        movieCollectionView.reloadData()
    }
    
}


