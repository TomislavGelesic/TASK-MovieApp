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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "Descritpion:"
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12)
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
        backgroundColor = .darkGray
        
        addSubviews([descriptionTitleLabel, descriptionLabel])
        
        contentViewConstraints()
        quoteTitleLabelConstraints()
        quoteLabelConstraints()
    }
    
    
    func fill(with description: String) {
        descriptionLabel.text = description
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
    
    private func quoteTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            descriptionTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            descriptionTitleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func quoteLabelConstraints() {
            NSLayoutConstraint.activate([
                descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 5),
                descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
                descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
                descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
            ])
    }
}
