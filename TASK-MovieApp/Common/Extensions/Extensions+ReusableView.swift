//
//  Extensions+ReusableView.swift
//  TASK-NewsReader
//
//  Created by Tomislav Gelesic on 26/10/2020.
//

import UIKit

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
