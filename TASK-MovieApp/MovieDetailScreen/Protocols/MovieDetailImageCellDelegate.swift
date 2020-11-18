//
//  DetailBarViewDelegate.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 05/11/2020.
//

import Foundation

protocol MovieDetailImageCellDelegate: class {
    func backButtonTapped()
    func favouriteButtonTapped(cell: MovieDetailImageCell)
    func watchedButtonTapped(cell: MovieDetailImageCell)
}
