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
    
    func getButtonStatus(_ type: ButtonType, for id: Int64) -> Bool? {
        
        if let movie = coreDataManager.getMovie(for: id) {
            switch type {
            case .favourite:
                return movie.favourite
            case .watched:
                return movie.watched
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
        
        updateScreenDataWithCoreData()
        
        movieDetailPresenterDelegate?.reloadTableView()
    }
    
    func getNewScreenData() {
        
        let url = "\(Constants.MOVIE_API.BASE)\(Constants.MOVIE_API.GET_DETAILS_ON)\(Int(movieID))\(Constants.MOVIE_API.KEY)"
        
        guard let getMovieDetailsURL = URL(string: url) else { return }
        
        movieDetailPresenterDelegate?.startSpinner()
        
        movieAPIManager.fetch(url: getMovieDetailsURL, as: MovieDetails.self) { (data, message) in
            
            if let data = data {
                
                self.screenData = self.createScreenData(from: data)
                
                self.movieDetailPresenterDelegate?.stopSpinner()
                self.movieDetailPresenterDelegate?.reloadTableView()
                
            } else {
                
                self.movieDetailPresenterDelegate?.showAlertView()
                print(message)
            }
        }
    }
    
    private func createScreenData(from movieDetails: MovieDetails) -> [RowItemDetailMovie<Any>] {
        
        var newScreenData = [RowItemDetailMovie<Any>]()
        
        var dictionary = Dictionary<String, Any>()
        
        let imagePath = movieDetails.poster_path ?? ""
        dictionary["imagePath"] = Constants.MOVIE_API.IMAGE_BASE + Constants.MOVIE_API.IMAGE_SIZE + imagePath
        
        if let movie = coreDataManager.getMovie(for: movieID) {
            dictionary["favourite"] = movie.favourite
            dictionary["watched"] = movie.watched
        } else {
            dictionary["favourite"] = false
            dictionary["watched"] = false
        }
        
        newScreenData.append(RowItemDetailMovie<Any>(type: .imageWithButtons, value: dictionary))
        
        newScreenData.append(RowItemDetailMovie(type: .title, value: movieDetails.title))
        newScreenData.append(RowItemDetailMovie(type: .genre, value: genresToString(movieDetails.genres)))
        newScreenData.append(RowItemDetailMovie(type: .quote, value: movieDetails.tagline))
        newScreenData.append(RowItemDetailMovie(type: .description, value: movieDetails.overview))
        
        return newScreenData
    }
    
    private func updateScreenDataWithCoreData() {
        
        for item in screenData {
            if item.type == .imageWithButtons,
               var data = item.value as? Dictionary<String, Any>,
               let movie = coreDataManager.getMovie(for: movieID) {
                
                data["favourite"] = movie.favourite
                data["watched"] = movie.watched
            }
        }
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

