//
//  WatchedMoviesFeedCellDelegate.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 10/11/2020.
//

import Foundation

protocol WatchedMoviesFeedCellDelegate {
    func favouriteButtonTapped(cell: WatchedMoviesFeedCell)
    func watchedButtonTapped(cell: WatchedMoviesFeedCell)
}
