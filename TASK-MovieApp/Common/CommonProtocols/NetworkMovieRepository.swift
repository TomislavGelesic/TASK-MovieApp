//
//  MovieRepository.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 04.01.2021..
//

import UIKit
import Combine

protocol NetworkMovieRepository {
    
    func getNetworkSubject<DATA_TYPE: Codable>(for url: URL) -> AnyPublisher<DATA_TYPE, MovieNetworkError> 

}
