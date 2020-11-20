//
//  MovieListPresenter.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 20.11.2020..
//

import Foundation
import Alamofire


class MovieListPresenter {
    
    var coreDataManager = CoreDataManager()
    
    private var controllerDelegate: MovieListViewController?
    
    init(delegate: MovieListViewController) {
        controllerDelegate = delegate
    }
    
    
}

extension MovieListPresenter {
    //MARK: Functions
    
    func buttonTapped(id: Int64, type: ButtonType) {
        
        switch type {
        
        case .favourite:
            
            coreDataManager.switchValueOnMovie(on: id, for: .favourite)
            
        case .watched:
            
            coreDataManager.switchValueOnMovie(on: id, for: .watched)
        }
    }
    
    func getNewScreenData() -> [Movie] {
        var returnValue = [Movie]()
        
        let url = Constants.MOVIE_API.BASE + Constants.MOVIE_API.GET_NOW_PLAYING + Constants.MOVIE_API.KEY
        
        guard let getNowPlayingURL = URL(string: url) else { return [Movie]()}
        
        controllerDelegate?.showSpinner()
        
        Alamofire.request(getNowPlayingURL)
            .validate()
            .response { (response) in
                if let error = response.error {
                    self.controllerDelegate?.showAPIFailAlert()
                    print(error)
                }
                else if let data = response.data {
                    do {
                        let jsonData = try JSONDecoder().decode(MovieList.self, from: data)
                        
                        if let screenData = self.createScreenData(from: jsonData.results) {
                            returnValue = screenData
                        }
                        
                    }
                    catch {
                        self.controllerDelegate?.showAPIFailAlert()
                        print(error)
                    }
                }
                else {
                    self.controllerDelegate?.showAPIFailAlert()
                }
            }
        
        return returnValue
    }
    
    func updateScreenDataWithCoreData() -> [Movie] {
        
        if let movies = coreDataManager.getMovies(.all) {
            return movies
        }
        
        return [Movie]()
    }
}
extension MovieListPresenter {
    //MARK: Private functions
    
        
    
    
    private func createScreenData(from movies: [MovieItem]) -> [Movie]? {
         
        let savedMovies = coreDataManager.getMovies(.all)
        
        var newMovies = [Movie]()
        
        for movieItem in movies {
            newMovies.append(coreDataManager.createMovie(movieItem))
        }
        
        if let savedMovies = savedMovies {
            
            let moviesToAdd = newMovies.filter { !savedMovies.contains($0) }
            
            saveNewMovies(moviesToAdd)
        }
        
        return coreDataManager.getMovies(.all)
    }
    
    private func saveNewMovies(_ movies: [Movie]) {
        
        coreDataManager.saveContext()
    }
    
    
    
}
