//
//  MovieDetailQuoteCell.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 28/10/2020.
//

import UIKit

class MovieDetailQuoteCell: UITableViewCell {

    let quoteTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "Quote:"
        return label
    }()
    
    let quoteLabel: UILabel = {
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

extension MovieDetailQuoteCell {
    
    func setupViews() {
        backgroundColor = .darkGray
        
        addSubviews([quoteTitleLabel, quoteLabel])
        
        contentViewConstraints()
        quoteTitleLabelConstraints()
        quoteLabelConstraints()
    }
    
    
    func fill(with quote: String) {
        quoteLabel.text = quote
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
            quoteTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            quoteTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            quoteTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            quoteTitleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func quoteLabelConstraints() {
            NSLayoutConstraint.activate([
                quoteLabel.topAnchor.constraint(equalTo: quoteTitleLabel.bottomAnchor, constant: 5),
                quoteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
                quoteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
                quoteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
            ])        
    }
    
}
