//
//  MoviesController.swift
//  movs
//
//  Created by Emerson Victor on 02/12/19.
//  Copyright © 2019 emer. All rights reserved.
//

import UIKit

class MoviesController: UIViewController {
    
    typealias MoviesCoordinatorOutput = MovieDetailDelegate & MovieFavoriteDelegate
    
    // MARK: - Attributes
    lazy var screen = MoviesScreen(controller: self)
    let dataRepository = DataRepository()
    var movies: [Movie] = []
    var nextPage: Int = 1
    var searchFilteredBy = ""
    weak var coordinator: MoviesCoordinatorOutput?
    var moviesCollectionState: MoviesCollectionState = .loading {
        didSet {
            self.didSetCollectionState(to: self.moviesCollectionState)
        }
    }
    
    // MARK: - View controller life cycle
    override func loadView() {
        super.loadView()
        self.title = "Movies"
        self.view = self.screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .always
        self.moviesCollectionState = .loading
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.moviesCollectionState = .reloaded
    }
}

// MARK: - Handle collection view states
extension MoviesController {
    // MARK: - Collection view reloading from refresh controll
    @objc func reloadCollectionView(_ sender: UIRefreshControl) {
        self.moviesCollectionState = .reloaded
        sender.endRefreshing()
    }
    
    // MARK: - Did set collection view state
    func didSetCollectionState(to state: MoviesCollectionState) {
        switch state {
        case .loading:
            self.dataRepository.loadMovies(of: self.nextPage) { (bool) in
                self.moviesCollectionState = bool ? .loaded : .error(.loading)
            }
        case .loaded:
            self.nextPage += 1
            self.movies = self.dataRepository.localStorage.movies
        case .error(let errorType):
            switch errorType {
            case .loading:
                self.screen.presentErrorView(imageNamed: "Error",
                                             title: "An error has occurred. Please try again")
            case .filter:
                self.screen.presentErrorView(imageNamed: "EmptySearch",
                                             title: "Your search returned no results")
            }
        case .filtered:
            self.movies = self.dataRepository.localStorage.movies.filter({ (movie) -> Bool in
                return movie.title.lowercased().contains(self.searchFilteredBy.lowercased())
            })
            
            if self.movies.count == 0 {
                self.moviesCollectionState = .error(.filter)
            } else {
                self.screen.hideErrorView()
            }
        case .reloaded:
            self.screen.hideErrorView()
            self.movies = self.dataRepository.localStorage.movies
        }
        
        if state == .loaded || state == .reloaded || state == .filtered {
            DispatchQueue.main.async {
                self.screen.moviesCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - Collection state
    enum MoviesCollectionState: Equatable {
        case loading, loaded, filtered, reloaded
        case error(ErrorType)
    }
    
    enum ErrorType {
        case filter, loading
    }
}

// MARK: - Collection view data source
extension MoviesController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch self.moviesCollectionState {
        case .loading:
            return self.movies.count == 0 ? 1 : self.movies.count
        case .error:
            return 0
        case .loaded, .filtered, .reloaded:
            return self.movies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell",
                                                      for: indexPath) as! MovieCell
        
        if self.moviesCollectionState == .loading {
            return cell
        }

        cell.setup(with: self.movies[indexPath.row])
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self,
                                       action: #selector(didFavoriteMovie),
                                       for: .touchUpInside)
        return cell
    }
    
    // MARK: - Favorite action
    @objc func didFavoriteMovie(_ sender: FavoriteButton) {
        self.coordinator?.toggleFavorite(self.movies[sender.tag])
        sender.isSelected = !sender.isSelected
    }
}

// MARK: - Collection view delegate
extension MoviesController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.coordinator?.show(self.movies[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.row == self.movies.count - 1 && self.moviesCollectionState != .filtered {
            self.dataRepository.loadMovies(of: self.nextPage) { (bool) in
                self.moviesCollectionState = bool ? .loaded : .error(.loading)
            }
        }
    }
}

// MARK: - Search results updating
extension MoviesController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchFilteredBy = searchController.searchBar.text ?? ""
        // Set state according to search existence
        if self.searchFilteredBy.isEmpty {
            self.moviesCollectionState = .loading
        } else {
            self.moviesCollectionState = .filtered
        }
    }
}
