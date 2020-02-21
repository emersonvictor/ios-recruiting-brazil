//
//  MovieFavoriteDelegate.swift
//  Movs
//
//  Created by Emerson Victor on 20/02/20.
//  Copyright © 2020 emer. All rights reserved.
//

import Foundation

protocol MovieFavoriteDelegate: AnyObject {
    func toggleFavorite(_ movie: Movie)
}

extension MovieFavoriteDelegate where Self: Coordinator {
    func toggleFavorite(_ movie: Movie) {
        movie.isFavorite = !movie.isFavorite
    }
}
