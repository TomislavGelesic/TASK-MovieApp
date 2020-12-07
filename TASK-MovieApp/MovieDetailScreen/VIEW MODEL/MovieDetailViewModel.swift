//
//  MovieDetailPresenter.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 20.11.2020..
//

import Foundation
import Alamofire
import Combine

protocol MovieDetailViewModelDelegate: class {
    
    func startSpinner()
    func stopSpinner()
    func showAlertView()
    func reloadTableView()
}

class MovieDetailViewModel {
    
    weak var movieDetailViewModelDelegate: MovieDetailViewModelDelegate?
    
    var disposeBag = Set<AnyCancellable>()
    
    var movieAPIManager = MovieAPIManager()
    
    var coreDataManager = CoreDataManager.sharedInstance
    
    var movieID: Int64
    
    var screenData = [RowItem<MovieDetailsRowType, Any>]()
    
    init(delegate: MovieDetailViewModelDelegate, for id: Int64) {
        
        movieDetailViewModelDelegate = delegate
        
        movieID = id
    }
}

extension MovieDetailViewModel {
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
            
            coreDataManager.switchValue(on: id, for: .favourite)
            
        case .watched:
            
            coreDataManager.switchValue(on: id, for: .watched)
        }
        
        getNewScreenData()
        
        movieDetailViewModelDelegate?.reloadTableView()
    }
    
    func getNewScreenData() {
        print("im here: MovieDetailPresenter -> getNewScreenData()")
        let url = "\(Constants.MOVIE_API.BASE)\(Constants.MOVIE_API.GET_DETAILS_ON)\(Int(movieID))\(Constants.MOVIE_API.KEY)"

        guard let getMovieDetailsURL = URL(string: url) else { return }

//        movieDetailViewModelDelegate?.startSpinner()
//
//        movieAPIManager
//        .fetch(url: getMovieDetailsURL, as: MovieDetailsResponse.self)
//            .sink(receiveCompletion: { completion in
//                
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    self.movieDetailViewModelDelegate?.showAlertView()
//                    print(error)
//                    break
//                    
//                }
//            }, receiveValue: { [unowned self] (MovieDetailsResponse) in
//                
//                self.screenData = self.createScreenData(from: MovieDetailsResponse)
//
//                self.movieDetailViewModelDelegate?.reloadTableView()
//                
//                self.movieDetailViewModelDelegate?.stopSpinner()
//            })
//            .store(in: &disposeBag)
    }
    
    private func createScreenData(from movieDetails: MovieDetailsResponse) -> [RowItem<MovieDetailsRowType, Any>] {
        
        var newScreenData = [RowItem<MovieDetailsRowType, Any>]()
        
        if let posterPath = movieDetails.poster_path {
            let imagePath = Constants.MOVIE_API.IMAGE_BASE + Constants.MOVIE_API.IMAGE_SIZE + posterPath
            
            if let movie = coreDataManager.getMovie(for: movieID) {
                let object = MovieDetailInfo(imagePath: imagePath, favourite: movie.favourite, watched: movie.watched)
                newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .imagePathWithButtonState, value: object))
            } else {
                let object = MovieDetailInfo(imagePath: imagePath, favourite: false, watched: false)
                newScreenData.append(RowItem<MovieDetailsRowType, Any>(type: .imagePathWithButtonState, value: object))
            }
            
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
    
    
}

