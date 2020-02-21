//
//  MovieDetailController.swift
//  movs
//
//  Created by Emerson Victor on 02/12/19.
//  Copyright © 2019 emer. All rights reserved.
//

import UIKit

class MovieDetailController: UIViewController {
    
    typealias MovieDetailCoordinatorOutput = MovieFavoriteDelegate & Coordinator
    weak var coordinator: MovieDetailCoordinatorOutput?
    
    // MARK: - Attributes
    let movie: Movie
    var screen: MovieDetailScreen
    
    // MARK: - Initializers
    required init(movie: Movie) {
        self.movie = movie
        self.screen = MovieDetailScreen(movie: movie)
        super.init(nibName: nil, bundle: nil)
        self.screen.favoriteButton.addTarget(self,
                                             action: #selector(didFavoriteMovie),
                                             for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View controller life cycle
    override func loadView() {
        super.loadView()
        self.view = self.screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - Favorite action
    @objc func didFavoriteMovie(_ sender: FavoriteButton) {
        self.coordinator?.toggleFavorite(self.movie)
        sender.isSelected = !sender.isSelected
    }
}
