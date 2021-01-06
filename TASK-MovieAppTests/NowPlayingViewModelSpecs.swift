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
        
        var sut = NowPlayingMoviesViewModel(repository: MockMovieRepositoryImpl())
        
        describe ("NowPlayingViewModel") {
            
            context("Works with valid json mock model") {
                
                
                
                
            }
        }
    }
}
