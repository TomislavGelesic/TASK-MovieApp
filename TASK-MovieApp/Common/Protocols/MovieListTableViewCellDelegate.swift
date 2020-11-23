//
//  MovieCardDelegate.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 18.11.2020..
//

import Foundation

protocol MovieListTableViewCellDelegate {
    
    func buttonTapped(cell: MovieListTableViewCell, type: ButtonType)
}
