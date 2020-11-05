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
    
    let barView: DetailBarView = {
        let view = DetailBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var movieDetailImageCellDelegate: MovieDetailImageCellDelegate?
    var movieID: Int = -1
    
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
        gradientOverlay.addSubview(barView)

        barView.backBarButton.addTarget(self, action: #selector(backBarButtonTapped), for: .touchUpInside)
        barView.favouriteBarButton.addTarget(self, action: #selector(favouriteBarButtonTapped), for: .touchUpInside)
        barView.watchedBarButton.addTarget(self, action: #selector(watchedBarButtonTapped), for: .touchUpInside)
        
        contentViewConstraints()
        imageViewMovieConstraints()
        gradientOverlayConstraints()
        barViewConstraints()
    }
    
    @objc func backBarButtonTapped() {
        print("backButtonPressed")
        movieDetailImageCellDelegate?.backButtonTapped()
    }
    
    @objc func favouriteBarButtonTapped() {
        movieDetailImageCellDelegate?.favouriteButtonTapped()
    }
    
    @objc func watchedBarButtonTapped() {
        //should reload tableview or detail view button image
        movieDetailImageCellDelegate?.watchedButtonTapped()
    }
    
    func fill(with image: UIImage, forID id: Int) {
        imageViewMovie.image = image
        movieID = id
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
    
    private func barViewConstraints() {
        NSLayoutConstraint.activate([
            barView.topAnchor.constraint(equalTo: gradientOverlay.topAnchor),
            barView.leadingAnchor.constraint(equalTo: gradientOverlay.leadingAnchor, constant: 10),
            barView.trailingAnchor.constraint(equalTo: gradientOverlay.trailingAnchor, constant:  -10),
            barView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}
