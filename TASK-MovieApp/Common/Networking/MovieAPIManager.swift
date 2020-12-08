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
    
    func fetch<T: Codable>(url: URL, as: T.Type, completion: @escaping (_ data: T?, _ error: String) -> () ) {
        
        Alamofire
            .request(url)
            .validate()
            .responseData { (response) in
                guard let data = response.data else {
                    completion(nil, "")
                    return
                }
                do {
                    let decodedObject: T = try JSONDecoder().decode(T.self, from: data)
                    completion(decodedObject, "")
                } catch {
                    completion(nil, error.localizedDescription)
                }
            }
    }
    
//    func fetch<T: Codable>(url: URL, as: T.Type) -> AnyPublisher<T, MovieAPIError> {
//
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .tryMap { response in
//                guard let httpURLResponse = response.response as? HTTPURLResponse,
//                      httpURLResponse.statusCode == 200
//                else { throw MovieAPIError.noDataError }
//                return response.data
//            }
//            .decode(type: T.self, decoder: JSONDecoder())
//            .mapError { MovieAPIError.other($0) }
//            .eraseToAnyPublisher()
//
//    }

    func fetch<T: Codable>(url: URL, as: T.Type) -> AnyPublisher<T, MovieAPIError> {

        var publisher: AnyPublisher<T, MovieAPIError>?
        
        Alamofire
            .request(url)
            .validate()
            .responseData { (response) in
                if let data = response.data {
                    do {
                        let data: T = try JSONDecoder().decode(T.self, from: data)
                        // what should i do here?? something is wrong . . .
                        publisher = CurrentValueSubject<T, MovieAPIError>(data).eraseToAnyPublisher()
                    } catch {
                        publisher = Fail<T, MovieAPIError>(error: MovieAPIError.decodingError).eraseToAnyPublisher()
                    }
                }
                publisher = Fail<T, MovieAPIError>(error: MovieAPIError.noDataError).eraseToAnyPublisher()
                
            }
        
        if let publisher = publisher {
            return publisher
        }
        return Fail<T, MovieAPIError>(error: MovieAPIError.functionalError).eraseToAnyPublisher()
        
    }
    
    
}
