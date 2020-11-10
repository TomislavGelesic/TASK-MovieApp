//
//  MovieDetailCellTableViewCell.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 28/10/2020.
//

import UIKit

class MovieDetailImageCell: UITableViewCell {
    //MARK: Properties
    let imageViewMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let gradientOverlay: ShadeGradientBottomToTopView = {
        let overlay = ShadeGradientBottomToTopView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        return overlay
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "left_arrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let favouriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "star_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let watchedButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "watched_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    var movieDetailImageCellDelegate: MovieDetailImageCellDelegate?
    
    //MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension MovieDetailImageCell {
    //MARK: Private Functions
    private func setupViews() {
        
        contentView.backgroundColor = .black
        
        contentView.addSubview(imageViewMovie)
        imageViewMovie.addSubview(gradientOverlay)
        contentView.addSubviews([backButton, favouriteButton, watchedButton])
        
        backButton.addTarget(self, action: #selector(backBarButtonTapped), for: .touchUpInside)
        favouriteButton.addTarget(self, action: #selector(favouriteBarButtonTapped), for: .touchUpInside)
        watchedButton.addTarget(self, action: #selector(watchedBarButtonTapped), for: .touchUpInside)
        
        contentViewConstraints()
        imageViewMovieConstraints()
        gradientOverlayConstraints()
        backButtonConstraints()
        favouriteButtonConstraints()
        watchedButtonConstraints()
    }
    
    @objc func backBarButtonTapped() {
        print("backButtonPressed")
        movieDetailImageCellDelegate?.backButtonTapped()
    }
    
    @objc func favouriteBarButtonTapped() {
        print("favouriteButtonPressed")
        movieDetailImageCellDelegate?.favouriteButtonTapped(cell: self)
    }
    
    @objc func watchedBarButtonTapped() {
        print("watchedButtonPressed")
        movieDetailImageCellDelegate?.watchedButtonTapped(cell: self)
    }
    
    func fill(with image: UIImage) {
        imageViewMovie.image = image
    }
    
    func updateButtonImage(for id: Int64, and type: ButtonType) {
    
        guard let status = CoreDataManager.sharedManager.checkButtonStatus(for: id, and: type) else { return }
     
        switch type {
        case .favourite:
            if status, let image = UIImage(named: "star_filled")?.withRenderingMode(.alwaysOriginal) {
                favouriteButton.setImage(image, for: .normal)
                return
            }
            if let image = UIImage(named: "star_unfilled")?.withRenderingMode(.alwaysOriginal){
                favouriteButton.setImage(image, for: .normal)
                return
            }
        case .watched:
            if status, let image = UIImage(named: "watched_filled")?.withRenderingMode(.alwaysOriginal) {
                watchedButton.setImage(image, for: .normal)
                return
            }
            if let image = UIImage(named: "watched_unfilled")?.withRenderingMode(.alwaysOriginal){
                watchedButton.setImage(image, for: .normal)
                return
            }
        }
    }
    
    //MARK: Constraints
    private func contentViewConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func imageViewMovieConstraints() {
        NSLayoutConstraint.activate([
            imageViewMovie.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageViewMovie.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageViewMovie.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageViewMovie.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageViewMovie.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func gradientOverlayConstraints() {
        NSLayoutConstraint.activate([
            gradientOverlay.topAnchor.constraint(equalTo: imageViewMovie.topAnchor),
            gradientOverlay.bottomAnchor.constraint(equalTo: imageViewMovie.bottomAnchor),
            gradientOverlay.leadingAnchor.constraint(equalTo: imageViewMovie.leadingAnchor),
            gradientOverlay.trailingAnchor.constraint(equalTo: imageViewMovie.trailingAnchor)
        ])
    }
    
    private func backButtonConstraints() {
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: gradientOverlay.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: gradientOverlay.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor)
        ])
    }
    
    private func favouriteButtonConstraints() {
        
        NSLayoutConstraint.activate([
            favouriteButton.topAnchor.constraint(equalTo: gradientOverlay.topAnchor, constant: 10),
            favouriteButton.trailingAnchor.constraint(equalTo: gradientOverlay.trailingAnchor, constant: -10),
            favouriteButton.widthAnchor.constraint(equalToConstant: 40),
            favouriteButton.heightAnchor.constraint(equalTo: favouriteButton.widthAnchor)
        ])
    }
    
    private func watchedButtonConstraints() {
        
        NSLayoutConstraint.activate([
            watchedButton.topAnchor.constraint(equalTo: gradientOverlay.topAnchor, constant: 10),
            watchedButton.trailingAnchor.constraint(equalTo: favouriteButton.leadingAnchor, constant: -10),
            watchedButton.widthAnchor.constraint(equalToConstant: 40),
            watchedButton.heightAnchor.constraint(equalTo: watchedButton.widthAnchor)
        ])
    }
}
