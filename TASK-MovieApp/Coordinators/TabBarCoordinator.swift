//
//  TabBarCoordinator.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 29.12.2020..
//

import UIKit

class TabBarCoordinator: NSObject, TabBarCoordinatorProtocol {
    
    var childCoordinators: [Coordinator] = []
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var type: CoordinatorType = .tab 
    
    var tabBarController: UITabBarController
    
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        
        self.navigationController = navigationController
        tabBarController = .init()
    }
    
    deinit {
        
        print("TabBarCoordinator deinit called.")
    }
    
    func selectPage(_ page: TabBarPage) {
        
        tabBarController.selectedIndex = page.getOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        
        guard let page = TabBarPage.init(index: index) else { return }
        
        tabBarController.selectedIndex = page.getOrderNumber()
        
    }
    
    func currentPage() -> TabBarPage? {
        
        return TabBarPage.init(index: tabBarController.selectedIndex)
    }
    
    func finish() {
        
        finishDelegate?.didFinish(childCoordinator: self)
    }
    
    func start() {
        
        let pages: [TabBarPage] = [.Favourites, .NowPlaying, .Watched]
        
        let controllers: [UINavigationController] = pages.map { (page) -> UINavigationController in
            getTabController(for: page)
        }
        
        prepareTabBarController(withTabControllers: controllers)
    }
}


extension TabBarCoordinator {
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        
        tabBarController.delegate = self
        
        tabBarController.setViewControllers(tabControllers, animated: true)
        
        tabBarController.selectedIndex = TabBarPage.NowPlaying.getOrderNumber()
        
        navigationController.viewControllers = [tabBarController]
    }
    
    private func getTabController(for page: TabBarPage) -> UINavigationController {
        
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
            let favouriteMoviesViewControler = FavouriteMoviesViewController(viewModel: MovieListWithPreferenceViewModel(preferenceType: .favourite))
            if let image = page.getIcon(selected: false) { navController.tabBarItem.image = image }
            if let image = page.getIcon(selected: true) { navController.tabBarItem.selectedImage = image }
            navController.pushViewController(favouriteMoviesViewControler, animated: true)
            
        case .NowPlaying:
            let nowPlayingMoviesViewController = NowPlayingMoviesViewController(viewModel: NowPlayingMoviesViewModel())
            if let image = page.getIcon(selected: false) { navController.tabBarItem.image = image }
            if let image = page.getIcon(selected: true) { navController.tabBarItem.selectedImage = image }
            navController.pushViewController(nowPlayingMoviesViewController, animated: true)
            
        case .Watched:
            let watchedMoviesViewControler = WatchedMoviesViewController(viewModel: MovieListWithPreferenceViewModel(preferenceType: .watched))
            if let image = page.getIcon(selected: false) { navController.tabBarItem.image = image }
            if let image = page.getIcon(selected: true) { navController.tabBarItem.selectedImage = image }
            navController.pushViewController(watchedMoviesViewControler, animated: true)
        }
        
        return navController
    }
}

extension TabBarCoordinator: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
}
