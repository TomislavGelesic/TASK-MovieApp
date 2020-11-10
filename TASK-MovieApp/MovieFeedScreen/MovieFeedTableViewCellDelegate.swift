//
//  MovieFeedTableViewCellDelegate.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 10/11/2020.
//

import Foundation

protocol MovieFeedTableViewCellDelegate {
    func favouriteButtonTapped(cell: MovieFeedTableViewCell)
    func watchedButtonTapped(cell: MovieFeedTableViewCell)
}
