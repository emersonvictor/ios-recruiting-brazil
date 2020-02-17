//
//  CoordinatorProtocol.swift
//  movs
//
//  Created by Emerson Victor on 12/02/20.
//  Copyright © 2020 emer. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    
    associatedtype Presenter
    associatedtype Controller: UIViewController
    
    var controller: Controller { get }
    var presenter: Presenter { get }
    
    func start()
}
