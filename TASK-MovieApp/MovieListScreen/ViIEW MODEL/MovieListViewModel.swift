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
    
    var screenData = [RowItem<MovieRowType, Movie>]()
    
    var screenDataPublisher = PassthroughSubject<Bool, Never>()
    
    var spinnerPublisher = PassthroughSubject<Bool, Never>()
    
    var alertPublisher = PassthroughSubject<Bool, Never>()
    
    private var disposeBag = Set<AnyCancellable>()
    
    var coreDataManager = CoreDataManager.sharedInstance
    
    var movieAPIManager = MovieAPIManager()
    
    weak var movieListViewModelDelegate: MovieListViewModelDelegate?
    
}

extension MovieListViewModel {
    //MARK: Functions
    
    func refreshMovieList() -> AnyCancellable{
        
        let url = "\(Constants.MOVIE_API.BASE)" + "\(Constants.MOVIE_API.GET_NOW_PLAYING)" + "\(Constants.MOVIE_API.KEY)"
        
        guard let getNowPlayingURL = URL(string: url) else { fatalError("refreshMovieList: getNowPlayingURL()") }
        
        spinnerPublisher.send(true)
        
        //returns subscription from publisher
        return movieAPIManager
            .fetch(url: getNowPlayingURL, as: MovieResponse.self)
            .map(\.results)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [unowned self] (completion) in
                switch (completion) {
                case .finished:
                    self.spinnerPublisher.send(false)
                    break
                case .failure(_):
                    self.spinnerPublisher.send(false)
                    self.alertPublisher.send(true)
                    break
                }
                
            }, receiveValue: { [unowned self] (results) in
                
                var newMovies = [Movie]()
                
                for item in results {
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
                self.screenDataPublisher.send(true) //actually does same for both bool values (T/F) but publisher must emit smomething to notify subscriber
            })
    }
    
    private func createScreenData(from newMovies: [Movie]) -> [RowItem<MovieRowType, Movie>] {
        
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
