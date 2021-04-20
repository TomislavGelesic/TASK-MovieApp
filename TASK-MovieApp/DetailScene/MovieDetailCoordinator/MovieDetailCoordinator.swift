//
//  MovieDetailCoordinator.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 29.12.2020..
//

import UIKit

class MovieDetailCoordinator: Coordinator {
    
    weak var parentCoordinator: AppCoordinator?
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var movieRowItem: MovieRowItem
    
    func start() {
        
        showDetails(movieRowItem)
    }
    
    init(navigationController: UINavigationController, item: MovieRowItem) {
        self.navigationController = navigationController
        movieRowItem = item
    }
    
    deinit {
        
        print("MovieDetailCoordinator deinit called.")
    }
    
    func showDetails(_ movie: MovieRowItem) -> () {
        
        let movieDetailViewController = MovieDetailViewController(viewModel: MovieDetailViewModel(for: movie, repository: MovieDetailRepositoryImpl()))
        navigationController.pushViewController(movieDetailViewController, animated: true)
    }
}

