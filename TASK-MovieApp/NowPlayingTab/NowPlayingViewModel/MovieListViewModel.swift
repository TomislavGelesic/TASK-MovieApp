
import Foundation
import Alamofire
import Combine

class MovieListViewModel {
    
    private var coreDataManager = CoreDataManager.sharedInstance
    
    private var movieAPIManager = MovieAPIManager()
    
    var screenData = [MovieRowItem]()
    
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    
    var alertSubject = PassthroughSubject<Void, Never>()
    
    var refreshScreenDataSubject = PassthroughSubject<RowUpdateState, Never>()

    var setMoviePreferenceSubject = PassthroughSubject<(Int64, ButtonType, Bool), Never>()
    
    var getNewScreenDataSubject = PassthroughSubject<Void, Never>()
}

extension MovieListViewModel {
    
    func initializeScreenData(with subject: AnyPublisher<Void, Never>) -> AnyCancellable {
        
        let url = "\(Constants.MOVIE_API.BASE)" + "\(Constants.MOVIE_API.GET_NOW_PLAYING)" + "\(Constants.MOVIE_API.KEY)"
        
        guard let nowPlayingURLPath = URL(string: url) else { fatalError("refreshMovieList: getNowPlayingURL()") }
        
        spinnerSubject.send(true)
        
        return subject
            .receive(on: RunLoop.main)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .flatMap { [unowned self] (_) -> AnyPublisher<MovieResponse, MovieAPIError> in
                self.spinnerSubject.send(true)
                return self.movieAPIManager.fetch(url: nowPlayingURLPath, as: MovieResponse.self)
            }
            .receive(on: RunLoop.main)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .map { [unowned self] (movieResponse) -> [MovieRowItem] in
                return self.createScreenData(from: movieResponse.results)
            }
            .catch({ [unowned self] (error) -> AnyPublisher<[MovieRowItem], Never> in
                
                self.spinnerSubject.send(false)
                
                self.alertSubject.send()
                
                return Just([]).eraseToAnyPublisher()
            })
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (newScreenData) in
                
                self.screenData = newScreenData
                self.spinnerSubject.send(false)
                self.refreshScreenDataSubject.send(.all)
            }
        
        
    }
    
    private func createScreenData(from newMovieResponseItems: [MovieResponseItem]) -> [MovieRowItem] {
        
        var newScreenData = [MovieRowItem]()
        
        for item in newMovieResponseItems {
            if let savedMovie = coreDataManager.getMovie(for: Int64(item.id)) {
                newScreenData.append(MovieRowItem(savedMovie))
            }
            else {
                newScreenData.append(MovieRowItem(item))
            }
        }
        
        return newScreenData
    }
    
    #warning("Update this to observable stream implementation")
    
    #warning("Like this??")

    func updateAtIndex(for id: Int64, on buttonType: ButtonType, with value: Bool) -> IndexPath? {

        for (index,item) in screenData.enumerated() {

            if item.id == id {

                switch buttonType {
                case .favourite:
                    item.favourite = value
                case .watched:
                    item.watched = value
                }

                coreDataManager.updateMovie(item)
                
                return IndexPath(row: index, section: 0)
            }
        }
        
        return nil
    }
}

