//
//  Movie.swift
//  movs
//
//  Created by Emerson Victor on 02/12/19.
//  Copyright © 2019 emer. All rights reserved.
//

import UIKit

class Movie {
    let id: Int
    let title: String
    let releaseDate: String
    let synopsis: String
    let posterPath: String?
    var posterImage: UIImage?
    let genres: Set<String>
    var isFavorite: Bool
    
    init(movie: MovieDTO) {
        let dataRepository = DataRepository()
        self.id = movie.id
        self.title = movie.title ?? ""
        self.releaseDate = movie.releaseDate == nil ? "" : String(movie.releaseDate!.prefix(4))
        self.synopsis = movie.synopsis ?? ""
        self.posterPath = movie.posterPath
        self.posterImage = nil
        self.genres = movie.genreIDs == nil ?
            Set([]) :
            Set(movie.genreIDs!.map({ (id) -> String in
                return dataRepository.localStorage.genres[id] ?? ""
            }))
        self.isFavorite = dataRepository.isFavorite(movie.id)
    }
    
    init(movie: MovieDetailDTO) {
        let dataRepository = DataRepository()
        self.id = movie.id
        self.title = movie.title ?? ""
        self.releaseDate = movie.releaseDate == nil ? "" : String(movie.releaseDate!.prefix(4))
        self.synopsis = movie.synopsis ?? ""
        self.posterPath = movie.posterPath
        self.posterImage = nil
        self.genres = movie.genres == nil ?
            Set([]) :
            Set(movie.genres!.map({ (genre) -> String in
                return genre.name
            }))
        self.isFavorite = dataRepository.isFavorite(movie.id)
    }
    
    func has(_ value: String, for key: FilterType) -> Bool {
        switch key {
        case .date:
            return self.releaseDate == value
        case .genre:
            return self.genres.contains(value)
        }
    }
}
