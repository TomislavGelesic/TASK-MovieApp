//
//  Extension+UIView.swift
//  TASK-NewsReader
//
//  Created by Tomislav Gelesic on 02/11/2020.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
    
}
