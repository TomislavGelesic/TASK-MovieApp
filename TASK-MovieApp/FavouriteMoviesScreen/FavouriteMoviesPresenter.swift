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
    
    var screenData = [RowItem<MovieRowType, Movie>]()
    
    //MARK: init
    
    init(delegate: FavouriteMoviesPresenterDelegate) {
        
        favouriteMoviesPresenterDelegate = delegate
    }
}

extension FavouriteMoviesPresenter {
    //MARK: Functions
    
    func getNewScreenData() {
        
        if let savedData = coreDataManager.getMovies(.favourite) {
            
            createScreenData(from: savedData)
            
            favouriteMoviesPresenterDelegate?.reloadTableView()
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

extension FavouriteMoviesPresenter: ButtonTapped {
    
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


