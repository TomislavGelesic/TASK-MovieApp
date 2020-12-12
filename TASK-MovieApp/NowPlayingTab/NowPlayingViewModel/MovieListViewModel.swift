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
            .flatMap({ [unowned self] (screenData) -> AnyPublisher<[MovieRowItem], Never> in
                
                self.spinnerSubject.send(false)
                
                return Just(screenData).eraseToAnyPublisher()
            })
            .catch({ [unowned self] (error) -> AnyPublisher<[MovieRowItem], Never> in
                
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
        
        var newScreenData = [MovieRowItem]()
        
        for item in newMovieResponseItems {
            if let savedMovie = coreDataManager.getMovie(for: Int64(item.id)) {
                newScreenData.append(MovieRowItem(savedMovie))
            }
            else {
                newScreenData.append(MovieRowItem(item))
            }
        }
        
        return newScreenData
    }

    
    func switchValue(at indexPath: IndexPath, on type: ButtonType) {
        
        let movie = screenData[indexPath.row]
       
        switch type {
        case .favourite:
            movie.favourite = !movie.favourite
            print("F: \(movie.favourite)")
        case .watched:
            movie.watched = !movie.watched
            print("W: \(movie.watched)")
        }
        
        coreDataManager.updateMovie(movie)
        
        if !movie.favourite,
           !movie.watched {
            coreDataManager.deleteMovie(movie)
        }
        
    }

}

