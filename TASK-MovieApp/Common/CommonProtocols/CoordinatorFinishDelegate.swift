//
//  CoordinatorFinishDelegate.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 29.12.2020..
//

import Foundation

protocol CoordinatorFinishDelegate: class {
    
    func didFinish(childCoordinator: Coordinator)
}
