//
//  WatchedMoviesPresenter.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 24.11.2020..
//

import Foundation

protocol WatchedMoviesViewModelDelegate: class {
    
    func showAlertView()
    func reloadTableView()
}

class WatchedMoviesViewModel {
    
    var coreDataManager = CoreDataManager.sharedInstance
    
    weak var watchedMoviesViewModelDelegate: WatchedMoviesViewModelDelegate?
    
    var screenData = [RowItem<MovieRowType, Movie>]()
    
    //MARK: init
    
    init(delegate: WatchedMoviesViewModelDelegate) {
        
        watchedMoviesViewModelDelegate = delegate
    }
    
    
}

extension WatchedMoviesViewModel {
    //MARK: Functions
    
    func getNewScreenData() {
        
        if let savedData = coreDataManager.getMovies(.watched) {
            
            createScreenData(from: savedData)
            
            watchedMoviesViewModelDelegate?.reloadTableView()
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

extension WatchedMoviesViewModel: ButtonTapped {
    
    func buttonTapped(for id: Int64, type: ButtonType) {
        
        for movie in screenData {
            if movie.value.id == id {
                coreDataManager.saveOrUpdateMovie(movie.value)
            }
        }
        
        getNewScreenData()
    }
}

