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
    
    var screenData = [MovieRowItem]()
    
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    
    var alertSubject = PassthroughSubject<Void, Never>()
    
    var updateScreenDataSubject = PassthroughSubject<RowUpdateState, Never>()
}

extension MovieListViewModel {
    //MARK: Functions
    
    func initializeScreenData() -> AnyCancellable {
        
        let url = "\(Constants.MOVIE_API.BASE)" + "\(Constants.MOVIE_API.GET_NOW_PLAYING)" + "\(Constants.MOVIE_API.KEY)"
        
        guard let nowPlayingURLPath = URL(string: url) else { fatalError("refreshMovieList: getNowPlayingURL()") }
        
        spinnerSubject.send(true)
        
        return movieAPIManager
            .fetch(url: nowPlayingURLPath, as: MovieResponse.self)
            .map(\.results)
            .map { [unowned self] (movieResponseItems) -> [MovieRowItem] in
                return self.createScreenData(from: movieResponseItems)
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .flatMap({ [unowned self] (screenData) -> AnyPublisher<[Movie], Never> in
                
                self.spinnerSubject.send(false)
                
                return Just(screenData).eraseToAnyPublisher()
            })
            .catch({ [unowned self] (error) -> AnyPublisher<[Movie], Never> in
                
                self.spinnerSubject.send(false)
                
                self.alertSubject.send()
                
                return Just([]).eraseToAnyPublisher()
            })
            .sink { [unowned self] (newScreenData) in
                
                self.screenData = newScreenData
                self.updateScreenDataSubject.send(.all)
            }
        
    }
    
    private func createScreenData(from newMovieResponseItems: [MovieResponseItem]) -> [MovieRowItem] {
        
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

    
    func updateScreenData(with buttonPreference: ButtonPreferance, at indexPath: IndexPath) {
        
        let movie = screenData[indexPath.row]
       
        switch buttonPreference.type {
        case .favourite:
            movie.favourite = buttonPreference.value
        case .watched:
            movie.watched = buttonPreference.value
        }
        
        coreDataManager.updateMovie(movie)
        
        if !movie.favourite,
           !movie.watched {
            coreDataManager.deleteMovie(movie)
        }
        
        updateScreenDataSubject.send(.cellAt(indexPath))
        
    }

}

