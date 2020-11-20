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
    
    private var movieListPresenter = MovieListPresenter()
    
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
        fetchData(spinnerOn: true) {
            self.movieCollectionView.reloadData()
            self.hideSpinner()
        }
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
        
        pullToRefreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    private func fetchData(spinnerOn: Bool, completion: @escaping () -> ()) {
        
        let url = Constants.MOVIE_API.BASE + Constants.MOVIE_API.GET_NOW_PLAYING + Constants.MOVIE_API.KEY
        
        guard let getNowPlayingURL = URL(string: url) else { return }
        
        if spinnerOn { showSpinner() }
        
        
        Alamofire.request(getNowPlayingURL)
            .validate()
            .response { (response) in
                if let error = response.error {
                    self.showAPIFailAlert()
                    print(error)
                }
                else if let data = response.data {
                    do {
                        let jsonData = try JSONDecoder().decode(MovieList.self, from: data)
                        
                        if let screenData = self.createScreenData(from: jsonData.results) {
                            self.screenData = screenData
                        }
                        
                        completion()
                    }
                    catch {
                        self.showAPIFailAlert()
                        print(error)
                    }
                }
                else {
                    self.showAPIFailAlert()
                }
            }
    }
    
    private func createScreenData(from movies: [MovieItem]) -> [Movie]? {
         
        let savedMovies = CoreDataManager.sharedInstance.getMovies(.all)
        
        var newMovies = [Movie]()
        
        for movieItem in movies {
            newMovies.append(CoreDataManager.sharedInstance.createMovie(movieItem))
        }
        
        if let savedMovies = savedMovies {
            let moviesToAdd = newMovies.filter { !savedMovies.contains($0) }
            saveNewMovies(moviesToAdd)
        }
        return CoreDataManager.sharedInstance.getMovies(.all)
    }
    
    func saveNewMovies(_ movies: [Movie]) {
        
        CoreDataManager.sharedInstance.saveContext()
    }
    
    private func showAPIFailAlert(){
        
        let alert = UIAlertController(title: "Error", message: "Ups, error occured!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        DispatchQueue.main.async {
            self.hideSpinner()
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func refreshNews() {
        
        print("Retrieving update on movies...")
        
        fetchData(spinnerOn: false) {
            self.movieCollectionView.reloadData()
            self.pullToRefreshControl.endRefreshing()
        }
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return screenData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MovieListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: screenData[indexPath.row])
        cell.movieListCollectionViewCellDelegate = self
        
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



extension MovieListViewController: MovieListCollectionViewCellDelegate {
    
    func favouriteButtonTapped(on id: Int64) {        
        
        CoreDataManager.sharedInstance.switchValueOnMovie(on: id, for: .favourite)
        
        if let screenData = CoreDataManager.sharedInstance.getMovies(.all) {
            self.screenData = screenData
        }
        
        movieCollectionView.reloadData()
    }
    
    func watchedButtonTapped(on id: Int64) {
        
        CoreDataManager.sharedInstance.switchValueOnMovie(on: id, for: .watched)
        
        if let screenData = CoreDataManager.sharedInstance.getMovies(.all) {
            self.screenData = screenData
        }
        
        movieCollectionView.reloadData()
    }
    
    
}


