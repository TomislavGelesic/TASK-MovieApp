//
//  MovieDetailDescriptionCell.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 28/10/2020.
//

import UIKit

class MovieDetailDescriptionCell: UITableViewCell {
    
    let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = "Description:"
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("MovieDetailTitleCell required init failed...")
    }
}

extension MovieDetailDescriptionCell {
    
    func setupViews() {
        
        backgroundColor = .black
        
        contentView.addSubviews([descriptionTitleLabel, descriptionLabel])
        
        quoteTitleLabelConstraints()
        quoteLabelConstraints()
    }
    
    
    func configure(with description: String) {
        
        descriptionLabel.text = description
    }
    
    //MARK: Constraints
    
    private func quoteTitleLabelConstraints() {
        
        descriptionTitleLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(contentView).inset(UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-10)
        }
    }
    
    private func quoteLabelConstraints() {
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalTo(contentView).inset(UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10))
        }
    }
}
