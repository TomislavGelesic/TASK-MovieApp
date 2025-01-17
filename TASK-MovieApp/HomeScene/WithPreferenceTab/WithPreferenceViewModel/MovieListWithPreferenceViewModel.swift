
import Foundation
import Combine
class MovieListWithPreferenceViewModel {
    
    var preference: PreferenceType
    
    private var coreDataManager = CoreDataManager.sharedInstance
    
    var screenData = [MovieRowItem]()
    
    var refreshScreenDataSubject = PassthroughSubject<RowUpdateState, Never>()
    
    var movieReferenceSubject = PassthroughSubject<(Int64, PreferenceType, Bool), Never>()
    
    var getNewScreenDataSubject = PassthroughSubject<Void, Never>()
    
    init(preferenceType: PreferenceType) {
        
        preference = preferenceType
    }
}

extension MovieListWithPreferenceViewModel {
    
    func initializeScreenDataSubject(with subject: AnyPublisher<Void, Never>) -> AnyCancellable {
        
        return subject
            .flatMap { [unowned self] (_) -> AnyPublisher<[MovieRowItem], Never> in
                
                switch (preference) {
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
                
                if let indexPath = self.updateMoviePreference(for: id, on: buttonType, with: !value) {
                    
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
                    
                    print("updateMoviePreference on movie \(id) set favourite to \(value)")
                    break
                case .watched:
                    item.watched = value
                    
                    print("updateMoviePreference on movie \(id) set watched to \(value)")
                    break
                }
                
                screenData[index] = item
                
                coreDataManager.updateMovie(item)
                
                return IndexPath(row: index, section: 0)
            }
        }
        
        return nil
    }
}
