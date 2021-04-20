
@testable import TASK_MovieApp
import Quick
import Nimble
import Combine
import Cuckoo
import Alamofire


class MovieAppTests: QuickSpec {
    
    func getResource<T: Codable>(_ fileName: String) -> T? {
        let bundle = Bundle.init(for: MovieAppTests.self)
        guard let resourcePath = bundle.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: resourcePath),
              let parsedData: T = SerializationManager.parseData(jsonData: data) else { return nil }
        return parsedData
    }
    
    //Usage of Quick and Nimble libraries
    override func spec() {
        // Preparation - Arrange_Act_Assert method used
        var sut: NowPlayingMoviesViewModel!
        var mock: MockMovieRepositoryImpl!
        var disposeBag = Set<AnyCancellable>()
        var alertCalled: Bool!
        
        func cleanDisposeBag() { for cancellable in disposeBag { cancellable.cancel() } }
        
        func initialize() {
            mock = MockMovieRepositoryImpl()
            sut = NowPlayingMoviesViewModel(repository: mock)
            alertCalled = false
            
            sut.initializeScreenDataSubject(with: sut.getNewScreenDataSubject.eraseToAnyPublisher())
                .store(in: &disposeBag)
            
            sut.alertSubject.sink { (message) in
                alertCalled = true
            }
            .store(in: &disposeBag)
            
            sut.initializeMoviePreferenceSubject(with: sut.moviePreferenceChangeSubject.eraseToAnyPublisher())
                .store(in: &disposeBag)
        }
        describe ("UNIT-TEST NowPlayingViewModels") {
            context("Good screen data initialize success screen") {
                beforeEach {
                    initialize()
                    stub(mock) { mock in
                        when(mock.fetchNowPlaying()).then { (_) -> AnyPublisher<Result<MovieResponse, AFError>, Never> in
                            if let data: MovieResponse = self.getResource("NowPlayingJSONResponse"){
                                return Just(Result<MovieResponse, AFError>.success(data)).eraseToAnyPublisher()
                            } else {
                                return Just(Result<MovieResponse, AFError>.success(MovieResponse.init(results: [MovieResponseItem]()))).eraseToAnyPublisher()
                            }
                        }
                    }
                }
                afterEach { cleanDisposeBag() }
                it("Success screen initialized.") {
                    let expected: Int64 = 508442
                    sut.getNewScreenDataSubject.send()
                    expect(sut.screenData.count).toEventually(equal(20))
                    expect(sut.screenData[1].id).toEventually(equal(expected))
                }
            }
            
            context("Bad screen data initialize fail screen.") {
                beforeEach { initialize() }
                afterEach { cleanDisposeBag() }
                it("Fail screen initialized.") {
                    sut.alertSubject.send("")
                    expect(alertCalled).toEventually(equal(true))
                }
            }
        }
        
    }
}
