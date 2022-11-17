//
//  ViewControllerFactory.swift
//  Navigation
//
//  Created by Дмитрий Федотов on 24.09.2022.
//

import Foundation
import UIKit

class ScreenFlow {
    
    enum Flow {
        case files
        case settings
    }
    
    var flow: Flow
    let navigationController = UINavigationController()
    private(set) var coordinator: MainCoordinator
    
    init(flow: Flow, coordinator: MainCoordinator){
        self.flow = flow
        self.coordinator = coordinator
        getViewController()
    }
    
    func getViewController() {
        switch flow {
        case .files:
            let viewController = FilesViewController(coordinator: self.coordinator)
            navigationController.setViewControllers([viewController], animated: true)
            let tabBarItemFiles = UITabBarItem()
            navigationController.tabBarItem = tabBarItemFiles
            tabBarItemFiles.title = "Файлы"
            tabBarItemFiles.image = UIImage(systemName: "folder")
        case .settings:
            let viewController = SettingsViewController(coordinator: self.coordinator)
            navigationController.setViewControllers([viewController], animated: true)
            let tabBarItemSettings = UITabBarItem()
            navigationController.tabBarItem = tabBarItemSettings
            tabBarItemSettings.title = "Настройки"
            tabBarItemSettings.image = UIImage(systemName: "gear.badge")
        }
    }
    
}

