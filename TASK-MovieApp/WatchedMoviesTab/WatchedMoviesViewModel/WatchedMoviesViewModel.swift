//
//  WatchedMoviesPresenter.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 24.11.2020..
//

import Foundation
import Combine
#warning("Implemented screen initialization as observable stream")
class WatchedMoviesViewModel {
    
    private var coreDataManager = CoreDataManager.sharedInstance
    
    var updateScreenDataSubject = PassthroughSubject<Void, Never>()
    
    var screenData = [MovieRowItem]()
    
}

extension WatchedMoviesViewModel {
    
    func getNewScreenData() {
        
        if let savedData = coreDataManager.getMovies(.watched) {
            
            screenData = savedData
            updateScreenDataSubject.send()
            
        }
    }
    #warning("Update this to observable stream implementation and updated the logic so this feature works as intended")
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
