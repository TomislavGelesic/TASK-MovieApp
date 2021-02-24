//
//  AppCoordinator.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 29.12.2020..
//

import UIKit

#warning("ReadMe - AppFixes")
/*
 - In this implementation coordinators are not used as they could've been.
 - DetailScene should present modally.
 - Coordinators should be in view models classes.
 - Shouldn't remove HomeSCene from childCoordinators, app state and flow.
 - Debug proper deinit cals with print in deinit() of vm, vc, coord classes.
 */
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

