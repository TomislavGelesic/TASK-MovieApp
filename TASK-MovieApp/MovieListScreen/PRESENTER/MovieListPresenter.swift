//
//  MovieListPresenter.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 20.11.2020..
//

import Foundation
import Alamofire

protocol MovieListPresenterDelegate: class {
    
    func startSpinner()
    func stopSpinner()
    func showAlertView()
    func reloadCollectionView()
}

class MovieListPresenter {
    
    var screenData = [Movie]()
    
    var coreDataManager = CoreDataManager.sharedInstance
    
    var movieAPIManager = MovieAPIManager()
    
    weak var movieListViewControllerDelegate: MovieListPresenterDelegate?
    
    //MARK: init
    
    init(delegate: MovieListPresenterDelegate) {
        
        movieListViewControllerDelegate = delegate
    }
    
}

extension MovieListPresenter {
    //MARK: Functions
    
    func updateUI() {
        
        let url = "\(Constants.MOVIE_API.BASE)" + "\(Constants.MOVIE_API.GET_NOW_PLAYING)" + "\(Constants.MOVIE_API.KEY)"
        
        guard let getNowPlayingURL = URL(string: url) else { return }
        
        movieListViewControllerDelegate?.startSpinner()
        
        movieAPIManager.fetch(url: getNowPlayingURL, as: MovieListAPIModel.self) { (data, message) in
            
            if let data = data {
                
                var newMovies = [Movie]()
                
                for item in data.results {
                    
                    if let movie = self.coreDataManager.getMovie(for: Int64(item.id)) {
                        
                        newMovies.append(movie)
                    }
                    else {
                        if let movie = self.coreDataManager.createMovie(from: item) {
                            
                            newMovies.append(movie)
                        }
                    }
                }
                
                self.screenData = newMovies
                
                self.movieListViewControllerDelegate?.stopSpinner()
                
                self.movieListViewControllerDelegate?.reloadCollectionView()
                
            } else {
                
                self.movieListViewControllerDelegate?.showAlertView()
                print(message)
            }
        }
    }
    
}

extension MovieListPresenter: ButtonTapped {
    
    func buttonTapped(for id: Int64, type: ButtonType) {
        
        switch type {
        
        case .favourite:
            
            coreDataManager.switchValue(on: id, for: .favourite)
            
        case .watched:
            
            coreDataManager.switchValue(on: id, for: .watched)
        }
        
        movieListViewControllerDelegate?.reloadCollectionView()
    }
}
