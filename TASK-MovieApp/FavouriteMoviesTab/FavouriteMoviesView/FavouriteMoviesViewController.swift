
import UIKit
import SnapKit
import Combine

class FavouriteMoviesViewController: UIViewController {
    
    //MARK: Properties
    
    private var favouriteMoviesViewModel = MovieListWithPreferenceViewModel(preferenceType: .favourite)
    
    private var disposeBag = Set<AnyCancellable>()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .darkGray
        return tableView
    }()
    
    private let pullToRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .white
        control.backgroundColor = .darkGray
        control.attributedTitle = NSAttributedString(string: "Pull to refresh")
        return control
    }()
    
    //MARK: Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        setupPullToRefreshControl()
        
        setupViewModelSubscribers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favouriteMoviesViewModel.getNewScreenDataSubject.send()
    }
}

extension FavouriteMoviesViewController {
    
    //MARK: Private Functions
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 170
        
        tableView.addSubview(pullToRefreshControl)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setupViewModelSubscribers() {
        
        favouriteMoviesViewModel.initializeScreenDataSubject(with: self.favouriteMoviesViewModel.getNewScreenDataSubject.eraseToAnyPublisher())
            .store(in: &disposeBag)
        
        favouriteMoviesViewModel.initializeMoviePreferenceSubject(with: self.favouriteMoviesViewModel.movieReferenceSubject.eraseToAnyPublisher())
            .store(in: &disposeBag)
        
        favouriteMoviesViewModel.refreshScreenDataSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (rowUpdateType) in
                switch (rowUpdateType) {
                case .all:
                    self.tableView.reloadData()
                    break
                case .cellWith(let indexPath):
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    break
                }
                self.pullToRefreshControl.endRefreshing()
            }
            .store(in: &disposeBag)
    }
    
    private func setupPullToRefreshControl() {
        
        pullToRefreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
    }
    
    @objc func refreshMovies() {
        
        favouriteMoviesViewModel.getNewScreenDataSubject.send()
    }
}

extension FavouriteMoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favouriteMoviesViewModel.screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MovieTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.configure(with: favouriteMoviesViewModel.screenData[indexPath.row], enable: [.favourite])
        
        cell.preferenceChanged = { [unowned self] (buttonType, value) in
            
            let id = self.favouriteMoviesViewModel.screenData[indexPath.row].id
            
            self.favouriteMoviesViewModel.movieReferenceSubject.send((id, buttonType, value))
        }
        
        return cell
    }
}





