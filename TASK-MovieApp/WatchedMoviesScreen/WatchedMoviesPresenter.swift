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
    
    var screenData = [RowItem<MovieRowType, Movie>]()
    
    //MARK: init
    
    init(delegate: WatchedMoviesPresenterDelegate) {
        
        watchedMoviesPresenterDelegate = delegate
    }
    
    
}

extension WatchedMoviesPresenter {
    //MARK: Functions
    
    func getNewScreenData() {
        
        if let savedData = coreDataManager.getMovies(.watched) {
            
            createScreenData(from: savedData)
            
            watchedMoviesPresenterDelegate?.reloadTableView()
        }
    }
    
    private func createScreenData(from coreData: [Movie]) {
        
        var newScreenData = [RowItem<MovieRowType, Movie>]()
        
        for movie in coreData {
            newScreenData.append(RowItem<MovieRowType, Movie>(type: .movie, value: movie))
        }
        
        self.screenData = newScreenData
        
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

