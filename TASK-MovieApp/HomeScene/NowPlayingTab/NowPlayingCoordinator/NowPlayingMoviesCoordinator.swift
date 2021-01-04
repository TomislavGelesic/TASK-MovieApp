//
//  NowPlayingMoviesCoordinator.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 01.01.2021..
//

import UIKit

class NowPlayingMoviesCoordinator: Coordinator {
    
    var parentCoordinator: TabBarCoordinator
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, parentCoordinator: TabBarCoordinator) {
        
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        
        let viewModel = NowPlayingMoviesViewModel()
        
        let viewController = NowPlayingMoviesViewController(coordinator: self, viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showDetails(for movie: MovieRowItem) -> () {
        
        parentCoordinator.showDetails(for: movie)
    }

}
