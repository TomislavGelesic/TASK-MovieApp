//
//  MovieFavouriteTableViewCellDelegate.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 05/11/2020.
//

import Foundation

protocol MovieFavouriteTableViewCellDelegate: class {
    
    func buttonTapped(button: ButtonSelection, id: Int)
}
