//
//  WatchedMoviesPresenter.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 24.11.2020..
//

import Foundation
import Combine
class WatchedMoviesViewModel {
    
    private var coreDataManager = CoreDataManager.sharedInstance
    
    var screenData = [MovieRowItem]()
    
    var refreshScreenDataSubject = PassthroughSubject<RowUpdateState, Never>()
    
    var movieReferenceSubject = PassthroughSubject<(Int64, ButtonType, Bool), Never>()
    
   var getNewScreenDataSubject = PassthroughSubject<Void, Never>()
    
}

extension WatchedMoviesViewModel {
    
    func initializeScreenDataSubject(with subject: AnyPublisher<Void, Never>) -> AnyCancellable {
        
        return subject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .flatMap { [unowned self] (_) -> AnyPublisher<[MovieRowItem], Never> in
                if let savedMovie = self.coreDataManager.getMovies(.watched) {
                    return Just(savedMovie).eraseToAnyPublisher()
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
    
    func initializeMoviePreferenceSubject(with subject: AnyPublisher<(Int64, ButtonType, Bool), Never>) -> AnyCancellable {
        
        return subject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .flatMap { [unowned self] (id, buttonType, value) -> AnyPublisher<IndexPath?, Never> in
                
                if let indexPath = self.updateMoviePreference(for: id, on: buttonType, with: value) {
                    return Just(indexPath).eraseToAnyPublisher()
                }
                return Just(nil).eraseToAnyPublisher()
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (indexPath) in
                if let indexPath = indexPath {
                    self.refreshScreenDataSubject.send(.cellWith(indexPath))
                }
            }
    }
    
    private func updateMoviePreference(for id: Int64, on buttonType: ButtonType, with value: Bool) -> IndexPath? {

        for (index,item) in screenData.enumerated() {

            if item.id == id {

                switch buttonType {
                case .favourite:
                    break
                case .watched:
                    item.watched = value
                    break
                }
                print("saving button tap on \(buttonType) with value \(value)")
                coreDataManager.updateMovie(item)
                
                return IndexPath(row: index, section: 0)
            }
        }
        
        return nil
    }
}
