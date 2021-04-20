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
    
    private var coreDataService = CoreDataManager.sharedInstance

    private var movieRepository: MovieDetailRepositoryImpl

    private var movie: MovieRowItem
    
    var screenData = [RowItem<MovieDetailsRowType, Any>]()
    
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    
    var alertSubject = PassthroughSubject<String, Never>()
    
    var refreshScreenDataSubject = PassthroughSubject<RowUpdateState, Never>()

    var moviePreferenceChangeSubject = PassthroughSubject<(PreferenceType, Bool), Never>()
    
    var getNewScreenDataSubject = CurrentValueSubject<Bool, Never>(true) //race condition - need to use currentValueSubject
    
    init(for movie: MovieRowItem, repository: MovieDetailRepositoryImpl) {
        self.movie = movie
        movieRepository = repository
    }
}

extension MovieDetailViewModel {
    
    func initializeScreenData(with subject: AnyPublisher<Bool, Never>) -> AnyCancellable {
        
        return subject
            .flatMap { [unowned self] (_) -> AnyPublisher<([RowItem<MovieDetailsRowType, Any>]), Never> in
                self.spinnerSubject.send(true)
                let detailPublisher: AnyPublisher<Swift.Result<MovieDetailsResponse, AFError>, Never> = movieRepository.fetchDetails(for: Int(movie.id))
                let similarsPublisher: AnyPublisher<Swift.Result<MovieResponse, AFError>, Never> = movieRepository.fetchSimilars(for: Int(movie.id))
                return Publishers.Zip(detailPublisher, similarsPublisher)
                    .flatMap { [unowned self] (detailsResult, similarsResult) -> AnyPublisher<([RowItem<MovieDetailsRowType, Any>]), Never> in
                        var detailResponse: MovieDetailsResponse = .init()
                        var similarsResponse: [MovieResponseItem] = .init()
                        switch detailsResult {
                        case .success(let response):
                            detailResponse = response
                        case .failure(_):
                            self.alertSubject.send("Can't get all data from internet.")
                        }
                        switch similarsResult {
                        case .success(let response):
                            similarsResponse = response.results
                        case .failure(_):
                            self.alertSubject.send("Can't get all data from internet.")
                        }
                        return Just(self.createScreenData(from: detailResponse,
                                                          and: similarsResponse)).eraseToAnyPublisher()
                    }.eraseToAnyPublisher()
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (newTableViewData) in
                self.screenData = newTableViewData
                self.refreshScreenDataSubject.send(.all)
                self.spinnerSubject.send(false)
            }
        
    }
    
    private func createScreenData(from movieDetails: MovieDetailsResponse, and newSimilarMovies: [MovieResponseItem]) -> [RowItem<MovieDetailsRowType, Any>] {
        
        var newScreenData = [RowItem<MovieDetailsRowType, Any>]()
        
        if let posterPath = movieDetails.posterPath {
            let imagePath = Constants.MOVIE_API.IMAGE_BASE + Constants.MOVIE_API.IMAGE_SIZE + posterPath
            let favouriteStatus = getMoviePreference(on: .favourite) ?? false
            let watchedStatus = getMoviePreference(on: .watched) ?? false
            newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .imagePath,
                                                                   value: (imagePath, favouriteStatus, watchedStatus)))
        }
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .title,
                                                               value: movieDetails.title))
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .genre,
                                                               value: movieDetails.genres.map{ $0.name }.joined(separator: ", ")))
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .quote,
                                                               value: movieDetails.tagline))
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .description,
                                                               value: movieDetails.overview))
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .similarMovies,
                                                               value: createSimiralMoviesScreenData(from: newSimilarMovies)))
        return newScreenData
    }
    
    private func createSimiralMoviesScreenData(from newMovieResponseItems: [MovieResponseItem]) -> [MovieRowItem] {
        
        var newScreenData = [MovieRowItem]()
        
        for item in newMovieResponseItems {
            if let savedMovie = coreDataService.getMovie(for: Int64(item.id)) {
                newScreenData.append(MovieRowItem(savedMovie))
            }
            else {
                newScreenData.append(MovieRowItem(item))
            }
        }
        
        return newScreenData
    }
    
    func initializeMoviePreferanceChangeSubject (with subject: AnyPublisher<(PreferenceType, Bool), Never>) -> AnyCancellable {
    
        return subject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (buttonType, value) in
                
                if let indexPath = self.updateMoviePreference(for: movie.id, on: buttonType, with: !value) {
                    
                    self.refreshScreenDataSubject.send(.cellWith(indexPath))
                    
                }
            }
    }
    
    
    private func updateMoviePreference(for id: Int64, on buttonType: PreferenceType, with value: Bool) -> IndexPath? {

        for (index,item) in screenData.enumerated() {

            if item.type == .imagePath {

                guard var data = item.value as? (String, Bool, Bool) else { return nil }
                
                switch buttonType {
                case .favourite:
                    data.1 = value
                    movie.favourite = value
                    break
                case .watched:
                    data.2 = value
                    movie.watched = value
                    break
                }
                
                screenData[index].value = data
                
                coreDataService.updateMovie(movie)
                
                return IndexPath(row: index, section: 0)
            }
        }
        
        return nil
    }
    
    func getMoviePreference(on buttonType: PreferenceType) -> Bool? {

        if let savedMovie = coreDataService.getMovie(for: movie.id) {
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
