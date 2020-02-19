//
//  FavoritesCoordinator.swift
//  movs
//
//  Created by Emerson Victor on 12/02/20.
//  Copyright © 2020 emer. All rights reserved.
//

import UIKit

class FavoritesCoordinator: Coordinator {
    
    var rootController: UINavigationController
    var childCoordinators: [Coordinator]
    
    init() {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = .label
        self.rootController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        let moviesController = FavoritesController()
        moviesController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        self.rootController.pushViewController(moviesController, animated: true)
    }
}
