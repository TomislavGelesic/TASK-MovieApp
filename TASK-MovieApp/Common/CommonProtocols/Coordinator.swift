//
//  Coordinator.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 29.12.2020..
//

import UIKit

protocol Coordinator {
    
    var childCoordinators: [Coordinator] { set get }
    
    var navigationController: UINavigationController { set get }
    
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    var type: CoordinatorType { get }
    
    func finish()
    
    func start()
}
