//
//  FavouriteMoviesPresenter.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 24.11.2020..
//

import Foundation

protocol FavouriteMoviesViewModelDelegate: class {
    
    func showAlertView()
    func reloadTableView()
}

class FavouriteMoviesViewModel {
    
    var coreDataManager = CoreDataManager.sharedInstance
    
    weak var favouriteMoviesViewModelDelegate: FavouriteMoviesViewModelDelegate?
    
    var screenData = [RowItem<MovieRowType, Movie>]()
    
    //MARK: init
    
    init(delegate: FavouriteMoviesViewModelDelegate) {
        
        favouriteMoviesViewModelDelegate = delegate
    }
}

extension FavouriteMoviesViewModel {
    //MARK: Functions
    
    func getNewScreenData() {
        
        if let savedData = coreDataManager.getMovies(.favourite) {
            
            createScreenData(from: savedData)
            
            favouriteMoviesViewModelDelegate?.reloadTableView()
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

extension FavouriteMoviesViewModel: ButtonTapped {
    
    func buttonTapped(for id: Int64, type: ButtonType) {
        
        for movie in screenData {
            if movie.value.id == id {
                coreDataManager.saveOrUpdateMovie(movie.value)
            }
        }
        
        getNewScreenData()
    }
}


