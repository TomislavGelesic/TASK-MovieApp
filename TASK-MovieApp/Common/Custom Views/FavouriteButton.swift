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
        button.setImage(UIImage(systemName: "favourites"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("FavouriteButton init(coder:) has not been implemented")
    }
    
}
