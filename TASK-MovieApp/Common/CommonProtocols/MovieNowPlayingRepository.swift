//
//  MovieNowPlayingRepository.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 24.02.2021..
//

import Foundation
import Combine
import CoreLocation
import Alamofire

protocol MovieNowPlayingRepository: class {
    func fetchNowPlaying() -> AnyPublisher<Swift.Result<MovieResponse, AFError>, Never>
}
