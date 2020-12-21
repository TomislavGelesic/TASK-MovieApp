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
    
    var screenData = [RowItem<MovieDetailsRowType, Any>]()
    
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    
    var alertSubject = PassthroughSubject<String, Never>()
    
    var refreshScreenDataSubject = PassthroughSubject<RowUpdateState, Never>()

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
            .flatMap { [unowned self] (_) -> AnyPublisher<([RowItem<MovieDetailsRowType, Any>]), MovieAPIError> in
                
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
                        return (self.createScreenData(from: newMovieDetails, and: self.createCollectionViewData(from: newSimilarMovies.results)))
                    }
                    .eraseToAnyPublisher()
            }
            .catch({ [unowned self] (error) -> AnyPublisher<([RowItem<MovieDetailsRowType, Any>]), Never> in
                    
                    self.spinnerSubject.send(false)
                    switch (error) {
                    case .decodingError:
                        self.alertSubject.send("Decoder couldn't decode data from netwrok request.")
                        break
                        
                    case .noDataError:
                        self.alertSubject.send("There is no data for network request made.")
                        break
                        
                    case .other(let error):
                        self.alertSubject.send("Error: \(error.localizedDescription)")
                        break
                    }
                    
                    
                    return Just([]).eraseToAnyPublisher()
                })
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (newTableViewData) in
                
                self.screenData = newTableViewData
                
                self.spinnerSubject.send(false)
                
                self.refreshScreenDataSubject.send(.all)
            }
        
    }
    
    private func createScreenData(from movieDetails: MovieDetailsResponse, and newSimilarMovies: [MovieRowItem]) -> [RowItem<MovieDetailsRowType, Any>] {
        
        var newScreenData = [RowItem<MovieDetailsRowType, Any>]()
        
        if let posterPath = movieDetails.posterPath {
            
            let imagePath = Constants.MOVIE_API.IMAGE_BASE + Constants.MOVIE_API.IMAGE_SIZE + posterPath

            newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .imagePath, value: imagePath))
        }
        
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .title, value: movieDetails.title))
        
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .genre, value: movieDetails.genres.map{ $0.name }.joined(separator: ", ")))
        
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .quote, value: movieDetails.tagline))
        
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .description, value: movieDetails.overview))
        
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .similarMovies, value: newSimilarMovies))
        
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
