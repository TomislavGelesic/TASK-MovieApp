//
//  SimilarMoviesCollectionViewCell.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 22.12.2020..
//

import UIKit
import SnapKit
import Kingfisher
import Combine

class SimilarMoviesCollectionViewCell: UICollectionViewCell {
    
    let imageViewMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SimilarMoviesCollectionViewCell {
    
    private func setupViews() {
        
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 20
        contentView.addSubview(imageViewMovie)
        imageViewMovie.addSubview(yearLabel)
        
        setupConstraints()
    }
    
    func configure(with item: MovieRowItem) {
        
        imageViewMovie.setImage(with: Constants.MOVIE_API.IMAGE_BASE + Constants.MOVIE_API.IMAGE_SIZE + item.imagePath)
        
        yearLabel.text = item.year
        
    }
    
    //MARK: Constraints
    private func setupConstraints() {
        
        imageViewConstraints()
        yearLabelConstraints()
    }
    
    private func imageViewConstraints() {
        
        imageViewMovie.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    private func yearLabelConstraints() {
        
        yearLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(imageViewMovie)
            make.centerX.equalTo(imageViewMovie)
        }
    }
}


