//
//  AppCoordinator.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 29.12.2020..
//

import UIKit

class AppCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    func start() {
        
        goToTabBarCoordinator()
    }
    
    init(presenter: UINavigationController) {
        
        self.navigationController = presenter
    }
}

extension AppCoordinator {
    
    func goToDetailCoordinator(item: MovieRowItem){
        
        childCoordinators.removeAll()
        
        let child = MovieDetailCoordinator(navigationController: navigationController, item: item)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    func goToTabBarCoordinator() {
        
        childCoordinators.removeAll()
        
        let child = TabBarCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}

