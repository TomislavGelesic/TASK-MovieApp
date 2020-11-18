//
//  FavouriteMoviesFeedCell.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 06/11/2020.
//

import UIKit

class FavouriteMoviesFeedCell: UITableViewCell {
    
    //MARK: Properties
    let imageViewMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let gradientOverlay: ShadeGradientTopToBottomView = {
        let overlay = ShadeGradientTopToBottomView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        return overlay
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        return label
    }()
    
    let favouriteButton: UIButton = {
        let favouriteButton = UIButton()
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.layer.cornerRadius = 20
        favouriteButton.setImage(UIImage(named: "star_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return favouriteButton
    }()
    
    let watchedButton: UIButton = {
        let watchedButton = UIButton()
        watchedButton.translatesAutoresizingMaskIntoConstraints = false
        watchedButton.layer.cornerRadius = 20
        watchedButton.setImage(UIImage(named: "watched_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return watchedButton
    }()
    
    let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 20
        return view
    }()
    
    var favouriteMoviesFeedCellDelegate: FavouriteMoviesFeedCellDelegate?
    var movie: Movie?
    
    //MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FavouriteMoviesFeedCell {
    
    //MARK: Functions
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
        favouriteMoviesFeedCellDelegate?.favouriteButtonTapped(cell: self)
    }
    
    @objc func watchedButtonTapped() {
        favouriteMoviesFeedCellDelegate?.watchedButtonTapped(cell: self)
    }
    
    func fill(with movie: Movie) {
        
        self.movie = movie
        
        if let imagePath = movie.posterPath {
            imageViewMovie.image = UIImage(url: URL(string: Constants.MOVIE_API.IMAGE_BASE + Constants.MOVIE_API.IMAGE_SIZE + imagePath))
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
        let year = dateFormatter.string(from: date)
        return year
    }
    
    
    
    //MARK: Constraints
    private func setupConstraints() {
        contentViewConstraints()
        containerConstraints()
        titleLabelCOnstraints()
        descriptionLabelCOnstraints()
        imageViewConstraints()
        overlayConstraints()
        yearLabelConstraints()
        favouriteButtonConstraints()
        watchedButtonConstraints()
    }
    
    private func contentViewConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func containerConstraints() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
    }
    
    private func imageViewConstraints() {
        
        let imageViewMovieHeightConstraint = imageViewMovie.heightAnchor.constraint(equalToConstant: 160)
        imageViewMovieHeightConstraint.priority = UILayoutPriority(999)
        imageViewMovieHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            imageViewMovie.topAnchor.constraint(equalTo: container.topAnchor),
            imageViewMovie.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            imageViewMovie.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageViewMovie.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    private func overlayConstraints() {
        NSLayoutConstraint.activate([
            gradientOverlay.topAnchor.constraint(equalTo: imageViewMovie.topAnchor),
            gradientOverlay.bottomAnchor.constraint(equalTo: imageViewMovie.bottomAnchor),
            gradientOverlay.leadingAnchor.constraint(equalTo: imageViewMovie.leadingAnchor),
            gradientOverlay.trailingAnchor.constraint(equalTo: imageViewMovie.trailingAnchor)
        ])
    }
    
    private func yearLabelConstraints() {
        NSLayoutConstraint.activate([
            yearLabel.bottomAnchor.constraint(equalTo: gradientOverlay.bottomAnchor),
            yearLabel.centerXAnchor.constraint(equalTo: gradientOverlay.centerXAnchor)
        ])
    }
    
    private func titleLabelCOnstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageViewMovie.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: imageViewMovie.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10)
        ])
    }
    
    private func descriptionLabelCOnstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: imageViewMovie.trailingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10)
        ])
    }
    
    private func favouriteButtonConstraints() {
        NSLayoutConstraint.activate([
            favouriteButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5),
            favouriteButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
            favouriteButton.heightAnchor.constraint(equalToConstant: 50),
            favouriteButton.widthAnchor.constraint(equalTo: favouriteButton.heightAnchor)
        ])
    }
    
    private func watchedButtonConstraints() {
        NSLayoutConstraint.activate([
            watchedButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5),
            watchedButton.trailingAnchor.constraint(equalTo: favouriteButton.leadingAnchor, constant: -20),
            watchedButton.heightAnchor.constraint(equalToConstant: 50),
            watchedButton.widthAnchor.constraint(equalTo: favouriteButton.heightAnchor)
        ])
    }
    
}
