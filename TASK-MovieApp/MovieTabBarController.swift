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
    
    private func setupMovieTabBarController() {
        
        let movieFeedNavigationController = createViewController(viewController: MovieFeedViewController(), selected: UIImage(systemName: "video.circle.fill")!, unselected: UIImage(systemName: "video.circle")!)
        let favouritesNavigationController = createViewController(viewController: FavouriteMoviesViewController(), selected: UIImage(named: "star_filled")!, unselected: UIImage(named: "star_unfilled")!)
        let watchedNavigationController = createViewController(viewController: WatchedMoviesViewController(), selected: UIImage(named: "watched_filled")!, unselected: UIImage(named: "watched_unfilled")!)
        
        viewControllers = [movieFeedNavigationController, favouritesNavigationController, watchedNavigationController]

    }

    private func createViewController(viewController: UIViewController, selected: UIImage, unselected: UIImage) -> UIViewController {
        viewController.tabBarItem.image = unselected
        viewController.tabBarItem.selectedImage = selected
        return viewController
    }

}
