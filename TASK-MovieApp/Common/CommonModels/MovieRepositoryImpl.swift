//
//  MovieRepositoryImpl.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 04.01.2021..
//

import UIKit
import Combine
import Alamofire

class MovieRepositoryImpl: MovieNowPlayingRepository {
    func fetchNowPlaying() -> AnyPublisher<Result<MovieResponse, AFError>, Never> {
        var url = String()
        url.append("\(Constants.MOVIE_API.BASE)")
        url.append("\(Constants.MOVIE_API.GET_NOW_PLAYING)")
        url.append("\(Constants.MOVIE_API.KEY)")
        return RestManager.requestObservable(url: url)
    }
}
