//
//  AppCoordinator.swift
//  movs
//
//  Created by Emerson Victor on 12/02/20.
//  Copyright © 2020 emer. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    typealias Presenter = UIWindow
    typealias Controller = TabBarController
    
    let presenter: UIWindow
    let controller: TabBarController
    
    // Child coordinators
    lazy var moviesCoordinator: MoviesCoordinator = {
        return MoviesCoordinator(parent: self)
    }()
    
    lazy var favoritesCoordinator: FavoritesCoordinator = {
        return FavoritesCoordinator(parent: self)
    }()

    // MARK: - Initializer
    init(window: UIWindow) {
        self.presenter = window
        self.controller = TabBarController()
    }
    
    func start() {
        self.controller.viewControllers = [
            self.moviesCoordinator.controller,
            self.favoritesCoordinator.controller
        ]
        self.presenter.rootViewController = self.controller
        self.presenter.makeKeyAndVisible()
    }
}
