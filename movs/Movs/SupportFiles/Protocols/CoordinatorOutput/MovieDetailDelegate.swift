//
//  MovieDetailDelegate.swift
//  movs
//
//  Created by Emerson Victor on 19/02/20.
//  Copyright © 2020 emer. All rights reserved.
//

import Foundation

protocol MovieDetailDelegate: AnyObject {
    func show(_ movie: Movie)
}

extension MovieDetailDelegate where Self: Coordinator & MovieFavoriteDelegate {
    func show(_ movie: Movie) {
        let controller = MovieDetailController(movie: movie)
        controller.coordinator = self
        self.rootController.pushViewController(controller, animated: true)
    }
}
