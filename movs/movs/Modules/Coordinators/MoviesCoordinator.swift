//
//  MoviesCoordinator.swift
//  movs
//
//  Created by Emerson Victor on 12/02/20.
//  Copyright © 2020 emer. All rights reserved.
//

import UIKit

class MoviesCoordinator: Coordinator {
    
    typealias Presenter = UITabBarController
    typealias Controller = UINavigationController
    
    let presenter: Presenter
    let controller: Controller
    
    init(parent: AppCoordinator) {
        let moviesController = MoviesController()
        moviesController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let controller = UINavigationController(rootViewController: moviesController)
        controller.navigationBar.prefersLargeTitles = true
        controller.navigationBar.tintColor = .label
        
        self.presenter = parent.controller
        self.controller = controller
    }
    
    func start() { }
}
