//
//  FavouriteMoviesFeedCellDelegate.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 10/11/2020.
//

import Foundation

protocol FavouriteMoviesFeedCellDelegate {
    func favouriteButtonTapped(cell: FavouriteMoviesFeedCell)
    func watchedButtonTapped(cell: FavouriteMoviesFeedCell)
}
