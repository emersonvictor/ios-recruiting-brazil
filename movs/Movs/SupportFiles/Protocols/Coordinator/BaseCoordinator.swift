//
//  BaseCoordinator.swift
//  movs
//
//  Created by Emerson Victor on 19/02/20.
//  Copyright © 2020 emer. All rights reserved.
//

import UIKit

protocol BaseCoordinator: class {
        
    var childCoordinators: [Coordinator] { get set }
    func start()
}

// MARK: - Handle creation and deletion of coordinators
extension Coordinator {
    func add(_ childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }
    
    func remove(_ childCoordinator: Coordinator) {
        self.childCoordinators.removeAll { (coordinator) -> Bool in
            return coordinator === childCoordinator
        }
    }
}
