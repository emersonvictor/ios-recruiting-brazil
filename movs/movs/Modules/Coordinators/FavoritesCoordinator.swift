//
//  FavoritesCoordinator.swift
//  movs
//
//  Created by Emerson Victor on 12/02/20.
//  Copyright © 2020 emer. All rights reserved.
//

import UIKit

class FavoritesCoordinator: Coordinator {
    
    typealias Presenter = TabBarController
    typealias Controller = UINavigationController
    
    let controller: Controller
    let presenter: Presenter
    
    init(parent: AppCoordinator) {
        let favoritesController = FavoritesController()
        favoritesController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        let controller = UINavigationController(rootViewController: favoritesController)
        controller.navigationBar.prefersLargeTitles = true
        controller.navigationBar.tintColor = .label
        
        self.presenter = parent.controller
        self.controller = controller
    }
    
    func start() { }
    
}
