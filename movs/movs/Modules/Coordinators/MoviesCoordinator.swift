//
//  MoviesCoordinator.swift
//  movs
//
//  Created by Emerson Victor on 12/02/20.
//  Copyright © 2020 emer. All rights reserved.
//

import UIKit

class MoviesCoordinator: Coordinator {
    
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
        let moviesController = MoviesController()
        moviesController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        self.rootController.pushViewController(moviesController, animated: true)
    }
}
