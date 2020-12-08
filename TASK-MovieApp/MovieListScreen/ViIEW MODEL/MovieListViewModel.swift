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
    
    var screenDataSubject = PassthroughSubject<Bool, Never>() // signals to reload collection view
    
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    
    var alertSubject = PassthroughSubject<Bool, Never>()
    
    private var disposeBag = Set<AnyCancellable>()
    
    var coreDataManager = CoreDataManager.sharedInstance
    
    var movieAPIManager = MovieAPIManager()
    
    var buttonImageSubject = PassthroughSubject<ButtonType, Never>()
    
    
}

extension MovieListViewModel {
    //MARK: Functions
    
    func refreshMovieList() -> AnyCancellable{
        
        let url = "\(Constants.MOVIE_API.BASE)" + "\(Constants.MOVIE_API.GET_NOW_PLAYING)" + "\(Constants.MOVIE_API.KEY)"
        
        guard let getNowPlayingURL = URL(string: url) else { fatalError("refreshMovieList: getNowPlayingURL()") }
        
        spinnerSubject.send(true)
        
        return movieAPIManager
            .fetch(url: getNowPlayingURL, as: MovieResponse.self)
            .map(\.results)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [unowned self] (completion) in
                switch (completion) {
                case .finished:
                    self.spinnerSubject.send(false)
                    break
                case .failure(_):
                    self.spinnerSubject.send(false)
                    self.alertSubject.send(true)
                    break
                }
                
            }, receiveValue: { [unowned self] (results) in
                
                self.screenData = self.createScreenData(from: results)
                self.updateScreenDataWithCoreData()
                self.screenDataSubject.send(true) //actually does same for both bool values (T/F) but publisher must emit smomething to notify subscriber
            })
    }
    
    private func updateScreenDataWithCoreData() {
        for item in screenData {
            if let savedMovie = coreDataManager.getMovie(for: item.value.id) {
                item.value.favourite = savedMovie.favourite
                item.value.watched = savedMovie.watched
            }
        }
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
    
}

extension MovieListViewModel: ButtonTapped {
    
    func buttonTapped(for id: Int64, type: ButtonType) {
        
        coreDataManager.switchValue(on: id, for: type)
            
        updateScreenDataWithCoreData()
        
        screenDataSubject.send(true)
    }
}
