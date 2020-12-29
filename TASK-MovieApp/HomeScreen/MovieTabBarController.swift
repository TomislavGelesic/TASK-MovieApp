
import UIKit

class MovieTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMovieTabBarController()
    }
}


extension MovieTabBarController {
    
    private func setupMovieTabBarController() {
        
        let movieListController = createNavigationViewController(viewController: NowPlayingMoviesViewController(
                                                                 viewModel: NowPlayingMoviesViewModel()),
                                                                 selected: UIImage(systemName: "house"),
                                                                 unselected: UIImage(systemName: "house.fill"))
        
        let favouritesController = createNavigationViewController(viewController: FavouriteMoviesViewController(
                                                                  viewModel: MovieListWithPreferenceViewModel(preferenceType: .favourite)),
                                                                  selected:       UIImage(systemName: "star"),
                                                                  unselected:     UIImage(systemName: "star.fill"))
        
        let watchedController = createNavigationViewController(viewController: WatchedMoviesViewController(
                                                               viewModel: MovieListWithPreferenceViewModel(preferenceType: .watched)),
                                                               selected:       UIImage(systemName: "checkmark.seal"),
                                                               unselected:     UIImage(systemName: "checkmark.seal.fill"))
        
        viewControllers = [favouritesController, movieListController, watchedController]
        
        selectedIndex = 1
    }
    
    private func createNavigationViewController(viewController: UIViewController, selected: UIImage?, unselected: UIImage?) -> UIViewController {
        
        guard let selected = selected, let unselected = unselected else { fatalError("createNavigationViewController error in MovieTabBarController") }
        
        viewController.view.backgroundColor = .darkGray
        
        let controller = UINavigationController(rootViewController: viewController)
        controller.tabBarItem.image = unselected
        controller.tabBarItem.selectedImage = selected
        controller.setNavigationBarHidden(true, animated: false)
        return controller
    }
    
}

