//
//  MovieDetailCellTableViewCell.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 28/10/2020.
//

import UIKit
import SnapKit

class MovieDetailImageCell: UITableViewCell {
    
    //MARK: Properties
    
    var movieDetailImageCellDelegate: MovieDetailImageCellDelegate?
    
    let imageViewMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let gradientOverlay: ShadeGradientOverlayView = {
        let overlay = ShadeGradientOverlayView(direction: .bottomToTop)
        return overlay
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "left_arrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let favouriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "star_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let watchedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "watched_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
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
        
        imageViewMovieConstraints()
        gradientOverlayConstraints()
        backButtonConstraints()
        favouriteButtonConstraints()
        watchedButtonConstraints()
    }
    
    @objc func backBarButtonTapped() {
        
        movieDetailImageCellDelegate?.backButtonTapped()
    }
    
    @objc func favouriteBarButtonTapped() {
        
        movieDetailImageCellDelegate?.favouriteButtonTapped(cell: self)
    }
    
    @objc func watchedBarButtonTapped() {
        
        movieDetailImageCellDelegate?.watchedButtonTapped(cell: self)
    }
    
    func updateButtonImage(for id: Int64, and type: ButtonType) {
    
        guard let status = CoreDataManager.sharedInstance.checkButtonStatus(for: id, and: type) else { return }
     
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
    
    private func imageViewMovieConstraints() {
        
        imageViewMovie.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
            make.height.equalTo(300)
        }
    }
    
    private func gradientOverlayConstraints() {
        
        gradientOverlay.snp.makeConstraints { (make) in
            make.edges.equalTo(imageViewMovie)
        }
    }
    
    private func backButtonConstraints() {
        
        backButton.snp.makeConstraints { (make) in
            make.top.leading.equalTo(gradientOverlay).offset(10)
            make.width.height.equalTo(40)
        }
    }
    
    private func favouriteButtonConstraints() {
        
        favouriteButton.snp.makeConstraints { (make) in
            make.top.trailing.equalTo(gradientOverlay).inset(UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10))
            make.width.height.equalTo(40)
        }
    }
    
    private func watchedButtonConstraints() {
        
        watchedButton.snp.makeConstraints { (make) in
            make.top.equalTo(gradientOverlay).offset(10)
            make.trailing.equalTo(favouriteButton.snp.leading).offset(-10)
            make.width.height.equalTo(40)
        }
    }
}
