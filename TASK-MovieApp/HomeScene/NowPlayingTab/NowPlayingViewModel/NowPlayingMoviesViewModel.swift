
import Foundation
import Alamofire
import Combine

class NowPlayingMoviesViewModel {

    private var coreDataManager = CoreDataManager.sharedInstance

    var movieRepository: MovieRepositoryImpl
    
    var screenData = [MovieRowItem]()
    
    var spinnerSubject = PassthroughSubject<Bool, Never>()
    
    var alertSubject = PassthroughSubject<String, Never>()
    
    var refreshScreenDataSubject = PassthroughSubject<RowUpdateState, Never>()

    var moviePreferenceChangeSubject = PassthroughSubject<(Int64, PreferenceType, Bool), Never>()
    
    var getNewScreenDataSubject = PassthroughSubject<Void, Never>()
    
    var pullToRefreshControlSubject = PassthroughSubject<Bool, Never>()
    
    init(repository: MovieRepositoryImpl) {
        movieRepository = repository
    }
}

extension NowPlayingMoviesViewModel {
    
    func initializeScreenDataSubject(with subject: AnyPublisher<Void, Never>) -> AnyCancellable {
        return subject
            .flatMap { [unowned self] (_) -> AnyPublisher<[MovieRowItem], Never> in
                
                self.spinnerSubject.send(true)
                return movieRepository.fetchNowPlaying()
                    .flatMap { [unowned self] (result) -> AnyPublisher<[MovieRowItem], Never> in
                        switch result {
                        case .success(let response):
                            return Just(self.createScreenData(from: response.results)).eraseToAnyPublisher()
                        case .failure(let error):
                            print(error)
                            self.alertSubject.send("Can't get data from internet.")
                        }
                        return Just([MovieRowItem]()).eraseToAnyPublisher()
                    }.eraseToAnyPublisher()
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (newScreenData) in
                self.screenData = newScreenData
                self.pullToRefreshControlSubject.send(false)
                self.refreshScreenDataSubject.send(.all)
                self.spinnerSubject.send(false)
            }
    }
    
    func createScreenData(from newMovieResponseItems: [MovieResponseItem]) -> [MovieRowItem] {
        
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
    
    
    func updateMoviePreference(for id: Int64, on buttonType: PreferenceType, with value: Bool) -> IndexPath? {

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

