//
//  FilterDelegate.swift
//  Movs
//
//  Created by Emerson Victor on 21/02/20.
//  Copyright © 2020 emer. All rights reserved.
//

import Foundation

protocol FilterDelegate: AnyObject {
    func didSelect(_ value: String?, for type: FilterType)
}
