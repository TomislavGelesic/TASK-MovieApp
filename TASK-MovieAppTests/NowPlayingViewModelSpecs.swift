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
        
        describe ("NowPlayingViewModel") {
            
            context("Can work with valid json mock model") {
                
                afterEach {
                    mock = nil
                    sut = nil
                }
                
                beforeEach {
                    mock = MockMovieRepositoryImpl()
                    sut = NowPlayingMoviesViewModel(repository: mock)
                }
                
                
                
                stub(mock) { stub in
                    
                    let subject = Future<MovieResponse, MovieNetworkError> { promise in
                        if let data = self.readLocalFile(forName: "NowPlayingJSONResponse") {
                            
                            promise(.success(data))
                        }
                        promise(.failure(MovieNetworkError.decodingError))
                    }.eraseToAnyPublisher()
                    
                    when().then{ return subject}
                    
                }
                
                
                //should stub before so there is data in 'sut.screenData'
                it("has correct amount of movies") {
                    
                    expect(sut.screenData.count).to(equal(20))
                }
                it("has correct data") {
                    expect(sut.screenData[1].id).to(equal(464052))
                }
                
                it("triggers alertSubject correctly") {
                    
                    
                }
                
            }
        }
    }
    
    private func readLocalFile(forName name: String) -> MovieResponse? {
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
