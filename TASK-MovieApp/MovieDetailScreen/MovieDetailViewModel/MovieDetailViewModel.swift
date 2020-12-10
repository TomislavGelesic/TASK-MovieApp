//
//  MovieDetailPresenter.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 20.11.2020..
//

import Foundation
import Alamofire
import Combine

class MovieDetailViewModel {
    
    var movieAPIManager = MovieAPIManager()
    
    var coreDataManager = CoreDataManager.sharedInstance
    
    var movie: Movie
    
    var screenData = [RowItem<MovieDetailsRowType, Any>]()
    
    var screenDataSubject = PassthroughSubject<Bool, Never>() // signals to reload table view data
    
    private var disposeBag = Set<AnyCancellable>()
    
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    
    var alertSubject = PassthroughSubject<Bool, Never>()
    
    var buttonImageSubject = PassthroughSubject<ButtonType, Never>()
    
    init(movie: Movie) {
        self.movie = movie
    }
}

extension MovieDetailViewModel {
    //MARK: Functions
    
    func getNewScreenData() -> AnyCancellable {
        
        let url = "\(Constants.MOVIE_API.BASE)\(Constants.MOVIE_API.GET_DETAILS_ON)\(Int(movie.id))\(Constants.MOVIE_API.KEY)"
        
        guard let getMovieDetailsURL = URL(string: url) else { fatalError("getNewScreenData: DETAILS SCREEN") }
        
        return movieAPIManager
            .fetch(url: getMovieDetailsURL, as: MovieDetailsResponse.self)
            .receive(on: RunLoop.main)
            .sink { [unowned self] (completion) in
                
                self.spinnerSubject.send(false)
                
                switch (completion) {
                case .finished:
                    break
                case .failure(_):
                    self.alertSubject.send(true)
                    break
                }
            } receiveValue: { [unowned self] (newMovieDetails) in
                self.screenData = createScreenData(from: newMovieDetails)
                self.updateScreenDataWithCoreData()
                self.screenDataSubject.send(true)
            }
    }
    
    private func createScreenData(from movieDetails: MovieDetailsResponse) -> [RowItem<MovieDetailsRowType, Any>] {
        
        var newScreenData = [RowItem<MovieDetailsRowType, Any>]()
        
        if let posterPath = movieDetails.poster_path {
            let imagePath = Constants.MOVIE_API.IMAGE_BASE + Constants.MOVIE_API.IMAGE_SIZE + posterPath
            
            newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .imagePathWithButtonState, value: MovieDetailInfo(imagePath: imagePath, favourite: false, watched: false)))
        }
        
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .title, value: movieDetails.title))
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .genre, value: genresToString(movieDetails.genres)))
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .quote, value: movieDetails.tagline))
        newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .description, value: movieDetails.overview))
        
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
    
    func updateScreenDataWithCoreData() {
        
        if let savedMovie = coreDataManager.getMovie(for: movie.id) {
            for item in screenData {
                if var info = item.value as? MovieDetailInfo {
                    info.favourite = savedMovie.favourite
                    info.watched = savedMovie.watched
                }
            }
        }
    }
}

extension MovieDetailViewModel {
    
    func buttonTapped(type: ButtonType) {
        
        switch type {
        case .favourite:
            movie.favourite = !movie.favourite
        case .watched:
            movie.watched = !movie.watched
        }
        
        coreDataManager.saveOrUpdateMovie(movie)
       
        updateScreenDataWithCoreData()
        
        screenDataSubject.send(true)
    }
}
