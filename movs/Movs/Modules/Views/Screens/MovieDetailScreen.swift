//
//  MovieDetailScreen.swift
//  movs
//
//  Created by Emerson Victor on 02/12/19.
//  Copyright © 2019 emer. All rights reserved.
//

import UIKit

class MovieDetailScreen: UIView {
    // MARK: - Subviews
    lazy var posterImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var releaseDate: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        view.textColor = .secondaryLabel
        return view
    }()
    
    lazy var title: UILabel = {
        let view = UILabel()
        view.numberOfLines = 3
        view.textColor = .label
        view.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        return view
    }()
    
    lazy var genres: UILabel = {
        let view = UILabel()
        view.textColor = .secondaryLabel
        view.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = FavoriteButton(baseTintColor: .label)
        return button
    }()
    
    lazy var synopsis: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.isEditable = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.textContainer.lineFragmentPadding = 0
        view.textContainerInset = .zero
        view.textColor = .label
        return view
    }()
    
    // MARK: - Stacks
    lazy var titleContainer: UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        container.alignment = .leading
        return container
    }()
    
    lazy var favoriteContainer: UIStackView = {
        let container = UIStackView()
        container.axis = .horizontal
        container.alignment = .center
        container.distribution = .fill
        return container
    }()
    
    // MARK: - Initializers
    required init(frame: CGRect = .zero, movie: Movie) {
        super.init(frame: frame)
        self.setupView()
        self.setupContent(with: movie)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieDetailScreen: CodeView {
    func buildViewHierarchy() {
        // Title container
        self.titleContainer.addArrangedSubview(self.releaseDate)
        self.titleContainer.addArrangedSubview(self.title)
        self.titleContainer.addArrangedSubview(self.genres)
        
        // Favorite container
        self.favoriteContainer.addArrangedSubview(self.titleContainer)
        self.favoriteContainer.addArrangedSubview(self.favoriteButton)
        
        // View
        self.addSubview(self.posterImage)
        self.addSubview(self.favoriteContainer)
        self.addSubview(self.synopsis)
    }
    
    func setupConstraints() {
        self.posterImage.snp.makeConstraints { (make) in
            let deviceBouds = UIScreen.main.bounds
            make.width.equalTo(deviceBouds.width)
            make.height.equalTo(deviceBouds.height*0.55)
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        self.favoriteContainer.snp.makeConstraints { (make) in
            make.top.equalTo(self.posterImage.snp.bottom).offset(16)
            make.right.equalToSuperview().inset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        self.favoriteButton.snp.makeConstraints { (make) in
            make.height.equalTo(36)
            make.width.equalTo(40)
        }
        
        self.synopsis.snp.makeConstraints { (make) in
            make.top.equalTo(self.favoriteContainer.snp.bottom).offset(16)
            make.right.equalToSuperview().inset(16)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func setupAdditionalConfiguration() {
        self.backgroundColor = .systemGray6
    }
    
    func setupContent(with movie: Movie) {
        self.posterImage.image = movie.posterImage ?? UIImage(named: "PosterUnavailabe")
        self.releaseDate.text = movie.releaseDate
        self.title.text = movie.title
        let genres = movie.genres.sorted()
        self.genres.text = genres.dropFirst().reduce(genres[0], { (result, movie) -> String in
            return "\(result), \(movie)"
        })
        self.favoriteButton.isSelected = movie.isFavorite
        self.synopsis.text = movie.synopsis
    }
}
