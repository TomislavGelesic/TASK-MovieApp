//
//  FavouriteMoviesPresenter.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 24.11.2020..
//

import UIKit
import SnapKit
import Combine

class FavouriteMoviesViewModel {
    
    private var coreDataManager = CoreDataManager.sharedInstance
    
    var screenData = [MovieRowItem]()
    
}

extension FavouriteMoviesViewModel {
    
    func getNewScreenData() -> AnyPublisher<[MovieRowItem], Never> {
        
        if let savedData = coreDataManager.getMovies(.favourite) {
            
            return Just(savedData).eraseToAnyPublisher()
        }
        return Just([]).eraseToAnyPublisher()
    }
}

