//
//  MovieAPIError.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 07.12.2020..
//

import Foundation

enum MovieAPIError: Error {
    case noDataError
    case decodingError
    case other(Error)
}
