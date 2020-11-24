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
    
    func getNewScreenData() -> [Movie]? {
        
        var movies = [Movie]()
        
        let url = "\(Constants.MOVIE_API.BASE)" + "\(Constants.MOVIE_API.GET_NOW_PLAYING)" + "\(Constants.MOVIE_API.KEY)"
        
        guard let getNowPlayingURL = URL(string: url) else { return nil}
        
        movieListViewControllerDelegate?.startSpinner()
        
        movieAPIManager.fetch(url: getNowPlayingURL, as: MovieList.self) { (data, message) in
            
            if let data = data {
                
                var newMovies = [Movie]()
                
                for item in data.results {
                    
                    if let movie = self.coreDataManager.getMovie(for: Int64(item.id)) {
                        newMovies.append(movie)
                    }
                    else {
                        if let newMovie = self.coreDataManager.createMovie(from: item) {
                            newMovies.append(newMovie)
                        }
                    }
                }
                
                movies = newMovies
                
            } else {
                
                self.movieListViewControllerDelegate?.showAlertView()
                print("no data")
            }
        }
        movieListViewControllerDelegate?.stopSpinner()
        return movies
    }
    
}

extension MovieListPresenter: ButtonTapped {
    
    func buttonTapped(for id: Int64, type: ButtonType) {
        
        switch type {

        case .favourite:

            coreDataManager.switchValueOnMovie(on: id, for: .favourite)
            
        case .watched:

            coreDataManager.switchValueOnMovie(on: id, for: .watched)
        }
        
        movieListViewControllerDelegate?.reloadCollectionView()
//
//        switch type {
//        case .favourite:
//            if let value = coreDataManager.getMovie(for: id)?.favourite {
//                cell.setButtonImage(on: type, selected: value)
//            }
//        case .watched:
//
//            if let value = movieListPresenter?.coreDataManager.getMovie(for: id)?.watched{
//                cell.setButtonImage(on: type, selected: value)
//            }
//        }
    }
}
