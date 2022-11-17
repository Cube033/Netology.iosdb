//
//  AppDelegate.swift
//  Netology.iosdb
//
//  Created by Дмитрий Федотов on 01.11.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    //var window: UIWindow?
    var window: UIWindow? = UIWindow()
    var mainCoordinator = MainCoordinator(window: UIWindow())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        window = UIWindow()
//        let viewController = ViewController()
//        let navigationController = UINavigationController(rootViewController: viewController)
//        self.window?.rootViewController = navigationController
//        self.window?.makeKeyAndVisible()
        mainCoordinator = MainCoordinator(window: window!)
        mainCoordinator.startApplication()
        
        return true
    }

}

