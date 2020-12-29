//
//  AppCoordinator.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 29.12.2020..
//

import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var finishDelegate: CoordinatorFinishDelegate? = nil
    
    var type: CoordinatorType = .app
    
    
    
    func finish() {
        
    }
    
    func start() {
        
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.finishDelegate = self
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
    
    init(presenter: UINavigationController) {
        
        self.navigationController = presenter
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    
    func didFinish(childCoordinator: Coordinator) {
        
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type }) //removes childCoordinator which called finish
    }
    
    
}
