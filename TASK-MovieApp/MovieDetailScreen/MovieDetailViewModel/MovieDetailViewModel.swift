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
    
    var alertSubject = PassthroughSubject<Void, Never>()
    
    var refreshScreenDataSubject = PassthroughSubject<Void, Never>()

    var moviePreferenceSubject = PassthroughSubject<(ButtonType, Bool), Never>()
    
    var getNewScreenDataSubject = PassthroughSubject<Void, Never>()
    
    init(id: Int64) {
        self.movieID = id
    }
}

extension MovieDetailViewModel {
    
    func initializeScreenData(with subject: AnyPublisher<Void, Never>) -> AnyCancellable {
        
        let url = "\(Constants.MOVIE_API.BASE)\(Constants.MOVIE_API.GET_DETAILS_ON)\(Int(movieID))\(Constants.MOVIE_API.KEY)"

        guard let movieDetailURLPath = URL(string: url) else { fatalError("getNewScreenData: DETAILS SCREEN") }
            
        spinnerSubject.send(true)
        
        return subject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .flatMap { [unowned self] (_) -> AnyPublisher<MovieDetailsResponse, MovieAPIError> in
                
                self.spinnerSubject.send(true)
                return movieAPIManager.fetch(url: movieDetailURLPath, as: MovieDetailsResponse.self)
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .map { [unowned self] (movieDetails) -> [RowItem<MovieDetailsRowType, Any>] in
                return self.createScreenData(from: movieDetails)
            }
            .catch({ [unowned self] (error) -> AnyPublisher<[RowItem<MovieDetailsRowType, Any>], Never> in
                
                self.spinnerSubject.send(false)
                
                self.alertSubject.send()
                
                return Just([]).eraseToAnyPublisher()
            })
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (newScreenData) in
                
                self.screenData = newScreenData
                
                self.spinnerSubject.send(false)
                
                self.refreshScreenDataSubject.send()
            }
        
    }
    
    private func createScreenData(from movieDetails: MovieDetailsResponse) -> [RowItem<MovieDetailsRowType, Any>] {
        
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
    
    func initializeMoviePreferanceSubject (with subject: AnyPublisher<(ButtonType, Bool), Never>) -> AnyCancellable {
    
        return subject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (buttonType, value) in
                
                self.saveMoviePreferences(for: movieID, on: buttonType, value: value)
                
                switch buttonType {
                case .favourite:
                    self.moviePreferenceSubject.send((.favourite, value))
                    break
                case .watched:
                    self.moviePreferenceSubject.send((.watched, value))
                    break
                }
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
