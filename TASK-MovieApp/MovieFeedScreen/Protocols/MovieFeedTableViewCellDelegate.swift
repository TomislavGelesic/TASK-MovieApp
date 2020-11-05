//
//  MovieFeedTableViewCellDelegate.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 05/11/2020.
//

import Foundation

protocol MovieFeedTableViewCellDelegate: class {
    
    func buttonTapped(button: ButtonSelection, id: Int)
}

