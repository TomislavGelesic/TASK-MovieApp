//
//  MovieNetworkError.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 07.12.2020..
//

import Foundation

enum MovieNetworkError: Error {
    case noDataError
    case decodingError
    case other(Error)
}
