//
//  MovieDetailPresenter.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 20.11.2020..
//

import Foundation
import Alamofire
import Combine

class MovieDetailViewModel {
    
    private var coreDataManager = CoreDataManager.sharedInstance
    
    private var movieAPIManager = MovieAPIManager()
    
    private var movieID: Int64
    
    var tableViewData = [RowItem<MovieDetailsRowType, Any>]()
    
    var collectionViewData = [MovieRowItem]()
    
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    
    var alertSubject = PassthroughSubject<Void, Never>()
    
    var refreshTableViewDataSubject = PassthroughSubject<RowUpdateState, Never>()

    var moviePreferenceSubject = PassthroughSubject<(ButtonType, Bool), Never>()
    
    var getNewScreenDataSubject = PassthroughSubject<Void, Never>()
    
    init(id: Int64) {
        self.movieID = id
    }
}

extension MovieDetailViewModel {
    
    func initializeScreenData(with subject: AnyPublisher<Void, Never>) -> AnyCancellable {
        
        let detailsMoviePath = "\(Constants.MOVIE_API.BASE)" + "\(Constants.MOVIE_API.GET_MOVIE_BY)" + "\(Int(movieID))" + "\(Constants.MOVIE_API.KEY)"
        let similarMoviesPath = "\(Constants.MOVIE_API.BASE)" + "\(Constants.MOVIE_API.GET_MOVIE_BY)" + "\(Int(movieID))" + "\(Constants.MOVIE_API.GET_SIMILAR)" + "\(Constants.MOVIE_API.KEY)"

        guard let detailsMovieURLPath = URL(string: detailsMoviePath) else { fatalError("ERROR getNewScreenData: DETAILS URL path") }
        
        guard let similarMoviesURLPath = URL(string: similarMoviesPath) else { fatalError("ERROR getNewScreenData: SIMILAR URL path") }
        
        return subject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .flatMap { [unowned self] (_) -> AnyPublisher<([RowItem<MovieDetailsRowType, Any>], [MovieRowItem]), MovieAPIError> in
                
                self.spinnerSubject.send(true)
                
                return Publishers
                    .CombineLatest( movieAPIManager.fetch(url: detailsMovieURLPath, as: MovieDetailsResponse.self), movieAPIManager.fetch(url: similarMoviesURLPath, as: MovieResponse.self))
                    .subscribe(on: DispatchQueue.global(qos: .background))
                    .receive(on: RunLoop.main)
                    .map { [unowned self] newMovieDetails, newSimilarMovies in
                        
                        if let shouldBeFavourite = getMoviePreference(on: .favourite) {
                            self.moviePreferenceSubject.send((.favourite, shouldBeFavourite))
                        }
                        if let shouldBeWatched = getMoviePreference(on: .watched) {
                            self.moviePreferenceSubject.send((.watched, shouldBeWatched))
                        }
                        return (self.createTableViewData(from: newMovieDetails), self.createCollectionViewData(from: newSimilarMovies.results))
                    }
                    .eraseToAnyPublisher()
            }
            .catch({ [unowned self] (error) -> AnyPublisher<([RowItem<MovieDetailsRowType, Any>], [MovieRowItem]), Never> in
                
                self.spinnerSubject.send(false)
                
                self.alertSubject.send()
                
                return Just(([], [])).eraseToAnyPublisher()
            })
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (newTableViewData, newCollectionViewData) in
                
                self.tableViewData = newTableViewData
                
                self.collectionViewData = newCollectionViewData
                
                self.spinnerSubject.send(false)
                
                self.refreshTableViewDataSubject.send(.all)
            }
        
    }
    
    private func createTableViewData(from movieDetails: MovieDetailsResponse) -> [RowItem<MovieDetailsRowType, Any>] {
        
        var newScreenData = [RowItem<MovieDetailsRowType, Any>]()
        
        if let posterPath = movieDetails.posterPath {
            
            let imagePath = Constants.MOVIE_API.IMAGE_BASE + Constants.MOVIE_API.IMAGE_SIZE + posterPath

            newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .imagePath, value: imagePath))
        }
        
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .title, value: movieDetails.title))
        
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .genre, value: movieDetails.genres.map{ $0.name }.joined(separator: ", ")))
        
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .quote, value: movieDetails.tagline))
        
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .description, value: movieDetails.overview))
        
        return newScreenData
    }
    
    private func createCollectionViewData(from newMovieResponseItems: [MovieResponseItem]) -> [MovieRowItem] {
        
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
    
    func initializeMoviePreferanceSubject (with subject: AnyPublisher<(ButtonType, Bool), Never>) -> AnyCancellable {
    
        return subject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (buttonType, value) in
                
                self.saveMoviePreferences(for: movieID, on: buttonType, value: value)
            }

    }
    
    private func saveMoviePreferences(for id: Int64, on buttonType: ButtonType, value: Bool ) {
        coreDataManager.saveMoviePreference(id: id, on: buttonType, value: value)
    }
    
    private func getMoviePreference(on buttonType: ButtonType) -> Bool? {

        if let savedMovie = coreDataManager.getMovie(for: movieID) {
            switch buttonType {
            case .favourite:
                return savedMovie.favourite
            case .watched:
                return savedMovie.watched
            }

        }
        return nil

    }
}
