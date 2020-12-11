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
    
    private var coreDataManager = CoreDataManager.sharedInstance
    
    private var movieAPIManager = MovieAPIManager()
    
    var screenData = [Movie]()
    
    var screenDataSubject = PassthroughSubject<Void, Never>()
    
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    
    var alertSubject = PassthroughSubject<Void, Never>()
    
    var buttonTappedSubject = PassthroughSubject<Bool, Never>()
    
    
}

extension MovieListViewModel {
    //MARK: Functions
    
    func refreshMovieList() -> AnyPublisher<[Movie], Never> {
        
        let url = "\(Constants.MOVIE_API.BASE)" + "\(Constants.MOVIE_API.GET_NOW_PLAYING)" + "\(Constants.MOVIE_API.KEY)"
        
        guard let nowPlayingURLPath = URL(string: url) else { fatalError("refreshMovieList: getNowPlayingURL()") }
        
        spinnerSubject.send(true)
        
        return movieAPIManager
            .fetch(url: nowPlayingURLPath, as: MovieResponse.self)
            .map(\.results)
            .map { [unowned self] (movieResponseItems) -> [Movie] in
                return self.createScreenData(from: movieResponseItems)
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .flatMap({ (screenData) -> AnyPublisher<[Movie], Never> in
                return Just(screenData).eraseToAnyPublisher()
            })
            .catch({ [unowned self] (error) -> AnyPublisher<[Movie], Never> in
                self.alertSubject.send()
                return Just([]).eraseToAnyPublisher()
            })
            .eraseToAnyPublisher()
        
    }
    
    private func createScreenData(from newMovieResponseItems: [MovieResponseItem]) -> [Movie] {
        
        var newScreenData = [Movie]()
        
        for item in newMovieResponseItems {
            if let savedMovie = coreDataManager.getMovie(for: Int64(item.id)) {
                newScreenData.append(savedMovie)
            }
            else if let newMovie = coreDataManager.createMovie(from: item) {
                newScreenData.append(newMovie)
            }
        }
        
        return newScreenData
    }
}

extension MovieListViewModel: ButtonTapped {
    
    func buttonTapped(for id: Int64, type: ButtonType) {
        
        for movie in screenData {
            if movie.id == id {
                switch type {
                case .favourite:
                    movie.favourite = !movie.favourite
                case .watched:
                    movie.watched = !movie.watched
                }
                coreDataManager.saveOrUpdateMovie(movie)
                break
            }
        }
        
        buttonTappedSubject.send(true)
    }
}
