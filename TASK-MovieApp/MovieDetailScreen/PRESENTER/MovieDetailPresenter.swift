//
//  MovieDetailPresenter.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 20.11.2020..
//

import Foundation
import Alamofire

protocol MovieDetailPresenterDelegate: class {
    func startSpinner()
    func stopSpinner()
    func showAlertView()
    func reloadTableView()
}

class MovieDetailPresenter {
    
    weak var movieDetailPresenterDelegate: MovieDetailPresenterDelegate?
    
    var movieAPIManager = MovieAPIManager()
    
    var coreDataManager = CoreDataManager.sharedInstance
    
    var movieID: Int64
    
    var screenData = [RowItemDetailMovie<Any>]()
    
    init(delegate: MovieDetailPresenterDelegate, for id: Int64) {
        
        movieDetailPresenterDelegate = delegate
        
        movieID = id
    }
}

extension MovieDetailPresenter {
    //MARK: Functions
    
    func getDataValueForKey(_ type: RowItemDetailMovieTypes) -> Any? {
        
        for item in screenData {
            if item.type == type {
                return item.value
            }
        }
        return nil
    }
    
    func buttonTapped(id: Int64, type: ButtonType) {
        
        switch type {
        
        case .favourite:
            
            coreDataManager.updateMovieButtonState(on: id, for: .favourite)
            
        case .watched:
            
            coreDataManager.updateMovieButtonState(on: id, for: .watched)
        }
        
        movieDetailPresenterDelegate?.reloadTableView()
    }
    
    func getNewScreenData() -> [RowItemDetailMovie<Any>]? {
        
        var newScreenData = [RowItemDetailMovie<Any>]()
        
        let url = "\(Constants.MOVIE_API.BASE)\(Constants.MOVIE_API.GET_DETAILS_ON)\(Int(movieID))\(Constants.MOVIE_API.KEY)"
        
        guard let getMovieDetailsURL = URL(string: url) else { return nil}
        
        movieDetailPresenterDelegate?.startSpinner()
        
        movieAPIManager.fetch(url: getMovieDetailsURL, as: MovieDetails.self) { (data, message) in
            
            if let data = data {
                
                newScreenData = self.createScreenData(from: data)
                
            } else {
                
                self.movieDetailPresenterDelegate?.showAlertView()
                print(message)
            }
            
        }
        
        movieDetailPresenterDelegate?.stopSpinner()
        
        
        return newScreenData
    }
    
    private func createScreenData(from movieDetails: MovieDetails) -> [RowItemDetailMovie<Any>] {
        
        var newScreenData = [RowItemDetailMovie<Any>]()
        newScreenData.append(RowItemDetailMovie(type: .id, value: movieDetails.id))
        newScreenData.append(RowItemDetailMovie(type: .genre, value: genresToString(movieDetails.genres)))
        newScreenData.append(RowItemDetailMovie(type: .title, value: movieDetails.title))
        newScreenData.append(RowItemDetailMovie(type: .quote, value: movieDetails.tagline))
        
        var dictionary = Dictionary<String, Any>()
        
        dictionary["imagePath"] = movieDetails.poster_path ?? ""
        
        if let movie = coreDataManager.getMovie(for: movieID) {
            dictionary["favourite"] = movie.favourite
            dictionary["watched"] = movie.watched
        } else {
            dictionary["favourite"] = false
            dictionary["watched"] = false
        }
        
        newScreenData.append(RowItemDetailMovie<Any>(type: .imageWithButtons, value: dictionary))
        
        
        return newScreenData
    }
    
    private func genresToString (_ genres: [Genre]) -> String {
        
        var names = String()
        var genreIndex = 0
        
        while genreIndex < genres.count {
            if genreIndex + 1 >= genres.count {
                names.append(genres[genreIndex].name.lowercased())
            } else {
                if genreIndex == 0 {
                    names.append(genres[genreIndex].name.capitalized + ", ")
                } else {
                    names.append(genres[genreIndex].name.lowercased() + ", ")
                }
            }
            genreIndex += 1
        }
        
        return names
    }
    
    
}

