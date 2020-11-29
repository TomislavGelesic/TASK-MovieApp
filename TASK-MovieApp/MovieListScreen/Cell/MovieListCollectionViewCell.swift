//
//  MovieTableViewCell.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit
import SnapKit
import Kingfisher

class MovieListCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    
    var movieListCollectionViewCellDelegate: MovieListCollectionViewCellDelegate?
    
    var movie: Movie?
    
    let imageViewMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let gradientOverlay: ShadeGradientOverlayView = {
        let overlay = ShadeGradientOverlayView(direction: .topToBottom)
        return overlay
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        return label
    }()
    
    let favouriteButton: UIButton = {
        let favouriteButton = UIButton()
        favouriteButton.layer.cornerRadius = 20
        favouriteButton.setImage(UIImage(named: "star_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return favouriteButton
    }()
    
    let watchedButton: UIButton = {
        let watchedButton = UIButton()
        watchedButton.layer.cornerRadius = 20
        watchedButton.setImage(UIImage(named: "watched_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return watchedButton
    }()
    
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Functions

extension MovieListCollectionViewCell {
    
    private func setupViews() {
        
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 20
        contentView.addSubviews([titleLabel, descriptionLabel, imageViewMovie, watchedButton, favouriteButton])
        imageViewMovie.addSubview(gradientOverlay)
        gradientOverlay.addSubview(yearLabel)
        
        setupButtons()
        
        setupConstraints()
    }
    
    private func setupButtons() {
        
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        watchedButton.addTarget(self, action: #selector(watchedButtonTapped), for: .touchUpInside)
    }
    
    @objc func favouriteButtonTapped() {
        
        movieListCollectionViewCellDelegate?.favouriteButtonTapped(cell: self)
    }
    
    @objc func watchedButtonTapped() {
        
        movieListCollectionViewCellDelegate?.watchedButtonTapped(cell: self)
    }
    
    func configure(with movie: Movie) {
        
        self.movie = movie
        
        if let imagePath = movie.posterPath,
           let url = URL(string: Constants.MOVIE_API.IMAGE_BASE + Constants.MOVIE_API.IMAGE_SIZE + imagePath) {
            
            imageViewMovie.kf.setImage(with: url)
        }
        else {
            imageViewMovie.backgroundColor = .cyan
        }
        if let date = movie.releaseDate {
            yearLabel.text = getReleaseYear(releaseDate: date)
        }
        titleLabel.text = movie.title
        descriptionLabel.text = movie.overview
        
        if movie.favourite {
            favouriteButton.setImage(UIImage(named: "star_filled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else {
            favouriteButton.setImage(UIImage(named: "star_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        if movie.watched {
            watchedButton.setImage(UIImage(named: "watched_filled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else {
            watchedButton.setImage(UIImage(named: "watched_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    private func getReleaseYear(releaseDate: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: releaseDate) else { return "-1" }
        
        dateFormatter.dateFormat = "yyyy"
        
        return dateFormatter.string(from: date)
    }

    
    
    //MARK: Constraints
    private func setupConstraints() {
        
        titleLabelCOnstraints()
        descriptionLabelCOnstraints()
        imageViewConstraints()
        overlayConstraints()
        favouriteButtonConstraints()
        yearLabelConstraints()
        watchedButtonConstraints()
    }
    
    private func imageViewConstraints() {
        
        imageViewMovie.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(contentView.frame.height * 3/5)
        }
    }
    
    private func overlayConstraints() {
        
        gradientOverlay.snp.makeConstraints { (make) in
            make.edges.equalTo(imageViewMovie)
        }
    }
    
    private func favouriteButtonConstraints() {
        
        favouriteButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(gradientOverlay)
            make.trailing.equalTo(gradientOverlay).offset(-5)
            make.width.height.equalTo(50)
        }
    }
    
    private func yearLabelConstraints() {
        
        yearLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(gradientOverlay)
            make.centerX.equalTo(gradientOverlay)
        }
    }
    
    private func watchedButtonConstraints() {
        
        watchedButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(gradientOverlay)
            make.leading.equalTo(gradientOverlay).offset(5)
            make.width.height.equalTo(50)
        }
    }
    
    private func titleLabelCOnstraints() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageViewMovie.snp.bottom).offset(10)
            make.leading.equalTo(contentView).offset(10)
            make.trailing.equalTo(contentView).offset(-10)
        }
    }
    
    private func descriptionLabelCOnstraints() {
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)            
            make.leading.equalTo(contentView).offset(10)
            make.trailing.equalTo(contentView).offset(-10)
        }
    }
    
}
