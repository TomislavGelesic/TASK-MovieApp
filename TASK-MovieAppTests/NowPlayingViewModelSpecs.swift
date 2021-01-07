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
        
        var screenDataPublisher: AnyPublisher<MovieResponse, MovieNetworkError>?
        
        var disposeBag = Set<AnyCancellable>()
        
        var alertCalled = false
        
        describe ("NowPlayingViewModel") {
            
            context("Works: ") {
                
                beforeEach {
                    mock = MockMovieRepositoryImpl()
                    
                    sut = NowPlayingMoviesViewModel(repository: mock)
                    
                    screenDataPublisher = Future<MovieResponse, MovieNetworkError> { promise in
                        if let data = self.readLocalFile(forName: "NowPlayingJSONResponse") {

                            promise(.success(data))
                        }
                        promise(.failure(MovieNetworkError.decodingError))
                    }.eraseToAnyPublisher()
                }

                sut.alertSubject
                    .receive(on: RunLoop.main)
                    .subscribe(on: DispatchQueue.global(qos: .background))
                    .sink { (errorMessage) in
                        alertCalled = true
                    }
                    .store(in: &disposeBag)
                
                
                if let publisher = screenDataPublisher {
                    
                    publisher
                        .receive(on: RunLoop.main)
                        .subscribe(on: DispatchQueue.global(qos: .background))
                        .sink { (completion) in
                            switch (completion) {
                            case .finished:
                                break
                            case .failure(_):
                                sut.alertSubject.send("")
                                break
                            }
                        } receiveValue: { (movieResponse) in
                            sut.screenData = sut.createScreenData(from: movieResponse.results)
                            
                            it(" - has correct number of data") {
                                
                                expect(sut.screenData.count).to(equal(20))
                            }
                            it(" - has correct data") {
                                expect(sut.screenData[1].id).to(equal(464052))
                            }
                        }
                        .store(in: &disposeBag)
                }
                
                it(" - triggers alertSubject correctly") {
                    expect(alertCalled).to(equal(true))
                }
                
                afterEach {
                    
                    mock = nil
                    
                    sut = nil
                    
                    screenDataPublisher = nil
                    
                    for cancellable in disposeBag {
                        cancellable.cancel()
                    }
                }
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
