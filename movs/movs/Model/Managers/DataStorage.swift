//
//  DataStorage.swift
//  movs
//
//  Created by Emerson Victor on 03/12/19.
//  Copyright © 2019 emer. All rights reserved.
//

import UIKit

struct DataStorage {
    static var genres: [Int: String] = [:]
    static var movies: [Movie] = []
    static var favorites: [Movie] = []
    static var favoritesIDs: Set<Int> {
        get {
            let favoritesids = UserDefaults.standard.array(forKey: "FavoritesIDs") as? [Int] ?? []
            return Set(favoritesids)
        }
        
        set {
            UserDefaults.standard.set(Array(newValue), forKey: "FavoritesIDs")
        }
    }
}
