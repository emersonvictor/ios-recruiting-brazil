//
//  FiltersDelegate.swift
//  movs
//
//  Created by Emerson Victor on 19/02/20.
//  Copyright © 2020 emer. All rights reserved.
//

import Foundation

protocol FiltersDelegate: AnyObject {
    var filters: [FilterType: String?] { get }
    
    func applyFilters()
    func showFilter(of type: FilterType)
}
