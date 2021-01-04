
import UIKit
import SnapKit
import Combine

class WatchedMoviesViewController: UIViewController {
    
    private var watchedMoviesViewModel: MovieListWithPreferenceViewModel
    
    private var disposeBag = Set<AnyCancellable>()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .darkGray
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    init(viewModel: MovieListWithPreferenceViewModel) {
        watchedMoviesViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        setupViewSubscribers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        watchedMoviesViewModel.getNewScreenDataSubject.send()
            
    }
}

extension WatchedMoviesViewController {
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 170
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setupViewSubscribers() {
        
        watchedMoviesViewModel.initializeScreenDataSubject(with: self.watchedMoviesViewModel.getNewScreenDataSubject.eraseToAnyPublisher())
            .store(in: &disposeBag)
        
        watchedMoviesViewModel.initializeMoviePreferenceSubject(with: self.watchedMoviesViewModel.movieReferenceSubject.eraseToAnyPublisher())
            .store(in: &disposeBag)
        
        watchedMoviesViewModel.refreshScreenDataSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (positionToUpdate) in
                
                self.reloadTableView(at: positionToUpdate)
            }
            .store(in: &disposeBag)
    }
    
    func reloadTableView(at position: RowUpdateState) {
        
        switch (position) {
        case .all:
            self.tableView.reloadData()
            break
        case .cellWith(let indexPath):
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            break
        }
    }
}

extension WatchedMoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if watchedMoviesViewModel.screenData.isEmpty {
            let messageLabel = UILabel()
            messageLabel.text = "Sorry, no prefered movies for this list. \nGo and add one..."
            messageLabel.numberOfLines = 2
            messageLabel.textColor = .white
            messageLabel.textAlignment = .center
            tableView.backgroundView = messageLabel
            return 0
        }
        
        tableView.backgroundView = nil
        
        return watchedMoviesViewModel.screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MovieTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        let item = watchedMoviesViewModel.screenData[indexPath.row]
        
        cell.configure(with: item, enable: [.watched])
        
        cell.preferenceChanged = { [unowned self] (buttonType, value) in
            
            self.watchedMoviesViewModel.movieReferenceSubject.send((item.id, buttonType, value))
        }
        
        return cell
    }
}





