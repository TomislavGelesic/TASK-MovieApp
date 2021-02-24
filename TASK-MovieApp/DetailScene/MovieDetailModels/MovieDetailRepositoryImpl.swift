//
//  MovieDetailRepositoryImpl.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 24.02.2021..
//

import Foundation
import Combine
import Alamofire

class MovieDetailRepositoryImpl: MovieDetailRepository, MovieSimilarRepository {
    
    func fetchSimilars(for id: Int) -> AnyPublisher<Swift.Result<MovieResponse, AFError>, Never> {
        let url = "\(Constants.MOVIE_API.BASE)" +
            "\(Constants.MOVIE_API.GET_MOVIE_BY)" +
            "\(id)" +
            "\(Constants.MOVIE_API.GET_SIMILAR)" +
            "\(Constants.MOVIE_API.KEY)"
        return RestManager.requestObservable(url: url)
    }
    
    
    func fetchDetails(for id: Int) -> AnyPublisher<Swift.Result<MovieDetailsResponse, AFError>, Never> {
        let url = "\(Constants.MOVIE_API.BASE)" +
            "\(Constants.MOVIE_API.GET_MOVIE_BY)" +
            "\(id)" +
            "\(Constants.MOVIE_API.KEY)"
        return RestManager.requestObservable(url: url)
    }
    
}
