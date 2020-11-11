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
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = "Quote:"
        return label
    }()
    
    let quoteLabel: UILabel = {
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

extension MovieDetailQuoteCell {
    
    func setupViews() {
        backgroundColor = .black
        
        contentView.addSubviews([quoteTitleLabel, quoteLabel])
        
        quoteTitleLabelConstraints()
        quoteLabelConstraints()
    }
    
    
    func fill(with quote: String) {
        quoteLabel.text = quote
    }
    
    //MARK: Constraints
    
    private func quoteTitleLabelConstraints() {
        quoteTitleLabel.snp.makeConstraints { (make) in
            make.top.leading.equalTo(contentView).offset(10)
            make.trailing.equalTo(contentView).offset(-10)
            make.bottom.equalTo(quoteLabel.snp.top).offset(-10)
        }
    }
    
    private func quoteLabelConstraints() {
        quoteLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(10)
            make.bottom.trailing.equalTo(contentView).offset(-10)
        }
    }
    
}
