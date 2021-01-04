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
        
        setupTabBarController(with: pages)
    }
}


extension TabBarCoordinator {
    
    private func setupTabBarController(with pages: [TabBarPage]) {
        
        let viewControllers: [UINavigationController] = pages.map { createTabBarController(from: $0) }
        
        tabBarController.setViewControllers( viewControllers, animated: true)
        
        tabBarController.selectedIndex = TabBarPage.NowPlaying.getOrderNumber()
        
        navigationController.viewControllers = [tabBarController]
    }
    
    private func createTabBarController(from page: TabBarPage) -> UINavigationController {
        
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        
        navController.navigationBar.standardAppearance = coloredAppearance
        navController.navigationBar.compactAppearance = coloredAppearance
        navController.navigationBar.scrollEdgeAppearance = coloredAppearance
        
        switch page {
        case .Favourites:
            let favouriteMoviesViewControler = MovieListWithPreferenceViewController(coordinator: self, viewModel: MovieListWithPreferenceViewModel(preferenceType: .favourite))
            if let image = page.getIcon(selected: false) { navController.tabBarItem.image = image }
            if let image = page.getIcon(selected: true) { navController.tabBarItem.selectedImage = image }
            navController.pushViewController(favouriteMoviesViewControler, animated: true)
            
        case .NowPlaying:
            let nowPlayingMoviesViewController = NowPlayingMoviesViewController(coordinator: self, viewModel: NowPlayingMoviesViewModel())
            if let image = page.getIcon(selected: false) { navController.tabBarItem.image = image }
            if let image = page.getIcon(selected: true) { navController.tabBarItem.selectedImage = image }
            navController.pushViewController(nowPlayingMoviesViewController, animated: true)
            
        case .Watched:
            let watchedMoviesViewControler = MovieListWithPreferenceViewController(coordinator: self, viewModel: MovieListWithPreferenceViewModel(preferenceType: .watched))
            if let image = page.getIcon(selected: false) { navController.tabBarItem.image = image }
            if let image = page.getIcon(selected: true) { navController.tabBarItem.selectedImage = image }
            navController.pushViewController(watchedMoviesViewControler, animated: true)
        }
        
        return navController
    }
}

extension TabBarCoordinator {
    
    func showDetailOn(_ movie: MovieRowItem) {
        
        parentCoordinator?.goToDetailCoordinator(item: movie)
    }
}

