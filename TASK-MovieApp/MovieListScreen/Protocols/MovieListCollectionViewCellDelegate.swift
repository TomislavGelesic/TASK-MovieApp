//
//  MovieFeedTableViewCellDelegate.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 10/11/2020.
//

import Foundation

protocol MovieListCollectionViewCellDelegate {
    func favouriteButtonTapped(on id: Int64)
    func watchedButtonTapped(on id: Int64)
}
