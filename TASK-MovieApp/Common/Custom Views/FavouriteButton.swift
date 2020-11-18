//
//  MarkWatchedAndFavouriteStackView.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit
import SnapKit

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
    
        favouriteButton.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
}
