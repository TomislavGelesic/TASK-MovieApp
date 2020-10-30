//
//  MovieTableViewCell.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit

class MovieFeedTableViewCell: UITableViewCell {
    
    //MARK: Properties
    let imageViewMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let gradientOverlay: ShadeGradientTopToBottomView = {
        let overlay = ShadeGradientTopToBottomView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        return overlay
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let favouriteButton: UIButton = {
        let favouriteButton = UIButton()
        favouriteButton.backgroundColor = .blue
        favouriteButton.setTitle("F", for: .normal)
        favouriteButton.layer.cornerRadius = 20
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        return favouriteButton
    }()
    
    let watchedButton: UIButton = {
        let watchedButton = UIButton()
        watchedButton.backgroundColor = .red
        watchedButton.setTitle("W", for: .normal)
        watchedButton.layer.cornerRadius = 20
        watchedButton.translatesAutoresizingMaskIntoConstraints = false
        return watchedButton
    }()
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    //MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieFeedTableViewCell {
    
    //MARK: Private functions
    private func setupViews() {
        
        contentView.backgroundColor = .darkGray
        contentView.addSubview(container)
        
        container.addSubview(titleLabel)
        container.addSubview(descriptionLabel)
        container.addSubview(imageViewMovie)
        container.addSubview(watchedButton)
        container.addSubview(favouriteButton)
        
        imageViewMovie.addSubview(gradientOverlay)
        gradientOverlay.addSubview(yearLabel)
        
        setupConstraints()
    }
    
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
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageViewMovie.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10)
        ])
    }
    
    private func descriptionLabelCOnstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.bottomAnchor.constraint(equalTo: favouriteButton.topAnchor, constant: -10),
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
