//
//  MarkWatchedAndFavouriteStackView.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit

class FavouriteButton: UIButton {
    
    let favouriteButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("FavouriteButton init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            favouriteButton.topAnchor.constraint(equalTo: self.topAnchor),
            favouriteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            favouriteButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            favouriteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
}
