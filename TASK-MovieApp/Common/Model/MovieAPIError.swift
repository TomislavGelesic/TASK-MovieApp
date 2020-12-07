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
    case functionalError
    case other(Error)
    
    func map(_ error: Error) -> MovieAPIError {
        return (error as? MovieAPIError) ?? .other(error)
    }
}
