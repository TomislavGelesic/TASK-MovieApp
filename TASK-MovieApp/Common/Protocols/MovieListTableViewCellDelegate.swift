//
//  MovieCardDelegate.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 18.11.2020..
//

import Foundation

protocol MovieListTableViewCellDelegate {
    func favouriteButtonTapped(cell: MovieListTableViewCell)
    func watchedButtonTapped(cell: MovieListTableViewCell)
}
