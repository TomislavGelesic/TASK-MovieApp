//
//  MovieAPIManager.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 20.11.2020..
//

import Foundation
import Alamofire

class MovieAPIManager {
    
    func fetch<T: Codable> (url: URL, as: T.Type, completion: @escaping (_ data: T?, _ message: String ) -> Void ) {
        
        Alamofire.request(url)
            .validate()
            .responseData { (response) in
                guard let data = response.data else {
                    completion( nil, "")
                    return
                }
                
                do {
                    let jsonDecoded = try JSONDecoder().decode(T.self, from: data)
                    
                    completion(jsonDecoded, "")
                    
                } catch {
                    completion(nil, error.localizedDescription)
                }
            }
        
    }
}
