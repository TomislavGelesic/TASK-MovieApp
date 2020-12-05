//
//  MovieAPIManager.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 20.11.2020..
//

import Foundation
import Combine

enum NetworkErrors {
    case URLResponse(String)
}

class MovieAPIManager {
    
    func fetch<T: Codable> (url: URL, as: T.Type) -> AnyPublisher<T, Error> {
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({ (data, response) -> Data in
                return data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
