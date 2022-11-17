//
//  CoordinatorProtocol.swift
//  Netology.iosdb
//
//  Created by Дмитрий Федотов on 10.11.2022.
//

import Foundation

import Foundation
import UIKit

protocol CoordinatorProtocol {
    
    var navigationController: UINavigationController {get set}
    
    //func getStartViewController() -> UIViewController
    
    func handleAction(actionType: CoordinatorActionProtocol)
}

protocol CoordinatorActionProtocol {
    
}
