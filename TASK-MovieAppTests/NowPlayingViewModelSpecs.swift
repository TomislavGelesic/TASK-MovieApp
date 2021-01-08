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
            
            beforeSuite {
                mock = MockMovieRepositoryImpl()
                
                sut = NowPlayingMoviesViewModel(repository: mock)
                
                sut.initializeScreenDataSubject(with: sut.getNewScreenDataSubject.eraseToAnyPublisher())
                    .store(in: &disposeBag)
            }
            
            guard let response = readLocalFile(forName: "NowPlayingJSONResponse") else { return }
            
            let expectedScreenData = sut.createScreenData(from: response.results)
            
            
            sut.alertSubject
                .sink { (errorMessage) in
                    alertCalled = true
                }
                .store(in: &disposeBag)
            
            
            
            //                stub(YOUR_MOCKED_REPOSITORY) { (mock) in
            //                                    let response: YOUR_RESPONSE_TYPE = LOAD_JSON_FILE
            //                                    let publisher = Just(response).eraseToAnyPublisher()
            //                                    when(mock).REPOSITORY_FUNCTION_WHICH_IS_BEEING_USED().thenReturn(publisher)
            //                                }
            
            it(" - triggers alertSubject correctly") {
                expect(alertCalled).to(equal(true))
            }
            
            it(" - has correct number of data") {
                
                expect(sut.screenData.count).to(equal(20))
            }
            
            it(" - has correct data") {
                expect(sut.screenData[1].id).to(equal(464052))
            }
            
            afterSuite {
                
                mock = nil
                
                sut = nil
    
                for cancellable in disposeBag {
                    cancellable.cancel()
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
