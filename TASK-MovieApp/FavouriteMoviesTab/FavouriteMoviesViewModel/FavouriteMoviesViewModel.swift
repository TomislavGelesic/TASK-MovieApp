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
    
    var updateScreenDataSubject = PassthroughSubject<Void, Never>()
    
    var screenData = [MovieRowItem]()
    
}

extension FavouriteMoviesViewModel {
    
    func getNewScreenData() {
        
        if let savedData = coreDataManager.getMovies(.favourite) {
            
            screenData = savedData
            updateScreenDataSubject.send()
            
        }
    }
    
    func switchPreference(at indexPath: IndexPath, on type: ButtonType) {
       
        switch type {
        case .favourite:
            screenData[indexPath.row].favourite = !screenData[indexPath.row].favourite
            print("F: \(screenData[indexPath.row].favourite)")
            break
        case .watched:
            screenData[indexPath.row].watched = !screenData[indexPath.row].watched
            print("W: \(screenData[indexPath.row].watched)")
            break
        default:
        break
        }
        
        coreDataManager.updateMovie(screenData[indexPath.row])
        
        updateScreenDataSubject.send()
    }
}


