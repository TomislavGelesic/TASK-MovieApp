
import UIKit

class MovieTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMovieTabBarController()
    }
}


extension MovieTabBarController {
    
    private func setupMovieTabBarController() {
        
        let movieListController = createNavigationViewController(viewController: MovieListViewController(viewModel: MovieListViewModel()),
                                                                 selected:       UIImage(named: "house_filled")?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)),
                                                                 unselected:     UIImage(named: "house_unfilled")?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)))
        
        let favouritesController = createNavigationViewController(viewController: FavouriteMoviesViewController(viewModel: MovieListWithPreferenceViewModel(preferenceType: .favourite)),
                                                                  selected:       UIImage(named: "star_filled"),
                                                                  unselected:     UIImage(named: "star_unfilled"))
        
        let watchedController = createNavigationViewController(viewController: WatchedMoviesViewController(viewModel: MovieListWithPreferenceViewModel(preferenceType: .watched)),
                                                               selected:       UIImage(named: "watched_filled"),
                                                               unselected:     UIImage(named: "watched_unfilled"))
        
        viewControllers = [favouritesController, movieListController, watchedController]
        
        selectedIndex = 1
    }
    
    private func createNavigationViewController(viewController: UIViewController, selected: UIImage?, unselected: UIImage?) -> UIViewController {
        
        guard let selected = selected, let unselected = unselected else { fatalError("createNavigationViewController error in MovieTabBarController") }
        
        viewController.view.backgroundColor = .darkGray
        
        let controller = UINavigationController(rootViewController: viewController)
        controller.tabBarItem.image = unselected
        controller.tabBarItem.selectedImage = selected
        controller.navigationBar.barStyle = .black
        controller.navigationBar.isTranslucent = false
        return controller
    }
    
}

