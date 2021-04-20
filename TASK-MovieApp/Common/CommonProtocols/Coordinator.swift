//
//  Coordinator.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 29.12.2020..
//

import UIKit

protocol Coordinator: class {
    
    var childCoordinators: [Coordinator] { set get }
    
    var navigationController: UINavigationController { set get }
    
    func start()
}


