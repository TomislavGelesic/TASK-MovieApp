//
//  ControllerDelegate.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 06/11/2020.
//

import Foundation

protocol ControllerDelegate {
    func favouriteButtonTapped(cell: WatchedMoviesFeedCell)
    func watchedButtonTapped(cell: WatchedMoviesFeedCell)
}
