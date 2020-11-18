//
//  WatchedButton.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 28/10/2020.
//

import UIKit
import SnapKit

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
    
        watchedButton.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
}
