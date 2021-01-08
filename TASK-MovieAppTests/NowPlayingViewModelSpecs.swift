//
//  NowPlayingViewModelSpecs.swift
//  TASK-MovieAppTests
//
//  Created by Tomislav Gelesic on 06.01.2021..
//

import Quick
import Nimble
import Combine
import Cuckoo

@testable import TASK_MovieApp

class NowPlayingViewModelSpecs: QuickSpec {
    
    override func spec() {
        
        var sut: NowPlayingMoviesViewModel!
        
        var mock: MockMovieRepositoryImpl!
        
        var disposeBag = Set<AnyCancellable>()
        
        var alertCalled = false
        
        describe ("NowPlayingViewModel") {
            
            mock = MockMovieRepositoryImpl()
            
            sut = NowPlayingMoviesViewModel(repository: mock)
            
            stub(mock) { mock in
                when(mock.getNetworkSubject(ofType: any(), for: any())).then { (_) -> AnyPublisher<MovieResponse, MovieNetworkError> in
                    return  Future<MovieResponse,MovieNetworkError> { [unowned self] promise in
                        if let response = self.readLocalFile(forName: "NowPlayingJSONResponse")  {
                            promise(.success(response))
                        }
                        alertCalled = true
                        promise(.failure(.decodingError))
                    }.eraseToAnyPublisher()
                }
                
                
                it(" - has correct number of data") {
                    
                    expect(sut.screenData.count).toEventually(equal(20))
                }
                
                it(" - has correct data") {
                    expect(sut.screenData[1].id).toEventually(equal(464052))
                }
            }
            
            sut.initializeScreenDataSubject(with: sut.getNewScreenDataSubject.eraseToAnyPublisher())
                .store(in: &disposeBag)
            
            sut.alertSubject.sink { (message) in
                alertCalled = true
            }
            .store(in: &disposeBag)
            
            
            sut.getNewScreenDataSubject.send()
            
            //  why oh why is error occuring??
            
            // i should stub with incorrect json to get call on alert to equal true
            it(" - triggers alertSubject correctly") {
                expect(alertCalled).to(equal(true))
            }
            

            
        }
    }
    
    func readLocalFile(forName name: String) -> MovieResponse? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                let decodedData = try JSONDecoder().decode(MovieResponse.self, from: jsonData)
                return decodedData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
}
