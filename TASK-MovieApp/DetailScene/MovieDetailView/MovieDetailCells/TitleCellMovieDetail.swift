//
//  MovieDetailTitleCellTableViewCell.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 28/10/2020.
//

import UIKit
import SnapKit

class TitleCellMovieDetail: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.numberOfLines = 2
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

extension TitleCellMovieDetail {
    
    func setupViews() {
        backgroundColor = .black
        
        contentView.addSubview(titleLabel)
        
        titleLabelConstraints()
    }
    
    //MARK: Constraints
    private func titleLabelConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(10)        }
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
