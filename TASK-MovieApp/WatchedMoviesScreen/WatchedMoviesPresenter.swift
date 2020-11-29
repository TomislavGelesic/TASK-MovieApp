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
    
    var screenData = [Movie]()
    
    //MARK: init
    
    init(delegate: WatchedMoviesPresenterDelegate) {
        
        watchedMoviesPresenterDelegate = delegate
    }
    
    
}

extension WatchedMoviesPresenter {
    //MARK: Functions
    
    func getNewScreenData() {
        
        if let savedData = coreDataManager.getMovies(.watched) {
            screenData = savedData
            watchedMoviesPresenterDelegate?.reloadTableView()
        }
    }
    
}

extension WatchedMoviesPresenter: ButtonTapped {
    
    func buttonTapped(for id: Int64, type: ButtonType) {
        
        switch type {

        case .favourite:

            coreDataManager.switchValue(on: id, for: .favourite)
            
        case .watched:

            coreDataManager.switchValue(on: id, for: .watched)
        }
        
        getNewScreenData()
    }
}

