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
            self.fetchScreenData()
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
        
        guard let urlGetNowPlaying = URL(string: "\(Constants.MOVIE_API.BASE)\(Constants.MOVIE_API.GET_NOW_PLAYING)\(Constants.MOVIE_API.KEY)") else { return }
        
        if spinnerOn { showSpinner() }
        
        
        Alamofire.request(urlGetNowPlaying)
            .validate()
            .response { (response) in
                if let error = response.error {
                    self.showAPIFailAlert()
                    print(error)
                }
                else if let data = response.data {
                    do{
                        let json = try JSONDecoder().decode(MovieList.self, from: data)
                        self.saveToCoreData(json.results)
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
    
    private func saveToCoreData(_ data: [MovieItem]) {
        
        for movie in data {
            CoreDataManager.sharedInstance.saveJSONModel(movie)
        }
    }
    
    private func fetchScreenData() {
        
        if let data = CoreDataManager.sharedInstance.getAllMovies(){
            self.screenData = data
        }
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
            self.fetchScreenData()
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
        
        let movieDetailScreen = MovieDetailViewController(for: Int(screenData[indexPath.row].id))
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
    
    func favouriteButtonTapped(cell: MovieListCollectionViewCell) {
        
        guard let id = cell.movie?.id else { return }
        
        CoreDataManager.sharedInstance.switchForId(type: .favourite, for: Int64(id))
        
        fetchScreenData()
        
        movieCollectionView.reloadData()
    }
    
    func watchedButtonTapped(cell: MovieListCollectionViewCell) {
        
        guard let id = cell.movie?.id else { return }
        
        CoreDataManager.sharedInstance.switchForId(type: .watched, for: Int64(id))
        
        fetchScreenData()
        
        movieCollectionView.reloadData()
    }
    
    
}


