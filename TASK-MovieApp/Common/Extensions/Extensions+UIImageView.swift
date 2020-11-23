//
//  Extensions+UIImage.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 22.11.2020..
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage (url: URL? ) {
        if let url = url {
            self.kf.setImage(with: url)
        }
    }
}
