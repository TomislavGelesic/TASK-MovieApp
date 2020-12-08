//
//  MovieAPIManager.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 20.11.2020..
//

import Foundation
import Combine
import Alamofire



class MovieAPIManager {
    
//    func fetch<T: Codable>(url: URL, as: T.Type, completion: @escaping (_ data: T?, _ error: String) -> () ) {
//
//        Alamofire
//            .request(url)
//            .validate()
//            .responseData { (response) in
//                guard let data = response.data else {
//                    completion(nil, "")
//                    return
//                }
//                do {
//                    let decodedObject: T = try JSONDecoder().decode(T.self, from: data)
//                    completion(decodedObject, "")
//                } catch {
//                    completion(nil, error.localizedDescription)
//                }
//            }
//    }
    
    func fetch<T: Codable>(url: URL, as: T.Type) -> AnyPublisher<T, MovieAPIError> {
        
        return Future<T, MovieAPIError> { promise in
            Alamofire
                .request(url)
                .validate()
                .responseData { (response) in
                    if let data = response.data {
                        do {
                            let decodedData: T = try JSONDecoder().decode(T.self, from: data)
                            promise(.success(decodedData))
                        } catch {
                            promise(.failure(MovieAPIError.decodingError))
                        }
                    }
                    else {
                        promise(.failure(MovieAPIError.noDataError))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
}
