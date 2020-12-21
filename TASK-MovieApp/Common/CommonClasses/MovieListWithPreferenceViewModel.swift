
import Foundation
import Combine
class MovieListWithPreferenceViewModel {
    
    private var labelMovieViewModel: PreferenceType
    
    private var coreDataManager = CoreDataManager.sharedInstance
    
    var screenData = [MovieRowItem]()
    
    var refreshScreenDataSubject = PassthroughSubject<RowUpdateState, Never>()
    
    var movieReferenceSubject = PassthroughSubject<(Int64, PreferenceType, Bool), Never>()
    
    var getNewScreenDataSubject = PassthroughSubject<Void, Never>()
    
    init(preferenceType: PreferenceType) {
        
        labelMovieViewModel = preferenceType
    }
}

extension MovieListWithPreferenceViewModel {
    
    func initializeScreenDataSubject(with subject: AnyPublisher<Void, Never>) -> AnyCancellable {
        
        return subject
            .flatMap { [unowned self] (_) -> AnyPublisher<[MovieRowItem], Never> in
                
                switch (labelMovieViewModel) {
                case .favourite:
                    if let savedMovie = self.coreDataManager.getMovies(.favourite) {
                        return Just(savedMovie).eraseToAnyPublisher()
                    }
                    break
                    
                case .watched:
                    if let savedMovie = self.coreDataManager.getMovies(.watched) {
                        return Just(savedMovie).eraseToAnyPublisher()
                    }
                    break
                }
                return Just([]).eraseToAnyPublisher()
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (newScreenData) in
                self.screenData = newScreenData
                self.refreshScreenDataSubject.send(.all)
            }
    }
    
    func initializeMoviePreferenceSubject(with subject: AnyPublisher<(Int64, PreferenceType, Bool), Never>) -> AnyCancellable {
        
        return subject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (id, buttonType, value) in
                
                if let indexPath = self.updateMoviePreference(for: id, on: buttonType, with: value) {
                    
                    self.refreshScreenDataSubject.send(.cellWith(indexPath))
                }
            }
    }
    
    private func updateMoviePreference(for id: Int64, on preferenceType: PreferenceType, with value: Bool) -> IndexPath? {

        for (index,item) in screenData.enumerated() {

            if item.id == id {

                switch preferenceType {
                case .favourite:
                    item.favourite = value
                    break
                case .watched:
                    item.watched = value
                    break
                }
                print("saving button tap on \(preferenceType) with value \(value)")
                coreDataManager.updateMovie(item)
                
                return IndexPath(row: index, section: 0)
            }
        }
        
        return nil
    }
}
