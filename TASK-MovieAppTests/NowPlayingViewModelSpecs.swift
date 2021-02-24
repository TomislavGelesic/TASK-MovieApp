//
//  NowPlayingViewModelSpecs.swift
//  TASK-MovieAppTests
//
//  Created by Tomislav Gelesic on 06.01.2021..
//

@testable import TASK_MovieApp
import Quick
import Nimble
import Combine
import Cuckoo
import Alamofire


class NowPlayingViewModelSpecs: QuickSpec {
    
    override func spec() {
        
        var sut: NowPlayingMoviesViewModel!
        var mock: MockMovieRepositoryImpl!
        var disposeBag = Set<AnyCancellable>()
        var alertCalled: Bool!
        
        describe ("NowPlayingViewModel") {
            context("has") {
                beforeEach {
                    initialize()
                    stub(mock) { mock in
                        when(mock.fetchNowPlaying()).then { (_) -> AnyPublisher<Result<MovieResponse, AFError>, Never> in
                            if let data: MovieResponse = getResource("NowPlayingJSONResponse"){
                                return Just(Result<MovieResponse, AFError>.success(data)).eraseToAnyPublisher()
                            } else {
                                return Just(Result<MovieResponse, AFError>.success(MovieResponse.init(results: [MovieResponseItem]()))).eraseToAnyPublisher()
                            }
                        }
                    }
                    print("SETUP SETUP SETUP")
                }
                it("correct number of data") {
                    sut.getNewScreenDataSubject.send()
                    expect(sut.screenData.count).toEventually(equal(20))
                }
                
                it("correct data") {
                    let expected: Int64 = 508442
                    expect(sut.screenData[1].id).toEventually(equal(expected))
                }
            }
            
            context("triggers") {
                beforeEach {
                    initialize()
                }
                it("alertSubject correctly") {
                    sut.alertSubject.send("")
                    expect(alertCalled).toEventually(equal(true))
                }
            }
        }
        
        
        func initialize() {
            for cancellable in disposeBag {
                cancellable.cancel()
            }
            mock = MockMovieRepositoryImpl()
            sut = NowPlayingMoviesViewModel(repository: mock)
            alertCalled = false
            
            sut.initializeScreenDataSubject(with: sut.getNewScreenDataSubject.eraseToAnyPublisher())
                .store(in: &disposeBag)
            
            sut.alertSubject.sink { (message) in
                alertCalled = true
            }
            .store(in: &disposeBag)
        }
        
        func getResource<T: Codable>(_ fileName: String) -> T? {
            let bundle = Bundle.init(for: NowPlayingViewModelSpecs.self)
            guard let resourcePath = bundle.url(forResource: fileName, withExtension: "json"),
                  let data = try? Data(contentsOf: resourcePath),
                  let parsedData: T = SerializationManager.parseData(jsonData: data) else { return nil }
            return parsedData
        }
    }
}
