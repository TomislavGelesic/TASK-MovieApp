//
//  MovieFeedTableViewCellDelegate.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 03/11/2020.
//

import Foundation


protocol MovieFeedTableViewCellDelegate: class {
    func watchedButtonTapped(id: Int)
    func favouriteButtonTapped(id: Int)
}
