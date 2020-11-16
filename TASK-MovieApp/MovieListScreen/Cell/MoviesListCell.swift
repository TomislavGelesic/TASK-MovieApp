//
//  MovieTableViewCell.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit
import SnapKit
import Kingfisher

class MoviesListCell: UICollectionViewCell {
    
    //MARK: Properties
    
    var movieListCellDelegate: MovieListCellDelegate?
    
    var movie: Movie?
    
    let imageViewMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let gradientOverlay: ShadeGradientTopToBottomView = {
        let overlay = ShadeGradientTopToBottomView()
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
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 20
        return view
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

extension MoviesListCell {
    
    private func setupViews() {
        
        contentView.backgroundColor = .darkGray
        contentView.addSubview(container)
        container.addSubviews([titleLabel, descriptionLabel, imageViewMovie, watchedButton, favouriteButton])
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
        
        movieListCellDelegate?.favouriteButtonTapped(cell: self)
    }
    
    @objc func watchedButtonTapped() {
        
        movieListCellDelegate?.watchedButtonTapped(cell: self)
    }
    
    func fill(with movie: Movie) {
        
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
        
        if movie.favourite == true {
            favouriteButton.setImage(UIImage(named: "star_filled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else {
            favouriteButton.setImage(UIImage(named: "star_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        if movie.watched == true {
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
        
        containerConstraints()
        titleLabelCOnstraints()
        descriptionLabelCOnstraints()
        imageViewConstraints()
        overlayConstraints()
        yearLabelConstraints()
        favouriteButtonConstraints()
        watchedButtonConstraints()
    }
    
    private func containerConstraints() {
        
        container.snp.makeConstraints { (make) in
            make.top.leading.equalTo(contentView).offset(5)
            make.bottom.trailing.equalTo(contentView).offset(-5)
        }
    }
    
    private func imageViewConstraints() {
        
        imageViewMovie.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(container)
            make.height.equalTo(160)
        }
    }
    
    private func overlayConstraints() {
        
        gradientOverlay.snp.makeConstraints { (make) in
            make.edges.equalTo(imageViewMovie)
        }
    }
    
    private func yearLabelConstraints() {
        
        yearLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(gradientOverlay)
            make.centerX.equalTo(gradientOverlay)
        }
    }
    
    private func titleLabelCOnstraints() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageViewMovie.snp.bottom).offset(10)
            make.leading.trailing.equalTo(container)
        }
    }
    
    private func descriptionLabelCOnstraints() {
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(container)        }
    }
    
    private func favouriteButtonConstraints() {
        
        favouriteButton.snp.makeConstraints { (make) in
            make.top.trailing.equalTo(container).offset(10)
            make.width.height.equalTo(50)
        }
    }
    
    private func watchedButtonConstraints() {
        
        watchedButton.snp.makeConstraints { (make) in
            make.top.equalTo(container).offset(10)
            make.leading.equalTo(favouriteButton.snp.trailing).offset(10)
            make.width.height.equalTo(50)
        }
    }
    
}
