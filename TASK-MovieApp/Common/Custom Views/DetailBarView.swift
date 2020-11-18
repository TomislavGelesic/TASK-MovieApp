//
//  DetailBarView.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 05/11/2020.
//

import UIKit

class DetailBarView: UIView {
    
    let backBarButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "left_arrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let favouriteBarButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "star_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let watchedBarButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "watched_unfilled")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([backBarButton, favouriteBarButton, watchedBarButton])
        setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("FavouriteButton init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backBarButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            backBarButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            backBarButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            backBarButton.heightAnchor.constraint(equalToConstant: 40),
            backBarButton.widthAnchor.constraint(equalTo: backBarButton.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            favouriteBarButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            favouriteBarButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            favouriteBarButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            favouriteBarButton.heightAnchor.constraint(equalToConstant: 40),
            favouriteBarButton.widthAnchor.constraint(equalTo: backBarButton.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            watchedBarButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            watchedBarButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            watchedBarButton.trailingAnchor.constraint(equalTo: favouriteBarButton.leadingAnchor, constant: -10),
            watchedBarButton.heightAnchor.constraint(equalToConstant: 40),
            watchedBarButton.widthAnchor.constraint(equalTo: backBarButton.heightAnchor)
        ])
        
    }

}
