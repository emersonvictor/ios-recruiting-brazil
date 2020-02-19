//
//  MainTabBarController.swift
//  movs
//
//  Created by Emerson Victor on 04/12/19.
//  Copyright © 2019 emer. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - View controller life cycle
    override func loadView() {
        super.loadView()
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .label
    }
}
