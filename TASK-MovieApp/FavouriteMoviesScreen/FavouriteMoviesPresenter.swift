//
//  FavouriteMoviesPresenter.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 24.11.2020..
//

import Foundation

protocol FavouriteMoviesPresenterDelegate: class {
    
    func showAlertView()
    func reloadTableView()
}

class FavouriteMoviesPresenter {
    
    var coreDataManager = CoreDataManager.sharedInstance
    
    weak var favouriteMoviesPresenterDelegate: FavouriteMoviesPresenterDelegate?
    
    var screenData = [Movie]()
    
    //MARK: init
    
    init(delegate: FavouriteMoviesPresenterDelegate) {
        
        favouriteMoviesPresenterDelegate = delegate
    }
}

extension FavouriteMoviesPresenter {
    //MARK: Functions
    
    func getNewScreenData() {
        
        if let savedData = coreDataManager.getMovies(.favourite) {
            
            screenData = savedData
            
            favouriteMoviesPresenterDelegate?.reloadTableView()
        }
    }    
}

extension FavouriteMoviesPresenter: ButtonTapped {
    
    func buttonTapped(for id: Int64, type: ButtonType) {
        
        switch type {

        case .favourite:

            coreDataManager.updateMovieButtonState(on: id, for: .favourite)
            
        case .watched:

            coreDataManager.updateMovieButtonState(on: id, for: .watched)
        }
        
        getNewScreenData()
    }
}


