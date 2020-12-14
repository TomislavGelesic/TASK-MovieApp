
import Foundation
import Alamofire
import Combine

class MovieListViewModel {
    
    private var coreDataManager = CoreDataManager.sharedInstance
    
    private var movieAPIManager = MovieAPIManager()
    
    var screenData = [MovieRowItem]()
    
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    
    var alertSubject = PassthroughSubject<Void, Never>()
    
    var updateScreenDataSubject = PassthroughSubject<RowUpdateState, Never>()
}

extension MovieListViewModel {
    
    func initializeScreenData() -> AnyCancellable {
        
        let url = "\(Constants.MOVIE_API.BASE)" + "\(Constants.MOVIE_API.GET_NOW_PLAYING)" + "\(Constants.MOVIE_API.KEY)"
        
        guard let nowPlayingURLPath = URL(string: url) else { fatalError("refreshMovieList: getNowPlayingURL()") }
        
        spinnerSubject.send(true)
        
        return movieAPIManager
            .fetch(url: nowPlayingURLPath, as: MovieResponse.self)
            .map(\.results)
            .map { [unowned self] (movieResponseItems) -> [MovieRowItem] in
                return self.createScreenData(from: movieResponseItems)
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.global(qos: .background))
            .flatMap({ [unowned self] (screenData) -> AnyPublisher<[MovieRowItem], Never> in
                
                self.spinnerSubject.send(false)
                
                return Just(screenData).eraseToAnyPublisher()
            })
            .catch({ [unowned self] (error) -> AnyPublisher<[MovieRowItem], Never> in
                
                self.spinnerSubject.send(false)
                
                self.alertSubject.send()
                
                return Just([]).eraseToAnyPublisher()
            })
            .sink { [unowned self] (newScreenData) in
                
                self.screenData = newScreenData
                self.updateScreenDataSubject.send(.all)
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
        
        updateScreenDataSubject.send(.cellAt(indexPath))
        
        
    }

}

