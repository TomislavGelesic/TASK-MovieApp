
import Foundation
import Alamofire
import Combine

class NowPlayingMoviesViewModel {

    private var coreDataManager = CoreDataManager.sharedInstance

    var movieRepository = MovieRepositoryImpl()
    
    var screenData = [MovieRowItem]()
    
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    
    var alertSubject = PassthroughSubject<String, Never>()
    
    var refreshScreenDataSubject = PassthroughSubject<RowUpdateState, Never>()

    var moviePreferenceChangeSubject = PassthroughSubject<(Int64, PreferenceType, Bool), Never>()
    
    var getNewScreenDataSubject = PassthroughSubject<Void, Never>()
    
    var pullToRefreshControlSubject = PassthroughSubject<Bool, Never>()
}

extension NowPlayingMoviesViewModel {
    
    func initializeScreenDataSubject(with subject: AnyPublisher<Void, Never>) -> AnyCancellable {
        
        let url = "\(Constants.MOVIE_API.BASE)" + "\(Constants.MOVIE_API.GET_NOW_PLAYING)" + "\(Constants.MOVIE_API.KEY)"
        
        guard let nowPlayingURLPath = URL(string: url) else { fatalError("refreshMovieList: getNowPlayingURL()") }
        
        return subject
            .flatMap { [unowned self] (_) -> AnyPublisher<MovieResponse, MovieNetworkError> in
                
                self.spinnerSubject.send(true)
                
                return self.movieRepository.getNetworkSubject(for: nowPlayingURLPath)
            }
            .map { [unowned self] (movieResponse) -> [MovieRowItem] in
                
                return self.createScreenData(from: movieResponse.results)
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (completion) in
                
                switch (completion) {
                case .finished:
                    break
                    
                case .failure(let error):
                    
                    switch (error) {
                    case .decodingError:
                        self.alertSubject.send("Decoder couldn't decode data from netwrok request.")
                        break
                        
                    case .noDataError:
                        self.alertSubject.send("There is no data for network request made.")
                        break
                        
                    case .other(let error):
                        self.alertSubject.send("Error: \(error.localizedDescription)")
                        break
                    }
                    break
                }
            } receiveValue: { [unowned self] (newScreenData) in
                
                self.screenData = newScreenData
                self.pullToRefreshControlSubject.send(false)
                self.refreshScreenDataSubject.send(.all)
                self.spinnerSubject.send(false)
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
    
    func initializeMoviePreferenceSubject (with subject: AnyPublisher<(Int64, PreferenceType, Bool), Never>) -> AnyCancellable {
    
        return subject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] (id, buttonType, value) in
                
                if let indexPath = self.updateMoviePreference(for: id, on: buttonType, with: !value) {
                    
                    self.refreshScreenDataSubject.send(.cellWith(indexPath))
                }
            })
    }
    
    
    private func updateMoviePreference(for id: Int64, on buttonType: PreferenceType, with value: Bool) -> IndexPath? {

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

