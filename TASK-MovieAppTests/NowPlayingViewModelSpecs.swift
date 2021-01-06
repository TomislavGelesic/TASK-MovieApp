//
//  NowPlayingViewModelSpecs.swift
//  TASK-MovieAppTests
//
//  Created by Tomislav Gelesic on 06.01.2021..
//

import Quick
import Nimble
import Combine

@testable import TASK_MovieApp

class NowPlayingViewModelSpecs: QuickSpec {
    
    override func spec() {
        
        var sut: NowPlayingMoviesViewModel!
        
        describe ("NowPlayingViewModel") {
            
            context("Can work with valid json mock model") {
                
                afterEach {
                    
                    sut = nil
                }
                
                beforeEach {
                    
                    sut = NowPlayingMoviesViewModel(repository: MockMovieRepositoryImpl())
                }
                
                
//                //HERE I RETURN JSON MOCK DATA
//
//                if let path = Bundle.main.path(forResource: "NowPlayingJSONResponse", ofType: "json") {
//                    do {
//                          let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                          let nowPlayingResponse = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//                          if let nowPlayingResponse = nowPlayingResponse as? Dictionary<String, AnyObject>,
//                             let movies = nowPlayingResponse["results"] as? [MovieResponseItem] {
//
//                             //do stuff
//                          }
//                      } catch {
//                           // handle error
//                      }
//                }
                
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
}
