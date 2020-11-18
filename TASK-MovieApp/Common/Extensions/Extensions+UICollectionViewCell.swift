//
//  Extensions+UICollectionViewCell.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 12/11/2020.
//

import UIKit

extension UICollectionViewCell: ReusableView {
    
    static var reuseIdentifier: String {
        
        return String(describing: self)
    }
}
