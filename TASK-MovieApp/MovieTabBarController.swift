//
//  MovieTabBarController.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 04/11/2020.
//

import UIKit

class MovieTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMovieTabBarController()
    }
    
}


extension MovieTabBarController {
    
    private func setupMovieTabBarController() {
        
        let movieListController = createNavigationViewController(viewController: MovieListViewController(),
                                                                 selected:       UIImage(systemName: "video.circle.fill"),
                                                                 unselected:     UIImage(systemName: "video.circle"),
                                                                 title:          "Now playing")
        
        let favouritesController = createNavigationViewController(viewController: FavouriteMoviesViewController(),
                                                                  selected:       UIImage(named: "star_filled"),
                                                                  unselected:     UIImage(named: "star_unfilled"),
                                                                  title:          "Favourites")
        
        let watchedController = createNavigationViewController(viewController: WatchedMoviesViewController(),
                                                               selected:       UIImage(named: "watched_filled"),
                                                               unselected:     UIImage(named: "watched_unfilled"),
                                                               title:          "Watched")
        
        viewControllers = [favouritesController, movieListController, watchedController]
        
        selectedIndex = 1
    }
    
    private func createNavigationViewController(viewController: UIViewController, selected: UIImage?, unselected: UIImage?, title: String) -> UIViewController {
        
        guard let selected = selected, let unselected = unselected else { fatalError("createNavigationViewController error in MovieTabBarController") }
        
        viewController.view.backgroundColor = .darkGray
        viewController.title = title
        
        let controller = UINavigationController(rootViewController: viewController)
        controller.tabBarItem.image = unselected
        controller.tabBarItem.selectedImage = selected
        controller.view.backgroundColor = .darkGray
        controller.navigationBar.backgroundColor = .black
        return controller
    }
    
}

