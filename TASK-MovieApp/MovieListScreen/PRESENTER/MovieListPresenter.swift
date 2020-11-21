//
//  MovieListPresenter.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 20.11.2020..
//

import Foundation
import Alamofire


class MovieListPresenter {
    
    var coreDataManager = CoreDataManager.sharedInstance
    
    var movieAPIManager = MovieAPIManager()
    
    var movies = [Movie]()
    
    weak var movieListViewControllerDelegate: MovieListViewController?
    
    init(delegate: MovieListViewController) {
        movieListViewControllerDelegate = delegate
    }
    
    
}

extension MovieListPresenter {
    //MARK: Functions
    
    func buttonTapped(id: Int64, type: ButtonType) {
        
        switch type {
        
        case .favourite:
            
            coreDataManager.switchValueOnMovie(on: id, for: .favourite)
            
        case .watched:
            
            coreDataManager.switchValueOnMovie(on: id, for: .watched)
        }
    }
    
    func getNewScreenData() -> [Movie]? {
        
        let url = "\(Constants.MOVIE_API.BASE)" + "\(Constants.MOVIE_API.GET_NOW_PLAYING)" + "\(Constants.MOVIE_API.KEY)"
        print(url)
        guard let getNowPlayingURL = URL(string: url) else { return nil}
        
        movieListViewControllerDelegate?.showSpinner()
        
        movieAPIManager.fetch(url: getNowPlayingURL, as: MovieList.self) { (data, message) in
            
            if let data = data {

                var temp = [Movie]()
                
                for item in data.results {
                    
                    if let movie = self.coreDataManager.getMovie(for: Int64(item.id)) {
                        temp.append(movie)
                    }
                    else {
                        if let newMovie = self.coreDataManager.createMovie(from: item) {
                            temp.append(newMovie) 
                        }
                    }
                }
                
                self.movies = temp
            }
        }
            
        return movies
    }
    
    func updateScreenDataWithCoreData() -> [Movie] {
        
        if let movies = coreDataManager.getMovies(.all) {
            return movies
        }
        
        return [Movie]()
    }
}
extension MovieListPresenter {
    //MARK: Private functions
    
    
    private func saveNewMovies(_ movies: [Movie]) {
        
        coreDataManager.saveContext()
    }
    
    
    
}
