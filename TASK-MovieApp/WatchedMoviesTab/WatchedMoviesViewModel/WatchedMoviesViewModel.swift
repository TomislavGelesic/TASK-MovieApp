//
//  WatchedMoviesPresenter.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 24.11.2020..
//

import Foundation
import Combine

class WatchedMoviesViewModel {
    
    private var coreDataManager = CoreDataManager.sharedInstance
    
    var screenData = [MovieRowItem]()
    
}

extension WatchedMoviesViewModel {
    
    func getNewScreenData() -> AnyPublisher<[MovieRowItem], Never> {
        
        if let savedData = coreDataManager.getMovies(.watched) {
            
            return Just(savedData).eraseToAnyPublisher()
        }
        return Just([]).eraseToAnyPublisher()
    }
}

