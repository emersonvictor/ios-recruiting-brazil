//
//  AppCoordinator.swift
//  movs
//
//  Created by Emerson Victor on 12/02/20.
//  Copyright © 2020 emer. All rights reserved.
//

import UIKit

class AppCoordinator: MainCoordinator {

    let presenter: UIWindow
    let rootController: MainTabBarController
    var childCoordinators: [Coordinator]
    
    init(window: UIWindow) {
        self.presenter = window
        self.rootController = MainTabBarController()
        self.childCoordinators = []
    }
    
    func start() {
        let moviesCoordinator = MoviesCoordinator()
        moviesCoordinator.start()
        self.add(moviesCoordinator)
        
        let favoritesCoordinator = FavoritesCoordinator()
        favoritesCoordinator.start()
        self.add(favoritesCoordinator)
        
        self.rootController.viewControllers = [
            moviesCoordinator.rootController,
            favoritesCoordinator.rootController
        ]
        self.presenter.rootViewController = self.rootController
        self.presenter.makeKeyAndVisible()
    }
}
