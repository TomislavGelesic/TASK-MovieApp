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
}

class MovieDetailPresenter {
    
    weak var movieDetailPresenterDelegate: MovieDetailPresenterDelegate?
    
    var movieAPIManager = MovieAPIManager()
    
    var coreDataManager = CoreDataManager.sharedInstance
    
    var movieID: Int64
    
    init(delegate: MovieDetailPresenterDelegate, for id: Int64) {
        
        movieDetailPresenterDelegate = delegate
        
        movieID = id
    }
}

extension MovieDetailPresenter {
    //MARK: Functions
    
    func buttonTapped(id: Int64, type: ButtonType) {
        
        switch type {
        
        case .favourite:
            
            coreDataManager.switchValueOnMovie(on: id, for: .favourite)
            
        case .watched:
            
            coreDataManager.switchValueOnMovie(on: id, for: .watched)
        }
    }
    
    func getNewScreenData() -> DetailScreenData? {
        
        var returnValue = DetailScreenData(rowData: [MovieDetailScreenRowData<MovieDetailScreenRowTypes, String>](), watched: false, favourite: false, id: -1)
        
        let url = "\(Constants.MOVIE_API.BASE)\(Constants.MOVIE_API.GET_DETAILS_ON)\(Int(movieID))\(Constants.MOVIE_API.KEY)"
        
        guard let getMovieDetailsURL = URL(string: url) else { return nil}
        
        movieDetailPresenterDelegate?.startSpinner()
        
        movieAPIManager.fetch(url: getMovieDetailsURL, as: MovieDetails.self) { (data, message) in
            
            if let data = data {
                
                returnValue = self.createScreenData(from: data)
                
            } else {
                
                self.movieDetailPresenterDelegate?.showAlertView()
                print(message)
            }
            
        }
        
        movieDetailPresenterDelegate?.stopSpinner()
        
        
        return returnValue
    }
    
    private func createScreenData(from movieDetails: MovieDetails) -> DetailScreenData {
        
        let rowData = createRowData(from: movieDetails)
        
        if let movie = coreDataManager.getMovie(for: movieID) {
            
            return DetailScreenData(rowData: rowData, watched: movie.watched, favourite: movie.favourite, id: movieID)
        }
        
        return DetailScreenData(rowData: rowData, watched: false, favourite: false, id: movieID)
    }
    
    private func createRowData(from movieDetails: MovieDetails) -> [MovieDetailScreenRowData<MovieDetailScreenRowTypes, String>] {
        
        var rowData = [MovieDetailScreenRowData<MovieDetailScreenRowTypes, String>]()
        
        if let imagePath = movieDetails.poster_path {
            rowData.append(MovieDetailScreenRowData.init(type: .image, value: imagePath))
        }
        
        rowData.append(MovieDetailScreenRowData.init(type: .title, value: movieDetails.title))
        rowData.append(MovieDetailScreenRowData.init(type: .genre, value: genresToString(movieDetails.genres)))
        rowData.append(MovieDetailScreenRowData.init(type: .quote, value: movieDetails.tagline))
        rowData.append(MovieDetailScreenRowData.init(type: .description, value: movieDetails.overview))
        
        return rowData
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

