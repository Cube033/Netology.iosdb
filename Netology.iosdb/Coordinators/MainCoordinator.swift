//
//  MainCoordinator.swift
//  Netology.iosdb
//
//  Created by Дмитрий Федотов on 10.11.2022.
//

import Foundation
import UIKit

enum CoordinatorActionType {
    case startApplication
    case successLogin
    case openFilesList
    case openSettings
    case changePassword
}

class MainCoordinator {
    
    var navigationController: UINavigationController = UINavigationController()
    
//    func getStartViewController() -> UIViewController {
//        <#code#>
//    }
    
    func handleAction(actionType: CoordinatorActionType) {
        switch actionType {
        case .startApplication:
            startApplication()
        case .successLogin:
            successLogin()
            
        default: break
            
        }
    }
    
    
    var window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func startApplication(){
        let currentViewController = LoginViewController(coordinator: self)
//        if UserInfo.shared.loggedIn {
//            let viewController = MainTabBarViewController()
//            currentViewController = viewController
//
//        }  else {
//            let viewController = LogInViewController(mainCoordinator: self)
//            viewController.loginDelegate = MyLoginFactory.makeLoginInspector()
//            currentViewController = viewController //костыль - так как не удается указать свойство loginDelegate напрямую
//        }
        self.window?.rootViewController = currentViewController
        self.window?.makeKeyAndVisible()
    }
    
    func successLogin(){
        var currentViewController: UIViewController
        
        let viewController = MainTabBarViewController()
        currentViewController = viewController
        
        
        //            let viewController = LogInViewController(mainCoordinator: self)
        //            viewController.loginDelegate = MyLoginFactory.makeLoginInspector()
        //            currentViewController = viewController //костыль - так как не удается указать свойство loginDelegate напрямую
        
        self.window?.rootViewController = currentViewController
        self.window?.makeKeyAndVisible()
    }
}
