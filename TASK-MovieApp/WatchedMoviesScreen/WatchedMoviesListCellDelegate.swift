//
//  WatchedMoviesFeedCellDelegate.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 10/11/2020.
//

import Foundation

protocol WatchedMoviesListCellDelegate {
    func favouriteButtonTapped(cell: WatchedMoviesListCell)
    func watchedButtonTapped(cell: WatchedMoviesListCell)
}
