import Foundation
import Alamofire
import Combine

public class RestManager {
    private static let manager: Alamofire.Session = {
        var configuration = URLSessionConfiguration.default
        let sessionManager = Session(configuration: configuration)
        return sessionManager
    }()
    
    static func requestObservable<T: Codable>(url: String) -> AnyPublisher<Swift.Result<T, AFError>, Never> {
        return RestManager.manager
            .request(url, encoding: URLEncoding.default)
            .validate()
            .publishDecodable(type: T.self)
            .result()
            .eraseToAnyPublisher()
    }
    
}

