//
//  DataRepository.swift
//  movs
//
//  Created by Emerson Victor on 10/02/20.
//  Copyright © 2020 emer. All rights reserved.
//

import UIKit

struct DataRepository {
    // MARK: - Attributes
    let localStorage: DataStorage.Type
    let apiManager: APIManager
    
    // MARK: - Initializers
    init() {
        self.localStorage = DataStorage.self
        self.apiManager = APIManager()
    }
    
    init(localStorage: DataStorage.Type, apiManager: APIManager) {
        self.localStorage = localStorage.self
        self.apiManager = apiManager
    }
    
    // MARK: - Data load
    func loadMovies(of page: Int, completion: @escaping (_ loadSuccessful: Bool) -> Void) {
        if page == 1 {
            let endpoint = Endpoint(type: .movie, path: "/genre/movie/list")
            self.apiManager.fetch(endpoint: endpoint) { (result: Result<GenresDTO, Error>) in
                switch result {
                case .failure:
                    completion(false)
                case .success(let genresDTO):
                    genresDTO.genres.forEach { (genre) in
                        self.localStorage.genres[genre.id] = genre.name
                    }

                    let endpoint = Endpoint(type: .movie,
                                            path: "/movie/popular",
                                            queries: [URLQueryItem(name: "page", value: "\(page)")])
                    self.apiManager.fetch(endpoint: endpoint) { (result: Result<MoviesRequestDTO, Error>) in
                        switch result {
                        case .failure:
                            completion(false)
                        case .success(let moviesRequest):
                            let movies = moviesRequest.movies.map { (movieDTO) -> Movie in
                                return Movie(movie: movieDTO)
                            }
                            self.localStorage.movies.append(contentsOf: movies)
                            completion(true)
                        }
                    }
                }
            }
        } else {
            let endpoint = Endpoint(type: .movie,
                                    path: "/movie/popular",
                                    queries: [URLQueryItem(name: "page", value: "\(page)")])
            self.apiManager.fetch(endpoint: endpoint) { (result: Result<MoviesRequestDTO, Error>) in
                switch result {
                case .failure:
                    completion(false)
                case .success(let moviesRequest):
                    let movies = moviesRequest.movies.map { (movieDTO) -> Movie in
                        return Movie(movie: movieDTO)
                    }
                    self.localStorage.movies.append(contentsOf: movies)
                    completion(true)
                }
            }
        }
    }
    
    func loadPosterImage(with path: String, completion: @escaping (UIImage) -> Void) {
        let endpoint = Endpoint(type: .image, path: path)
        self.apiManager.fetchPoster(endpoint: endpoint) { (result: Result<UIImage, Error>) in
            switch result {
            case .failure:
                completion(UIImage(named: "PosterUnavailabe")!)
            case .success(let image):
                completion(image)
            }
        }
    }
    
    func loadFavorites(completion: @escaping (_ loadSuccessful: Bool) -> Void) {
        let group = DispatchGroup()
        var hasFailed = false
        
        self.localStorage.favoritesIDs.forEach { (id) in
            group.enter()
            
            if self.localStorage.favorites.contains(where: { movie in movie.id == id }) {
                group.leave()
            } else if let movie = self.localStorage.movies.first(where: { movie in movie.id == id }) {
                self.localStorage.favorites.append(movie)
                group.leave()
            } else {
                let endpoint = Endpoint(type: .movie, path: "/movie/\(id)")
                self.apiManager.fetch(endpoint: endpoint) { (result: Result<MovieDetailDTO, Error>) in
                    switch result {
                    case .failure:
                        hasFailed = true
                    case .success(let movieDetailDTO):
                        self.localStorage.favorites.append(Movie(movie: movieDetailDTO))
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            if hasFailed {
                completion(false)
            } else {
                completion(true)
            }
        })
    }
    
    // MARK: - Favorite    
    func toggle(_ id: Int) {
        if self.localStorage.favoritesIDs.contains(id) {
            self.localStorage.favoritesIDs.remove(id)
            self.localStorage.favorites.removeAll { (movie) -> Bool in
                return movie.id == id
            }
        } else {
            self.localStorage.favoritesIDs.insert(id)
        }
    }
    
    func isFavorite(_ id: Int) -> Bool {
        return self.localStorage.favoritesIDs.contains(id)
    }
}
