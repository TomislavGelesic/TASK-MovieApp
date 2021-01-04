//
//  AppDelegate.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 30/10/2020.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        
        navigationController.navigationBar.standardAppearance = coloredAppearance
        navigationController.navigationBar.compactAppearance = coloredAppearance
        navigationController.navigationBar.scrollEdgeAppearance = coloredAppearance
        
        #warning("found this.. thoughts?")
//        WANT TO DO:
        
//        navigationController.preferredStatusBarStyle = .lightContent
//
//        ANSWER FOR Swift 5 and SwiftUI:
//
//        For SwiftUI create a new swift file called HostingController.swift
//
//        import Foundation
//        import UIKit
//        import SwiftUI
//
//        class HostingController: UIHostingController<ContentView> {
//            override var preferredStatusBarStyle: UIStatusBarStyle {
//                return .lightContent
//            }
//        }
//        Then change the following lines of code in the SceneDelegate.swift
//
//        window.rootViewController = UIHostingController(rootView: ContentView())
//        to
//
//        window.rootViewController = HostingController(rootView: ContentView())
        
        window = UIWindow()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        appCoordinator = AppCoordinator(presenter: navigationController)
        
        appCoordinator?.start()
        
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().tintColor = .darkGray
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        CoreDataManager.sharedInstance.saveContext()
    }
    
}

