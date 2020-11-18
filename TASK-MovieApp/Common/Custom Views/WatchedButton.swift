//
//  WatchedButton.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 28/10/2020.
//

import UIKit

class WatchedButton: UIButton {

    let watchedButton: UIButton = {
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
        fatalError("WatchedButton init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            watchedButton.topAnchor.constraint(equalTo: self.topAnchor),
            watchedButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            watchedButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            watchedButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
}
