//
//  CoordinatorProtocol.swift
//  movs
//
//  Created by Emerson Victor on 12/02/20.
//  Copyright © 2020 emer. All rights reserved.
//

import UIKit

protocol Coordinator: BaseCoordinator {
    var rootController: UINavigationController { get }
}
