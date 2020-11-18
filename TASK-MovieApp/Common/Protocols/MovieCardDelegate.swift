//
//  MovieCardDelegate.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 18.11.2020..
//

import Foundation

protocol MovieCardDelegate {
    func favouriteButtonTapped(cell: MovieCard)
    func watchedButtonTapped(cell: MovieCard)
}
