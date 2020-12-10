//
//  MovieList.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit

struct MovieResponse: Codable {

    var results: [MovieResponseItem]
    var dates: Dates
    var totalPages: Int
    var totalResults: Int
}
