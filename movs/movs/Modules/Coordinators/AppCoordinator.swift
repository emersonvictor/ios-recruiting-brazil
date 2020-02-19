//
//  AppCoordinator.swift
//  movs
//
//  Created by Emerson Victor on 12/02/20.
//  Copyright © 2020 emer. All rights reserved.
//

import UIKit

class AppCoordinator: MainCoordinator {

    var presenter: UIWindow
    let rootController: MainTabBarController
    var childCoordinators: [Coordinator]
    
    // Initializer
    init(window: UIWindow) {
        self.presenter = window
        self.rootController = MainTabBarController()
        self.childCoordinators = []
    }
    
    // Start coordinator
    func start() {
        let moviesCoordinator = MoviesCoordinator()
        moviesCoordinator.start()
        let favoritesCoordinator = FavoritesCoordinator()
        favoritesCoordinator.start()
        
        self.rootController.viewControllers = [
            moviesCoordinator.rootController,
            favoritesCoordinator.rootController
        ]
        self.presenter.rootViewController = self.rootController
        self.presenter.makeKeyAndVisible()
    }
}
