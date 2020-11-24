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
    
    //MARK: init
    
    init(delegate: FavouriteMoviesPresenterDelegate) {
        
        favouriteMoviesPresenterDelegate = delegate
    }
}

extension FavouriteMoviesPresenter {
    //MARK: Functions
    
    func getNewScreenData() -> [Movie]? {
        
        if let screenData = coreDataManager.getMovies(.watched) {
            return screenData
        }
        
        favouriteMoviesPresenterDelegate?.showAlertView()
        return nil
    }
    
}

extension FavouriteMoviesPresenter: ButtonTapped {
    
    func buttonTapped(for id: Int64, type: ButtonType) {
        
        switch type {

        case .favourite:

            coreDataManager.switchValueOnMovie(on: id, for: .favourite)
            
        case .watched:

            coreDataManager.switchValueOnMovie(on: id, for: .watched)
        }
        
        favouriteMoviesPresenterDelegate?.reloadTableView()
    }
}


