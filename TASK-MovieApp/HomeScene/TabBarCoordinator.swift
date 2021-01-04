//
//  TabBarCoordinator.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 29.12.2020..
//

import UIKit

class TabBarCoordinator: NSObject, Coordinator {

    weak var parentCoordinator: AppCoordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    
    var tabBarController: UITabBarController
    
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        
        self.navigationController = navigationController
        tabBarController = .init()
    }
    
    deinit {
        
        print("TabBarCoordinator deinit called.")
    }
    
    func start() {
        
        let pages: [TabBarPage] = [.Favourites, .NowPlaying, .Watched]
        
        let viewControllers: [UINavigationController] = pages.map({ createTabCoordinator(from: $0) })
        
        tabBarController.setViewControllers( viewControllers, animated: true)
        
        tabBarController.selectedIndex = TabBarPage.NowPlaying.getOrderNumber()
        
        navigationController.viewControllers = [tabBarController]
    }
}


extension TabBarCoordinator {
    
    private func createTabCoordinator(from page: TabBarPage) -> UINavigationController {
    
        let childCoordinator: Coordinator
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        
        navigationController.navigationBar.standardAppearance = coloredAppearance
        navigationController.navigationBar.compactAppearance = coloredAppearance
        navigationController.navigationBar.scrollEdgeAppearance = coloredAppearance
        
        switch page {
        case .Favourites:
            childCoordinator = MovieListWithPreferenceCoordinator(navigationController: navigationController, preferenceType: .favourite)
            childCoordinator.start()
            if let image = page.getIcon(selected: false) { navigationController.tabBarItem.image = image }
            if let image = page.getIcon(selected: true) { navigationController.tabBarItem.selectedImage = image }
            break
            
        case .Watched:
            childCoordinator = MovieListWithPreferenceCoordinator(navigationController: navigationController, preferenceType: .watched)
            childCoordinator.start()
            if let image = page.getIcon(selected: false) { navigationController.tabBarItem.image = image }
            if let image = page.getIcon(selected: true) { navigationController.tabBarItem.selectedImage = image }
            break
            
        case .NowPlaying:
            childCoordinator = NowPlayingMoviesCoordinator(navigationController: navigationController, parentCoordinator: self)
            childCoordinator.start()
            if let image = page.getIcon(selected: false) { navigationController.tabBarItem.image = image }
            if let image = page.getIcon(selected: true) { navigationController.tabBarItem.selectedImage = image }
            break
        }
        
        childCoordinators.append(childCoordinator)
        return childCoordinator.navigationController
    }
    
    func showDetails(for movie: MovieRowItem) {
        
        parentCoordinator?.goToDetailCoordinator(item: movie)
    }
}


