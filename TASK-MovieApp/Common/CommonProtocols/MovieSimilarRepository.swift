//
//  MovieSimilarRepository.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 24.02.2021..
//


import Foundation
import Combine
import CoreLocation
import Alamofire

protocol MovieSimilarRepository: class {
    func fetchSimilars(for id: Int) -> AnyPublisher<Swift.Result<MovieResponse, AFError>, Never>
}
