//
//  MovieListPresenter.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 20.11.2020..
//

import Foundation
import Alamofire
import Combine

class MovieListViewModel {
    
    var screenData = [RowItem<MovieRowType, Movie>]()
    
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    
    var alertSubject = PassthroughSubject<Bool, Never>()
    
    var coreDataManager = CoreDataManager.sharedInstance
    
    var movieAPIManager = MovieAPIManager()
    
    var buttonTappedSubject = PassthroughSubject<Bool, Never>()
    
    
}

extension MovieListViewModel {
    //MARK: Functions
    
    func refreshMovieList() -> AnyPublisher<[RowItem<MovieRowType, Movie>], Never> {
        
        let url = "\(Constants.MOVIE_API.BASE)" + "\(Constants.MOVIE_API.GET_NOW_PLAYING)" + "\(Constants.MOVIE_API.KEY)"
        
        guard let getNowPlayingURL = URL(string: url) else { fatalError("refreshMovieList: getNowPlayingURL()") }
        
        spinnerSubject.send(true)
        
        
        return Just(getNowPlayingURL)
            .flatMap { [unowned self] (getNowPlayingURL) -> AnyPublisher<[RowItem<MovieRowType, Movie>], Never> in
                
                self.spinnerSubject.send(false)
                
                return self.movieAPIManager
                    .fetch(url: getNowPlayingURL, as: MovieResponse.self)
                    .receive(on: RunLoop.main)
                    .flatMap({ [unowned self] (MovieResponse) -> AnyPublisher<[RowItem<MovieRowType, Movie>], Never> in
                        
                        let data = self.createScreenData(from: MovieResponse.results)
                        
                        return Just(data).eraseToAnyPublisher()
                    })
                    .catch({ (_) in
//                        self.alertSubject.send(true)
                        return Just([]).eraseToAnyPublisher()
                    }).eraseToAnyPublisher()
                
            }.eraseToAnyPublisher()
        
        
    }
    
    private func createScreenData(from newMovieResponseItems: [MovieResponseItem]) -> [RowItem<MovieRowType, Movie>] {
        
        var newScreenData = [RowItem<MovieRowType, Movie>]()
        
        for item in newMovieResponseItems {
            
            if let newMovie = coreDataManager.createMovie(from: item) {
                newScreenData.append(RowItem<MovieRowType, Movie>(type: .movie, value: newMovie))
            }
        }
        
        return newScreenData
    }
    
    private func updateScreenDataWithCoreData() {
        
        for item in screenData {
            if let savedMovie = coreDataManager.getMovie(for: item.value.id) {
                item.value.favourite = savedMovie.favourite
                item.value.watched = savedMovie.watched
            }
        }
    }
}

extension MovieListViewModel: ButtonTapped {
    
    func buttonTapped(for id: Int64, type: ButtonType) {
        
        for item in screenData {
            if item.value.id == id {
                switch type {
                case .favourite:
                    item.value.favourite = !item.value.favourite
                case .watched:
                    item.value.watched = !item.value.watched
                }
                coreDataManager.saveOrUpdateMovie(item.value)
                break
            }
        }
            
        updateScreenDataWithCoreData()
                
        
        buttonTappedSubject.send(true)
    }
}
