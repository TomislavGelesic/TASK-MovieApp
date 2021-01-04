//
//  MovieListWithPreferenceCoordinator.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 01.01.2021..
//

import UIKit

class MovieListWithPreferenceCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var preferenceType: PreferenceType
    
    init(navigationController: UINavigationController, preferenceType: PreferenceType) {
        self.preferenceType = preferenceType
        self.navigationController = navigationController
    }
    
    deinit {
        print("FavouriteMoviesCoordinator deinit called.")
    }
    
    func start() {
        
        let viewModel = MovieListWithPreferenceViewModel(preferenceType: preferenceType)
        
        let viewController = MovieListWithPreferenceViewController(coordinator: self, viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
        
    }
}

extension MovieListWithPreferenceCoordinator {
    
    
}
