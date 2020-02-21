//
//  FavoritesController.swift
//  movs
//
//  Created by Emerson Victor on 02/12/19.
//  Copyright © 2019 emer. All rights reserved.
//

import UIKit

class FavoritesController: UIViewController {
    
    // MARK: - Coordinator
    typealias FavoritesCoordinatorOutput = MovieDetailDelegate & MovieFavoriteDelegate & FavoritesDelegate
    weak var coordinator: FavoritesCoordinatorOutput?
    
    // MARK: - Navigation item
    lazy var filterButton: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(goToFilters))
        
        return item
    }()
    
    // MARK: - Attributes
    lazy var screen = FavoritesScreen(controller: self)
    let dataRepository = DataRepository()
    var searchFilteredBy = ""
    var filters: [FilterType: String] = [:]
    var favorites: [Movie] = [] {
        didSet {
            self.favorites.sort { (lmovie, rmovie) -> Bool in
                return lmovie.title < rmovie.title
            }
        }
    }
    
    // MARK: - Collection state
    var favoritesCollectionState: FavoritesCollectionState = .loading {
        didSet {
            self.didSetCollectionState(to: self.favoritesCollectionState)
        }
    }
    
    // MARK: - View controller life cycle
    override func loadView() {
        super.loadView()
        self.title = "Favorites"
        self.view = self.screen
        self.navigationItem.rightBarButtonItem = self.filterButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .always
        self.favoritesCollectionState = .loading
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.favoritesCollectionState = .loading
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Table view reloading from refresh controll
    @objc func reloadTableView(_ sender: UIRefreshControl) {
        self.favoritesCollectionState = .loading
        sender.endRefreshing()
    }
    
    // MARK: - Filter actions
    @objc func goToFilters() {
        self.coordinator?.showFilters()
    }
    
    @objc func removeFilters() {
        self.coordinator?.removeFilters()
        self.filters = [:]
        self.searchFilteredBy = ""
        self.screen.hideButton()
        self.favoritesCollectionState = .loaded
    }
}

// MARK: - Handle collection view states
extension FavoritesController {
    // MARK: - Collection view reloading from refresh controll
    @objc func reloadCollectionView(_ sender: UIRefreshControl) {
        self.favoritesCollectionState = .loading
        sender.endRefreshing()
    }
    
    // MARK: - Did set collection view state
    func didSetCollectionState(to state: FavoritesCollectionState) {
        switch state {
        case .loading:
            self.screen.hideErrorView()
            self.dataRepository.loadFavorites { (bool) in
                // Set state according to filter existence and load result
                if bool && !(self.filters.isEmpty && self.searchFilteredBy.isEmpty) {
                    self.favoritesCollectionState = .filtered
                } else {
                    self.favoritesCollectionState = bool ? .loaded : .error(.loading)
                    self.screen.hideButton()
                }
            }
        case .loaded:
            self.favorites = self.dataRepository.localStorage.favorites
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
            self.favorites = self.applyFilters(into: self.dataRepository.localStorage.favorites)
            
            // Show button if has filters
            if !self.filters.isEmpty {
                self.screen.showButton()
            }
            
            // Show exeption screen if filters results is empty
            if self.favorites.count == 0 {
                self.screen.presentErrorView(imageNamed: "EmptySearch",
                                             title: "Your search returned no results")
            } else {
                self.screen.hideErrorView()
            }
            
            DispatchQueue.main.async {
                self.screen.favoritesTableView.reloadData()
            }
        }
        
        if state == .loaded || state == .filtered {
            DispatchQueue.main.async {
                self.screen.favoritesTableView.reloadData()
            }
        }
    }
    
    // MARK: - Collection state
    enum FavoritesCollectionState: Equatable {
        case loading, loaded, filtered
        case error(ErrorType)
    }
    
    enum ErrorType {
        case filter, loading
    }
}

// MARK: - Table view data source
extension FavoritesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.favoritesCollectionState {
        case .loading:
            return self.favorites.count == 0 ? 1 : self.favorites.count
        case .error:
            return 0
        case .loaded, .filtered:
            return self.favorites.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.favoritesCollectionState == .loading {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteMovieCell", for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteMovieCell",
                                                 for: indexPath) as? FavoriteMovieCell
        let movie = self.favorites[indexPath.row]
        cell?.setup(with: movie)
        return cell!
    }
}

// MARK: - Table view delegate
extension FavoritesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 176
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let movie = self.favorites.remove(at: indexPath.row)
            movie.isFavorite = false
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.coordinator?.show(self.favorites[indexPath.row])
    }
}

// MARK: - Filters
extension FavoritesController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchFilteredBy = searchController.searchBar.text ?? ""
        // Set state according to filter existence
        if self.searchFilteredBy.isEmpty && self.filters.isEmpty {
            self.favoritesCollectionState = .loaded
        } else {
            self.favoritesCollectionState = .filtered
        }
    }
    
    func applyFilters(into favorites: [Movie]) -> [Movie] {
        var movies = favorites
        
        // Applu filters
        movies = movies.filter({ (movie) -> Bool in
            var isMatching = true
            
            for (key, value) in self.filters {
                if !isMatching {
                    break
                }
                
                isMatching = movie.has(value, for: key)
            }
            return isMatching
        })
        
        // Apply search
        if self.searchFilteredBy != "" {
            movies = movies.filter({ (movie) -> Bool in
                return movie.title.lowercased().contains(self.searchFilteredBy.lowercased())
            })
        }
        
        return movies
    }
}
