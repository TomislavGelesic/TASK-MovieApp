//
//  MovieListPresenter.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 20.11.2020..
//

import Foundation
import Alamofire
import Combine

protocol MovieListViewModelDelegate: class {
    
    func startSpinner()
    func stopSpinner()
    func showAlertView()
    func reloadCollectionView()
}

class MovieListViewModel {
    
    var disposeBag = Set<AnyCancellable>()
    
    var screenData = [RowItem<MovieRowType, Movie>]()
    
    var coreDataManager = CoreDataManager.sharedInstance
    
    var movieAPIManager = MovieAPIManager()
    
    weak var movieListViewModelDelegate: MovieListViewModelDelegate?
    
    //MARK: init
    
    init(delegate: MovieListViewModelDelegate) {
        
        movieListViewModelDelegate = delegate
    }
    
    deinit {
        for item in disposeBag {
            item.cancel()
        }
    }
}

extension MovieListViewModel {
    //MARK: Functions
    
    func refreshMovieList() {
        
        let url = "\(Constants.MOVIE_API.BASE)" + "\(Constants.MOVIE_API.GET_NOW_PLAYING)" + "\(Constants.MOVIE_API.KEY)"
        
        guard let getNowPlayingURL = URL(string: url) else { return }
        
        movieListViewModelDelegate?.startSpinner()
        
       movieAPIManager
        .fetch(url: getNowPlayingURL, as: MovieResponse.self)
            .sink(receiveCompletion: { completion in
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.movieListViewModelDelegate?.showAlertView()
                    print(error)
                    break
                    
                }
            }, receiveValue: { (MovieResponse) in
                
                var newMovies = [Movie]()
                
                for item in MovieResponse.results {
                    
                    if let movie = self.coreDataManager.getMovie(for: Int64(item.id)) {
                        
                        newMovies.append(movie)
                    }
                    else {
                        if let movie = self.coreDataManager.createMovie(from: item) {
                            
                            newMovies.append(movie)
                        }
                    }
                }
                
                self.screenData = self.createScreenData(from: newMovies)
                
                self.movieListViewModelDelegate?.stopSpinner()
                
                self.movieListViewModelDelegate?.reloadCollectionView()
                
            })
        .store(in: &disposeBag)
    }
    
    func createScreenData(from newMovies: [Movie]) -> [RowItem<MovieRowType, Movie>] {
        
        var newScreenData = [RowItem<MovieRowType, Movie>]()
        
        for movie in newMovies {
            newScreenData.append(RowItem<MovieRowType, Movie>(type: .movie, value: movie))
        }
        
        return newScreenData
    }
    
}

extension MovieListViewModel: ButtonTapped {
    
    func buttonTapped(for id: Int64, type: ButtonType) {
        
        switch type {
        
        case .favourite:
            
            coreDataManager.switchValue(on: id, for: .favourite)
            
        case .watched:
            
            coreDataManager.switchValue(on: id, for: .watched)
        }
        
        movieListViewModelDelegate?.reloadCollectionView()
    }
}
