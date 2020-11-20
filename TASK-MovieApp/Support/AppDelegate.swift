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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.rootViewController = MovieTabBarController()
        window?.makeKeyAndVisible()
        
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().tintColor = .darkGray
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        CoreDataManager.sharedInstance.saveContext()
    }
    
}

