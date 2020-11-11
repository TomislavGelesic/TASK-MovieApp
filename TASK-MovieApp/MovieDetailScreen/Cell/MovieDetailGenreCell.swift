//
//  MovieDetailGenreCell.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 28/10/2020.
//

import UIKit
import SnapKit

class MovieDetailGenreCell: UITableViewCell {

    let genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14)
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

extension MovieDetailGenreCell {
    
    func setupViews() {
        backgroundColor = .black
        
        contentView.addSubview(genreLabel)
        
        titleLabelConstraints()
    }
    
    
    func fill(with genres: String) {
        genreLabel.text = genres
    }
    
    //MARK: Constraints
    
    private func titleLabelConstraints() {
        genreLabel.snp.makeConstraints { (make) in
            make.top.leading.equalTo(contentView).offset(10)
            make.bottom.trailing.equalTo(contentView).offset(-10)
        }
    }
    
}
