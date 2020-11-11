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
        label.text = "Descritpion:"
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
    
    
    func fill(with description: String) {
        descriptionLabel.text = description
    }
    
    //MARK: Constraints
    
    private func quoteTitleLabelConstraints() {
        descriptionTitleLabel.snp.makeConstraints { (make) in
            make.top.leading.equalTo(contentView).offset(10)
            make.trailing.equalTo(contentView).offset(-10)
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-10)
        }
    }
    
    private func quoteLabelConstraints() {
        descriptionLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(10)
            make.bottom.trailing.equalTo(contentView).offset(-10)
        }
    }
}
