//
//  MovieRepositoryImpl.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 04.01.2021..
//

import UIKit
import Combine

class MovieRepositoryImpl {
    
    var networkService = MovieNetworkService()
}

extension MovieRepositoryImpl: NetworkMovieRepository {
    
    func getNetworkSubject<DATA_TYPE: Codable> (ofType type: DATA_TYPE.Type, for url: URL) -> AnyPublisher<DATA_TYPE, MovieNetworkError> {
        
        return networkService.fetch(url: url, as: DATA_TYPE.self)
        
    }
}
