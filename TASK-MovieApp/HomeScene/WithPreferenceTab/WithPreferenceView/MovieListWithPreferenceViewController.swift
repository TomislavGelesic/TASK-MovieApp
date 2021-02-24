
import UIKit
import SnapKit
import Combine

class MovieListWithPreferenceViewController: UIViewController {
    
    //MARK: Properties
    
    weak var coordinator: Coordinator?
    
    private var viewModel: MovieListWithPreferenceViewModel
    
    private var disposeBag = Set<AnyCancellable>()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .darkGray
        tableView.allowsSelection = false
        tableView.register(MovieListWithPreferenceTableViewCell.self, forCellReuseIdentifier: MovieListWithPreferenceTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    //MARK: Life-cycle
    
    init(coordinator: Coordinator, viewModel: MovieListWithPreferenceViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        setupViewModelSubscribers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getNewScreenDataSubject.send()
    }
}

extension MovieListWithPreferenceViewController {
    
    //MARK: Private Functions
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 170
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setupViewModelSubscribers() {
        
        viewModel.initializeScreenDataSubject(with: self.viewModel.getNewScreenDataSubject.eraseToAnyPublisher())
            .store(in: &disposeBag)
        
        viewModel.initializeMoviePreferenceSubject(with: self.viewModel.movieReferenceSubject.eraseToAnyPublisher())
            .store(in: &disposeBag)
        
        viewModel.refreshScreenDataSubject
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

extension MovieListWithPreferenceViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if viewModel.screenData.isEmpty {
            let messageLabel = UILabel()
            messageLabel.text = "Sorry, no prefered movies for this list. \nGo and add one..."
            messageLabel.numberOfLines = 2
            messageLabel.textColor = .white
            messageLabel.textAlignment = .center
            tableView.backgroundView = messageLabel
            return 0
        }
        tableView.backgroundView = nil
        return viewModel.screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MovieListWithPreferenceTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        let item = viewModel.screenData[indexPath.row]
        
        cell.configure(with: item, enable: [viewModel.preference])
        
        cell.preferenceChanged = { [unowned self] (buttonType, value) in
            
            self.viewModel.movieReferenceSubject.send((item.id, buttonType, value))
        }
        
        return cell
    }
}






