//
//  MovieAPIManager.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 20.11.2020..
//

import Foundation
import Combine
import Alamofire



class MovieNetworkService {
    
    func fetch<T: Codable>(url: URL, as: T.Type) -> AnyPublisher<T, MovieNetworkError> {
        
        return Future<T, MovieNetworkError> { promise in
            Alamofire
                .request(url)
                .validate()
                .responseData { (response) in
                    
                    if let data = response.data {
                        
                        do {
                            let decoderJSON = JSONDecoder()
                            decoderJSON.keyDecodingStrategy = .convertFromSnakeCase
                            
                            let decodedData: T = try decoderJSON.decode(T.self, from: data)
                            
                            promise(.success(decodedData))
                            
                        } catch {
                            
                            promise(.failure(MovieNetworkError.decodingError))
                        }
                    }
                    else {
                        
                        promise(.failure(MovieNetworkError.noDataError))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
}
