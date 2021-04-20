//
//  MovieDetailRepository.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 24.02.2021..
//

import Foundation
import Combine
import CoreLocation
import Alamofire

protocol MovieDetailRepository: class {
    func fetchDetails(for id: Int) -> AnyPublisher<Swift.Result<MovieDetailsResponse, AFError>, Never>
}
