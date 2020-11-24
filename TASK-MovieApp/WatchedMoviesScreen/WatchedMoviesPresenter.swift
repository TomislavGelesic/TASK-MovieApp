//
//  WatchedMoviesPresenter.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 24.11.2020..
//

import Foundation

protocol WatchedMoviesPresenterDelegate: class {
    
    func showAlertView()
    func reloadTableView()
}

class WatchedMoviesPresenter {
    
    var coreDataManager = CoreDataManager.sharedInstance
    
    weak var watchedMoviesPresenterDelegate: WatchedMoviesPresenterDelegate?
    
    //MARK: init
    
    init(delegate: WatchedMoviesPresenterDelegate) {
        
        watchedMoviesPresenterDelegate = delegate
    }
    
    
}

extension WatchedMoviesPresenter {
    //MARK: Functions
    
    func getNewScreenData() -> [Movie]? {
        
        if let screenData = coreDataManager.getMovies(.watched) {
            return screenData
        }
        
        watchedMoviesPresenterDelegate?.showAlertView()
        return nil
    }
    
}

extension WatchedMoviesPresenter: ButtonTapped {
    
    func buttonTapped(for id: Int64, type: ButtonType) {
        
        switch type {

        case .favourite:

            coreDataManager.switchValueOnMovie(on: id, for: .favourite)
            
        case .watched:

            coreDataManager.switchValueOnMovie(on: id, for: .watched)
        }
        
        watchedMoviesPresenterDelegate?.reloadTableView()
    }
}

