//
//  MainTabBarViewController.swift
//  Netology.iosdb
//
//  Created by Дмитрий Федотов on 10.11.2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    private lazy var filesScreen = ScreenFlow(flow: .files, coordinator: getCoordinator())
    private lazy var settingsScreen = ScreenFlow(flow: .settings, coordinator: getCoordinator())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setControllers()
    }
    
    private func setControllers() {
        
        viewControllers = [filesScreen.navigationController,
                           settingsScreen.navigationController]
    }
    
    private func getCoordinator() -> MainCoordinator {
        let appDelegat = UIApplication.shared.delegate as? AppDelegate
        if let appDelegatExist = appDelegat {
            return appDelegatExist.mainCoordinator
        } else {
            return MainCoordinator(window: UIWindow())
        }
    }
}
