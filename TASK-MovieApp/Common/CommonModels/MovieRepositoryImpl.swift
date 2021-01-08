//
//  MovieRepositoryImpl.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 04.01.2021..
//

import UIKit
import Combine

class MovieRepositoryImpl: NetworkMovieRepository {
    
    func getNetworkSubject<DATA_TYPE: Codable> (ofType type: DATA_TYPE.Type, for url: URL) -> AnyPublisher<DATA_TYPE, MovieNetworkError> {
        
        return MovieNetworkService().fetch(url: url, as: DATA_TYPE.self)
        
    }
}
