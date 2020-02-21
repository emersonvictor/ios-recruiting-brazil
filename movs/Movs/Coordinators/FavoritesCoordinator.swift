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
    var filters: [FilterType: String?]
    
    init() {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = .label
        self.rootController = navigationController
        self.childCoordinators = []
        self.filters = [:]
    }
    
    func start() {
        let favoritesController = FavoritesController()
        favoritesController.coordinator = self
        favoritesController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        self.rootController.pushViewController(favoritesController, animated: true)
    }
}

// MARK: - Actions related to movie detail
extension FavoritesCoordinator: MovieDetailDelegate, MovieFavoriteDelegate { }

extension FavoritesCoordinator: FavoritesDelegate {
    func showFilters() {
        let controller = FiltersController(filters: self.filters)
        controller.coordinator = self
        self.rootController.pushViewController(controller, animated: true)
    }
    
    func removeFilters() {
        self.filters = [:]
    }
}

// MARK: - Filter controller delegate
extension FavoritesCoordinator: FilterDelegate {
    func didSelect(_ value: String?, for type: FilterType) {
        self.filters[type] = value
    }
}

// MARK: - Filters controller delegate
extension FavoritesCoordinator: FiltersDelegate {
    func applyFilters() {
        self.rootController.popViewController(animated: true)
    }
    
    func showFilter(of type: FilterType) {
        let controller = FilterController(filterType: type,
                                          selectedValue: self.filters[type] ?? nil)
        controller.coordinator = self
        self.rootController.pushViewController(controller,
                                               animated: true)
    }
}
