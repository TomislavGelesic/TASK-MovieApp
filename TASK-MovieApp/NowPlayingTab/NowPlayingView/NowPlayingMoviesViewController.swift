
import UIKit
import SnapKit
import Combine

class NowPlayingMoviesViewController: UIViewController {
    
    //MARK: Properties
    
    weak var coordinator: TabBarCoordinator?
    
    private var nowPlayingMoviesViewModel: NowPlayingMoviesViewModel
        
    private var disposeBag = Set<AnyCancellable>()
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }()
    
    private let movieCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .darkGray
        return collectionView
    }()
    
    private let pullToRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .white
        control.backgroundColor = .darkGray
        control.attributedTitle = NSAttributedString(string: "Pull to refresh")
        return control
    }()
    
    //MARK: Life-cycle
    
    init(coordinator: TabBarCoordinator, viewModel: NowPlayingMoviesViewModel) {
        self.coordinator = coordinator
        nowPlayingMoviesViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        setupPullToRefreshControl()
        
        setupSubscribers()
        
        nowPlayingMoviesViewModel.initializeScreenDataSubject(with: nowPlayingMoviesViewModel.getNewScreenDataSubject.eraseToAnyPublisher())
            .store(in: &disposeBag)
        
        nowPlayingMoviesViewModel.initializeMoviePreferenceSubject(with: nowPlayingMoviesViewModel.moviePreferenceChangeSubject.eraseToAnyPublisher())
            .store(in: &disposeBag)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nowPlayingMoviesViewModel.getNewScreenDataSubject.send()
    }
    
}

extension NowPlayingMoviesViewController {
    
    //MARK: Functions
    
    private func setupCollectionView() {
        
        movieCollectionView.collectionViewLayout = flowLayout
        
        movieCollectionView.delegate = self
        
        movieCollectionView.dataSource = self
        
        movieCollectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: MovieListCollectionViewCell.reuseIdentifier)
        
        view.addSubview(movieCollectionView)
        
        movieCollectionViewConstraints()
    }
    
    private func movieCollectionViewConstraints () {
        
        movieCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setupPullToRefreshControl() {
        
        pullToRefreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        
        movieCollectionView.addSubview(pullToRefreshControl)
    }
    
    @objc func refreshMovies() {
        
        self.showSpinner()
        
        self.nowPlayingMoviesViewModel.getNewScreenDataSubject.send()
    }
    
    private func setupSubscribers() {
        
        nowPlayingMoviesViewModel.spinnerSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] (isVisible) in
                
                isVisible ? self.showSpinner() : self.hideSpinner()
            })
            .store(in: &disposeBag)
        
        nowPlayingMoviesViewModel.alertSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (errorMessage) in
                self.showAPIFailedAlert(for: errorMessage, completion: nil)
            }
            .store(in: &disposeBag)
        
        nowPlayingMoviesViewModel.refreshScreenDataSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (position) in
                
                self.reloadCollectionView(at: position)
            }
            .store(in: &disposeBag)
        
        nowPlayingMoviesViewModel.pullToRefreshControlSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (shouldBeRunning) in
                
                shouldBeRunning ? self.pullToRefreshControl.beginRefreshing() : self.pullToRefreshControl.endRefreshing()
            }
            .store(in: &disposeBag)
    }
    
    func reloadCollectionView(at position: RowUpdateState) {
        
        switch (position) {
        case .all:
            movieCollectionView.reloadData()
        case .cellWith(let indexPath):
            movieCollectionView.reloadItems(at: [indexPath])
            break
        }
    }
}

extension NowPlayingMoviesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return nowPlayingMoviesViewModel.screenData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MovieListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
       
        let item = nowPlayingMoviesViewModel.screenData[indexPath.row]
        
        cell.configure(with: item)
       
        cell.preferenceChanged = { [unowned self] (buttonType, value) in
            
            self.nowPlayingMoviesViewModel.moviePreferenceChangeSubject.send((id: item.id, on: buttonType, to: value))
        }

        return cell
    }
    
}

extension NowPlayingMoviesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let movie = nowPlayingMoviesViewModel.screenData[indexPath.row]
        
        let viewModel = MovieDetailViewModel(for: movie)
        
        let movieDetailViewController = MovieDetailViewController(viewModel: viewModel)
        
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
        
        
    }
}

extension NowPlayingMoviesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        let cellWidth = (movieCollectionView.frame.width - 30) / 2
        let cellHeight = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

