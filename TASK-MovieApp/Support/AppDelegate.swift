//
//  AppDelegate.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 30/10/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       
        
        window = UIWindow()
        
        let navigationController = UINavigationController(rootViewController: MovieFeedViewController())
                                                          
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }



}

