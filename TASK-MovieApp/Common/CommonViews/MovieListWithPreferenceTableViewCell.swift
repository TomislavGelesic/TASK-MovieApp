//
//  MovieCard.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 18.11.2020..
//


import UIKit
import SnapKit
import Combine

class MovieListWithPreferenceTableViewCell: UITableViewCell {
    
    var preferenceChanged: ((PreferenceType, Bool) -> ())?
    
    let imageViewMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
        favouriteButton.setImage(UIImage(named: "star_unfilled"), for: .normal)
        favouriteButton.setImage(UIImage(named: "star_filled"), for: .selected)
        favouriteButton.isHidden = true
        return favouriteButton
    }()
    
    let watchedButton: UIButton = {
        let watchedButton = UIButton()
        watchedButton.layer.cornerRadius = 20
        watchedButton.setImage(UIImage(named: "watched_unfilled"), for: .normal)
        watchedButton.setImage(UIImage(named: "watched_filled"), for: .selected)
        watchedButton.isHidden = true
        return watchedButton
    }()
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 20
        return view
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieListWithPreferenceTableViewCell {
    
    //MARK: Functions
    private func setupViews() {
        
        backgroundColor = .darkGray
        
        setupButtons()
        
        contentView.addSubview(container)
        container.addSubviews([titleLabel, descriptionLabel, imageViewMovie, watchedButton, favouriteButton])
        imageViewMovie.addSubview(gradientOverlay)
        gradientOverlay.addSubview(yearLabel)
        
        setupConstraints()
    }
    
    private func setupButtons() {
        
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        
        watchedButton.addTarget(self, action: #selector(watchedButtonTapped), for: .touchUpInside)
    }
    
    @objc func favouriteButtonTapped() {
        
        preferenceChanged?(.favourite, favouriteButton.isSelected)
    }
    
    @objc func watchedButtonTapped() {
        
        preferenceChanged?(.watched, watchedButton.isSelected)
    }
    
    func configure(with item: MovieRowItem, enable enabledButtons: [PreferenceType]) {
        
        imageViewMovie.setImage(with: Constants.MOVIE_API.IMAGE_BASE + Constants.MOVIE_API.IMAGE_SIZE + item.imagePath)
        
        yearLabel.text = item.year
    
        titleLabel.text = item.title
        
        descriptionLabel.text = item.overview
        
        for button in enabledButtons {
            
            switch button {
            case .favourite:
                setButtonImage(on: .favourite, selected: item.favourite)
                break
            case .watched:
                setButtonImage(on: .watched, selected: item.watched)
                break
            }
        }
    }
    
    func setButtonImage(on type: PreferenceType, selected: Bool) {
    
        switch type {
        case .favourite:
            favouriteButton.isSelected = selected
            favouriteButton.isHidden = false
            break
        case .watched:
            watchedButton.isSelected = selected
            watchedButton.isHidden = false
            break
        }
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
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }
    }
    
    private func imageViewConstraints() {
       
        imageViewMovie.snp.makeConstraints { (make) in
            make.top.bottom.leading.equalTo(container)
            make.width.height.equalTo(160)
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
            make.top.equalTo(imageViewMovie).offset(10)
            make.leading.equalTo(imageViewMovie.snp.trailing).offset(10)
            make.trailing.equalTo(container).offset(-10)
        }
    }
    
    private func descriptionLabelCOnstraints() {
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(imageViewMovie.snp.trailing).offset(10)
            make.trailing.equalTo(container).offset(-10)
        }
    }
    
    private func favouriteButtonConstraints() {
        favouriteButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(container).offset(-5)
            make.trailing.equalTo(container).offset(-15)
            make.width.height.equalTo(50)
        }
    }
    
    private func watchedButtonConstraints() {
        watchedButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(container).offset(-5)
            make.trailing.equalTo(favouriteButton.snp.leading).offset(-20)
            make.width.height.equalTo(50)
        }
    }
}
