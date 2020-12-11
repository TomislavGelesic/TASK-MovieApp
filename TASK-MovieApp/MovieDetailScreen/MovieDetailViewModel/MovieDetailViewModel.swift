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
    
    private var movieAPIManager = MovieAPIManager()
    
    private var movie: Movie
    
    var screenData = [RowItem<MovieDetailsRowType, Any>]()
    
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    
    var alertSubject = PassthroughSubject<Void, Never>()
    
    init(movie: Movie) {
        self.movie = movie
    }
}

extension MovieDetailViewModel {
    //MARK: Functions
    
    func fetchScreenData() -> AnyPublisher<[RowItem<MovieDetailsRowType, Any>], Never> {
        
        let url = "\(Constants.MOVIE_API.BASE)\(Constants.MOVIE_API.GET_DETAILS_ON)\(Int(movie.id))\(Constants.MOVIE_API.KEY)"

        guard let movieDetailURLPath = URL(string: url) else { fatalError("getNewScreenData: DETAILS SCREEN") }

        
        spinnerSubject.send(true)
        
        return movieAPIManager
            .fetch(url: movieDetailURLPath, as: MovieDetailsResponse.self)
            .map { [unowned self] (movieDetails) -> [RowItem<MovieDetailsRowType, Any>] in
                return self.createScreenData(from: movieDetails)
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .flatMap({ [unowned self] (screenData) -> AnyPublisher<[RowItem<MovieDetailsRowType, Any>], Never> in
                
                self.spinnerSubject.send(false)
                
                return Just(screenData).eraseToAnyPublisher()
            })
            .catch({ [unowned self] (error) -> AnyPublisher<[RowItem<MovieDetailsRowType, Any>], Never> in
                
                self.spinnerSubject.send(false)
                
                self.alertSubject.send()
                
                return Just([]).eraseToAnyPublisher()
            })
            .eraseToAnyPublisher()
        
    }
    
    private func createScreenData(from movieDetails: MovieDetailsResponse) -> [RowItem<MovieDetailsRowType, Any>] {
        
        var newScreenData = [RowItem<MovieDetailsRowType, Any>]()
        
        if let posterPath = movieDetails.posterPath {
            
            let imagePath = Constants.MOVIE_API.IMAGE_BASE + Constants.MOVIE_API.IMAGE_SIZE + posterPath
            
            newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .imagePathWithButtonState, value: MovieDetailInfo(imagePath: imagePath, favourite: movie.favourite, watched: movie.watched)))
        }
        
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .title, value: movieDetails.title))
        
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .genre, value: genresToString(movieDetails.genres)))
        
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .quote, value: movieDetails.tagline))
        
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .description, value: movieDetails.overview))
        
        return newScreenData
    }
    
    private func genresToString (_ genres: [Genre]) -> String {
        
        var names = String()
        var genreIndex = 0
        
        while genreIndex < genres.count {
            if genreIndex + 1 >= genres.count {
                names.append(genres[genreIndex].name.lowercased())
            } else {
                if genreIndex == 0 {
                    names.append(genres[genreIndex].name.capitalized + ", ")
                } else {
                    names.append(genres[genreIndex].name.lowercased() + ", ")
                }
            }
            genreIndex += 1
        }
        
        return names
    }
}
