//
//  MovieFeedTableViewCellDelegate.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 10/11/2020.
//

import Foundation

protocol MovieListCellDelegate {
    func favouriteButtonTapped(cell: MoviesListCell)
    func watchedButtonTapped(cell: MoviesListCell)
}
